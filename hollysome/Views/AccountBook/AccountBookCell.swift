//
//  AccountBookCell.swift
//  hollysome
//
//  Created by 이승아 on 12/19/23.
//

import UIKit

class AccountBookCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var divideButton: UIButton!
  @IBOutlet weak var totalView: UIView!
  @IBOutlet weak var totalPriceLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
}
