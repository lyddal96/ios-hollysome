//
//  AddScheduleCell.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit

class AddScheduleCell: UITableViewCell {
  @IBOutlet weak var mateCollectionView: UICollectionView!
  @IBOutlet weak var weekCollectionView: UICollectionView!
  @IBOutlet weak var deleteButton: UIButton!
  
  var indexPath = IndexPath()
  var weekList = ["월", "화", "수", "목", "금", "토", "일"]
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.mateCollectionView.registerCell(type: MateCell.self)
    self.mateCollectionView.delegate = self
    self.mateCollectionView.dataSource = self
    
    self.weekCollectionView.registerCell(type: WeekCell.self)
    self.weekCollectionView.delegate = self
    self.weekCollectionView.dataSource = self
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension AddScheduleCell: UICollectionViewDelegate {
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension AddScheduleCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == self.mateCollectionView {
      return CGSize(width: 52, height: 74)
    } else {
      return CGSize(width: 32, height: 32)
    }
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension AddScheduleCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.mateCollectionView {
      return 3
    } else {
      return 7
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == mateCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
      cell.setMate(index: indexPath)
      cell.nameLabel.text = "메이트\(indexPath.row)"
      
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCell
      
      if indexPath.row == self.indexPath.row {
        cell.roundView.backgroundColor = UIColor(named: "accent")
        cell.weekLabel.textColor = UIColor(named: "FFFFFF")
      } else {
        cell.roundView.backgroundColor = UIColor(named: "E4E6EB")
        cell.weekLabel.textColor = UIColor(named: "C8CCD5")
      }
      cell.weekLabel.text = self.weekList[indexPath.row]
      
      return cell
    }
  }
}
