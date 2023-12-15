//
//  EmptyTableCell.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
class EmptyTableCell: UITableViewCell {
  @IBOutlet weak var roundView: UIView!
  @IBOutlet weak var emptyLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.roundView.setCornerRadius(radius: 12)
  }
}
