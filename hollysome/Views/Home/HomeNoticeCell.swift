//
//  HomeNoticeCell.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
class HomeNoticeCell: UITableViewCell {
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var avatarView: UIView!
  @IBOutlet weak var contentLabel:UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var shapeImageView: UIImageView!
  @IBOutlet weak var faceImageView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func setNotice(note: HouseModel) {
    self.avatarView.setCornerRadius(radius: 17)
    self.shapeImageView.image = UIImage(named: "\(Constants.SHAPE_LIST[note.member_role1?.toInt() ?? 0])71")
    self.faceImageView.image = UIImage(named: "face\(note.member_role2?.toInt() ?? 0)")
    self.colorView.backgroundColor = UIColor(named: "profile\(note.member_role3?.toInt() ?? 0)")
    
    self.contentLabel.text = note.contents ?? ""
    self.timeLabel.text = note.ins_date ?? ""
  }
}
