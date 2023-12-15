//
//  ScheduleExpandCell.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
class ScheduleExpandCell: UITableViewCell {
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var avatarView: UIView!
  @IBOutlet weak var shapeImageView: UIImageView!
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var checkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var pokeButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var roundView: UIView!
  
  
  var parentsViewController: TodayScheduleViewController? = nil
  override func awakeFromNib() {
    super.awakeFromNib()

    
    self.doneButton.setCornerRadius(radius: 15.5)
    self.pokeButton.setCornerRadius(radius: 15.5)
    
    self.avatarView.setCornerRadius(radius: 22)
  }
  
  
  func setMate(index: IndexPath) {
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
    
    self.shapeImageView.image = UIImage(named: "\(shapeList[index.row])71")
    self.faceImageView.image = UIImage(named: "face\(index.row)")
    self.colorView.backgroundColor = UIColor(named: "profile\(index.row)")
    self.avatarView.addBorder(width: 2, color: UIColor(named: index.section == 0 && index.row == 1 ? "accent" : "FFFFFF")!)
    self.doneButton.isHidden = !(index.section == 0 && index.row == 1)
    self.pokeButton.isHidden = index.section == 0 && index.row == 1
  }
}
