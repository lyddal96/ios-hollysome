//
//  QnaDetailTitleCell.swift
//  RocateerKit
//
//  Created by rocateer on 28/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
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
