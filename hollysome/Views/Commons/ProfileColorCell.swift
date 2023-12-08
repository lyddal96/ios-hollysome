//
//  ProfileColorCell.swift
//  hollysome
//
//  Created by 이승아 on 10/10/23.
//
//

import UIKit
class ProfileColorCell: UICollectionViewCell {
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var grayView: UIView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.colorView.setCornerRadius(radius: 4)
    self.grayView.setCornerRadius(radius: 12)
  }
}
