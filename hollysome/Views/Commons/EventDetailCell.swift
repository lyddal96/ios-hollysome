//
//  EventDetailCell.swift
//  hollysome
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
