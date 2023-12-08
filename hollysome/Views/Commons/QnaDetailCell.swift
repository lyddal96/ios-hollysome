//
//  QnaDetailTitleCell.swift
//  hollysome
//

import UIKit

class QnaDetailCell: UITableViewCell {
  
  @IBOutlet weak var qnaTitleLabel: UILabel!
  @IBOutlet weak var qnaDateLabel: UILabel!
  @IBOutlet weak var qnaContentsLabel: UILabel!
  @IBOutlet weak var replyLabel: UILabel!
  @IBOutlet weak var replyDateLabel: UILabel!
  @IBOutlet weak var replyWrapView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
