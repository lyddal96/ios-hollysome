//
//  HouseNoticeCell.swift
//  hollysome
//
//  Created by 이승아 on 12/16/23.
//

import UIKit

class HouseNoticeCell: UITableViewCell {
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var avatarView: UIView!
  @IBOutlet weak var contentLabel:UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var shapeImageView: UIImageView!
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var modifyButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var cancelBlockButton: UIButton!
  @IBOutlet weak var blockView: UIView!
  @IBOutlet weak var blockLabel: UILabel!
  @IBOutlet weak var roundView: UIView!
  @IBOutlet weak var nameLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.avatarView.setCornerRadius(radius: 17)
    self.modifyButton.setCornerRadius(radius: 12)
    self.deleteButton.setCornerRadius(radius: 12)
    self.cancelBlockButton.setCornerRadius(radius: 15.5)
    self.roundView.setCornerRadius(radius: 12)
  }
}
