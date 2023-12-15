//
//  ScheduleTitleCell.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
import ExpyTableView

class ScheduleTitleCell: UITableViewCell, ExpyTableViewHeaderCell {
  @IBOutlet weak var isExpandedImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var bottomRoundView: UIView!
  @IBOutlet weak var topRoundView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.topRoundView.roundCorners(cornerRadius: 12, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    self.bottomRoundView.roundCorners(cornerRadius: 12, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    self.isExpandedImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi))
  }
  
  
  func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
    
    switch state {
    case .willExpand:
//      print("WILL EXPAND")
      arrowDown(animated: !cellReuse)
      self.bottomRoundView.isHidden = true
      break
    case .willCollapse:
//      print("WILL COLLAPSE")
      arrowRight(animated: !cellReuse)
      self.bottomRoundView.isHidden = false
      break
    case .didExpand:
//      print("DID EXPAND")
      break
    case .didCollapse:
//      print("DID COLLAPSE")
      break
    }
  }
  
  private func arrowDown(animated: Bool) {
    UIView.animate(withDuration: (animated ? 0.3 : 0)) {
      self.isExpandedImageView.transform = CGAffineTransform(rotationAngle: 0)
    }
  }
  
  private func arrowRight(animated: Bool) {
    UIView.animate(withDuration: (animated ? 0.3 : 0)) {
      self.isExpandedImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi))
    }
  }
}
