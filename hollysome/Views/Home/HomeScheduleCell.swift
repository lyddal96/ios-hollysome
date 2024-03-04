//
//  HomeScheduleCell.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
import VisualEffectView

class HomeScheduleCell: UICollectionViewCell {

  @IBOutlet weak var roundView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var completeView: UIView!
  @IBOutlet weak var checkImageView: UIImageView!
  @IBOutlet weak var completeLabel: UILabel!
  
  var viewBlurEffect:UIVisualEffectView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
//    self.stateButton.setCornerRadius(radius: 12)
    self.roundView.setCornerRadius(radius: 12)
    self.roundView.addBorder(width: 1, color: UIColor(named: "F1F1F4")!)
//    self.stateButton.setTitle("미완료", for: .normal)
//    self.stateButton.setTitle("완료", for: .disabled)
//    self.stateButton.setTitleColor(UIColor(named: "C8CCD5"), for: .disabled)
//    self.stateButton.setBackgroundColor(UIColor(named: "E4E6EB")!, forState: .disabled)
    self.checkImageView.setCornerRadius(radius: 12)
    
    
  }
  
  // 일정 세팅
  func setSchedule(schedule: HouseModel) {
    self.titleLabel.text = schedule.plan_name ?? ""
    self.timeLabel.text = schedule.alarm_hour?.toInt() == nil ? "미정" : "\(schedule.alarm_hour == "12" ? "12" : String(format: "%02d", ((schedule.alarm_hour ?? "00").toInt() ?? 0) % 12)):00 \(((schedule.alarm_hour ?? "00").toInt() ?? 0) >= 12 ? "PM" : "AM" ) ~"
//    self.stateButton.isEnabled = schedule.schedule_yn != "Y"
//    self.stateButton.isHidden = true
    self.completeView.isHidden = schedule.schedule_yn != "Y"
    if schedule.schedule_yn == "Y" {
      let visualEffectView = VisualEffectView(frame: self.roundView.frame)
      visualEffectView.setCornerRadius(radius: 12)
      // Configure the view with tint color, blur radius, etc
      visualEffectView.colorTint = UIColor(named: "FFFFFF")
      visualEffectView.colorTintAlpha = 0.6
      visualEffectView.blurRadius = 1
      visualEffectView.scale = 1

      self.roundView.addSubview(visualEffectView)
    }
  }
}
