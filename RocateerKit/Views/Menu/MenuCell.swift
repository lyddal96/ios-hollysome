//
//  MenuCell.swift
//  RocateerKit
//
//  Created by rocateer on 2020/01/09.
//  Copyright © 2020 rocateer. All rights reserved.
//
import UIKit

class MenuCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var titleLeft: NSLayoutConstraint!
  
  override class func awakeFromNib() {
    super.awakeFromNib()
  }
}

