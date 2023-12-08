//
//  QnaListCell.swift
//  hollysome
//

import UIKit

class QnaListCell: UITableViewCell {
  
  @IBOutlet weak var qnaTitleLabel: UILabel!
  @IBOutlet weak var qnaDateLabel: UILabel!
  @IBOutlet weak var stateView: UIView!
  @IBOutlet weak var stateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.stateView.setCornerRadius(radius: 15)
  }
}
