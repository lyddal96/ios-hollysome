//
//  HomeScheduleTableCell.swift
//  hollysome
//
//  Created by 이승아 on 2/27/24.
//

import UIKit
class HomeScheduleTableCell: UITableViewCell {
  @IBOutlet weak var roundView: UIView!
  @IBOutlet weak var checkImageView: UIImageView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.roundView.setCornerRadius(radius: 8)
  }
  
  func setPlan(plan: HouseModel) {
    self.titleLabel.text = plan.plan_name ?? ""
    self.timeLabel.text = plan.alarm_hour?.toInt() == nil ? "미정" : "\(plan.alarm_hour ?? "")시"
    self.checkImageView.image = plan.schedule_yn == "Y" ? UIImage(named: "home_check_on") : UIImage(named: "home_check_off")
  }
}
