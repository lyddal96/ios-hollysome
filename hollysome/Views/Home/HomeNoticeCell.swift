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
  
  func setNotice(index: IndexPath) {
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]

    self.shapeImageView.image = UIImage(named: "\(shapeList[index.row])71")
    self.faceImageView.image = UIImage(named: "face\(index.row)")
    self.colorView.backgroundColor = UIColor(named: "profile\(index.row)")
    
    self.contentLabel.text = "보일러 수리기사님이 1월 10일 오전에 방문하기로 했습니다~~~~~~~"
    self.timeLabel.text = "23-01-02 00:00"
  }
}
