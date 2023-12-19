//
//  DailyCell.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit

class DailyCell: UICollectionViewCell {
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var weekLabel: UILabel!
  @IBOutlet weak var todayLabel: UILabel!
  @IBOutlet weak var roundView: UIView!
  

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.roundView.setCornerRadius(radius: 10)
  }
  
  
  func setDate(date: Date, isSelected: Bool) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    self.weekLabel.text = dateFormatter.string(from: date)
    dateFormatter.dateFormat = "d"
    self.dayLabel.text = dateFormatter.string(from: date)
    self.todayLabel.isHidden = !date.isToday
    self.roundView.backgroundColor = UIColor(named: isSelected ? "accent" : "FAFAFC")
    self.dayLabel.textColor = UIColor(named: isSelected ? "FFFFFF" : "A3A7B6")
    self.weekLabel.textColor = UIColor(named: isSelected ? "FFFFFF" : "A3A7B6")
  }
}
