//
//  EventDetailCell.swift
//  hollysome
//
//  Created by rocateer on 2020/01/17.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class EventDetailCell: UITableViewCell {
  
  @IBOutlet weak var eventTitleLabel: UILabel!
  @IBOutlet weak var eventDateLabel: UILabel!
  @IBOutlet weak var eventContentsLabel: UILabel!
  @IBOutlet weak var eventImageView: UIImageView!
  @IBOutlet weak var imageHeight: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
