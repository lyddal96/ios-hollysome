//
//  MateCell.swift
//  hollysome
//
//  Created by 이승아 on 12/14/23.
//

import UIKit
import Defaults

class MateCell: UICollectionViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var avatarView: UIView!
  @IBOutlet weak var shapeImageView: UIImageView!
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var selectImageView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.avatarView.setCornerRadius(radius: 26)
  }
  

  func setMate(mate: MemberModel) {
    self.nameLabel.text = mate.member_nickname ?? ""
    self.avatarView.addBorder(width: 2, color: UIColor(named: mate.member_idx == Defaults[.member_idx] ? "accent" : "FFFFFF")!)
    self.shapeImageView.image = UIImage(named: "\(Constants.SHAPE_LIST[mate.member_role1?.toInt() ?? 0])71")
    self.faceImageView.image = UIImage(named: "face\(mate.member_role2?.toInt() ?? 0)")
    self.colorView.backgroundColor = UIColor(named: "profile\(mate.member_role3?.toInt() ?? 0)")
  }
}
