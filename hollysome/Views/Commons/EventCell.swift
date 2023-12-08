//
//  EventCell.swift
//  hollysome
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
