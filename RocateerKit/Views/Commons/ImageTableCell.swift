//
//  ImageTableCell.swift
//  RocateerKit
//
//  Created by 이승아 on 2023/05/30.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit

class ImageTableCell: UITableViewCell {
  @IBOutlet weak var cellImageView: UIImageView!
  @IBOutlet weak var imageHeight: NSLayoutConstraint!

  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
