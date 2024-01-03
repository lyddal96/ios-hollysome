//
//  AddScheduleCell.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit
import Defaults

class AddScheduleCell: UITableViewCell {
  @IBOutlet weak var mateCollectionView: UICollectionView!
  @IBOutlet weak var weekCollectionView: UICollectionView!
  @IBOutlet weak var deleteButton: UIButton!
  
  var plan = PlanModel()

  var weekList = ["일", "월", "화", "수", "목", "금", "토"]
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.mateCollectionView.registerCell(type: MateCell.self)
    self.mateCollectionView.delegate = self
    self.mateCollectionView.dataSource = self
    
    self.weekCollectionView.registerCell(type: WeekCell.self)
    self.weekCollectionView.delegate = self
    self.weekCollectionView.dataSource = self
  }

  func setPlan(plan: PlanModel) {
    self.plan = plan
    if let schedule_member_list = plan.schedule_member_list {
      self.plan.selected_mate_list = schedule_member_list
    }
    self.weekCollectionView.reloadData()
    self.mateCollectionView.reloadData()
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
      return self.plan.selected_mate_list?.count ?? 0
    } else {
      return 7
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == mateCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
//      cell.setMate(index: indexPath)
//      cell.nameLabel.text = "메이트\(indexPath.row)"
      if let mate = self.plan.selected_mate_list?[indexPath.row] {
        cell.nameLabel.text = mate.member_nickname ?? ""
        cell.avatarView.addBorder(width: 2, color: UIColor(named: mate.member_idx == Defaults[.member_idx] ? "accent" : "FFFFFF")!)
        cell.shapeImageView.image = UIImage(named: "\(Constants.SHAPE_LIST[mate.member_role1?.toInt() ?? 0])71")
        cell.faceImageView.image = UIImage(named: "face\(mate.member_role2?.toInt() ?? 0)")
        cell.colorView.backgroundColor = UIColor(named: "profile\(mate.member_role3?.toInt() ?? 0)")
      }

      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCell
      
      if self.plan.week_arr?.contains("\(indexPath.row + 1)") ?? false {
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
