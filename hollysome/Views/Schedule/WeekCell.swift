//
//  WeekCell.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit

class WeekCell: UICollectionViewCell {

  @IBOutlet weak var weekLabel: UILabel!
  @IBOutlet weak var roundView: UIView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.roundView.setCornerRadius(radius: 8)
  }
}
