//
//  ScheduleCell.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit

class ScheduleCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mateCollectionView: UICollectionView!

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.mateCollectionView.registerCell(type: MateCell.self)
    self.mateCollectionView.dataSource = self
    self.mateCollectionView.delegate = self
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension ScheduleCell: UICollectionViewDelegate {
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension ScheduleCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 52, height: 74)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension ScheduleCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
    cell.setMate(index: indexPath)
    cell.nameLabel.text = "메이트\(indexPath.row)"
    
    return cell
  }
}
