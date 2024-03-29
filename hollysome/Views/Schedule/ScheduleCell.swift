//
//  ScheduleCell.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit
import Defaults

class ScheduleCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mateCollectionView: UICollectionView!
  @IBOutlet weak var detailArrowImageView: UIImageView!
  @IBOutlet weak var titleRightConstraint: NSLayoutConstraint!

  var plan = PlanModel()
  var isCalendar = false

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.mateCollectionView.registerCell(type: MateCell.self)
    self.mateCollectionView.dataSource = self
    self.mateCollectionView.delegate = self
  }

  func setPlan(plan: PlanModel, isCalendar: Bool = false) {
    self.plan = plan
    self.titleLabel.text = plan.plan_name ?? ""
    self.mateCollectionView.reloadData()
    self.isCalendar = isCalendar
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
    return self.isCalendar ? self.plan.schedule_item_member_list?.count ?? 0 : self.plan.member_list?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
    
    if let mate = self.isCalendar ? self.plan.schedule_item_member_list?[indexPath.row] : self.plan.member_list?[indexPath.row] {
      cell.nameLabel.text = mate.member_nickname ?? ""
      cell.avatarView.addBorder(width: 2, color: UIColor(named: mate.member_idx == Defaults[.member_idx] ? "accent" : "FFFFFF")!)
      cell.shapeImageView.image = UIImage(named: "\(Constants.SHAPE_LIST[mate.member_role1?.toInt() ?? 0])71")
      cell.faceImageView.image = UIImage(named: "face\(mate.member_role2?.toInt() ?? 0)")
      cell.colorView.backgroundColor = UIColor(named: "profile\(mate.member_role3?.toInt() ?? 0)")
      if self.isCalendar {
        cell.selectImageView.isHidden = mate.schedule_yn != "Y"
      }
    }
    
    return cell
  }
}
