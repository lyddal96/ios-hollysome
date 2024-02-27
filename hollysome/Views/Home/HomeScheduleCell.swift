//
//  HomeScheduleCell.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
class HomeScheduleCell: UICollectionViewCell {

  @IBOutlet weak var roundView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var stateButton: UIButton!
  @IBOutlet weak var checkImageView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.stateButton.setCornerRadius(radius: 12)
    self.roundView.setCornerRadius(radius: 12)
    self.stateButton.setTitle("미완료", for: .normal)
    self.stateButton.setTitle("완료", for: .disabled)
    self.stateButton.setTitleColor(UIColor(named: "C8CCD5"), for: .disabled)
    self.stateButton.setBackgroundColor(UIColor(named: "E4E6EB")!, forState: .disabled)
    
  }
  
  // 일정 세팅
  func setSchedule(schedule: HouseModel) {
    self.titleLabel.text = schedule.plan_name ?? ""
    self.timeLabel.text = schedule.alarm_hour?.toInt() == nil ? "미정" : "\(schedule.alarm_hour ?? "")시"
    self.stateButton.isEnabled = schedule.schedule_yn != "Y"
    self.stateButton.isHidden = true
    self.checkImageView.isHidden = schedule.schedule_yn != "Y"
  }
}
