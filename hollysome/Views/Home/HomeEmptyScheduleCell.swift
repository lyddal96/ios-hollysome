//
//  HomeEmptyScheduleCell.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
class HomeEmptyScheduleCell: UICollectionViewCell {
  @IBOutlet weak var roundView: UIView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.roundView.setCornerRadius(radius: 12)
  }
}
