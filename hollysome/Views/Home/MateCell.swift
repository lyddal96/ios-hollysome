//
//  MateCell.swift
//  hollysome
//
//  Created by 이승아 on 12/14/23.
//

import UIKit
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
  
  // 메이트 세팅
  func setMate(index: IndexPath) {
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]

    self.shapeImageView.image = UIImage(named: "\(shapeList[index.row])71")
    self.faceImageView.image = UIImage(named: "face\(index.row)")
    self.colorView.backgroundColor = UIColor(named: "profile\(index.row)")
    self.avatarView.addBorder(width: 2, color: UIColor(named: index.row == 0 ? "accent" : "FFFFFF")!)
  }
}
