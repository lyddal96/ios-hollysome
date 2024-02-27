//
//  LastAccountBookCell.swift
//  hollysome
//
//  Created by 이승아 on 12/19/23.
//

import UIKit
import ExpyTableView

class LastAccountBookCell: UITableViewCell, ExpyTableViewHeaderCell {
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var priceLabe: UILabel!
  @IBOutlet weak var isExpandedImageView: UIImageView!
  
  var isLast = false
  var section = 0
  var dataCnt = 0
  var parentsViewController: AccountBookViewController?
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
    
    switch state {
    case .willExpand:
      //      print("WILL EXPAND")
      arrowDown(animated: !cellReuse)
      if self.isLast {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          self.parentsViewController?.accountBookTableView.scrollToRow(at: IndexPath(row: 2, section: self.section), at: .bottom, animated: true)
        }
      }
      break
    case .willCollapse:
      //      print("WILL COLLAPSE")
      arrowRight(animated: !cellReuse)
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
