//
//  EventCell.swift
//  hollysome
//
//  Created by rocateer on 2020/01/17.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
  
  @IBOutlet weak var eventImageView: UIImageView!
  @IBOutlet weak var eventTitleLabel: UILabel!
  @IBOutlet weak var evnetDateLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
}
