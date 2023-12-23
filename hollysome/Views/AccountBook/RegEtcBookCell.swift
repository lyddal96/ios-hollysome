//
//  RegEtcBookCell.swift
//  hollysome
//
//  Created by 이승아 on 12/22/23.
//

import UIKit

class RegEtcBookCell: UITableViewCell {
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var priceTextField: UITextField!
  @IBOutlet weak var namaTitleLabel: UILabel!
  
  var parentsViewController: RegAccountBookViewController?
  var indexPath = IndexPath()

  override func awakeFromNib() {
    super.awakeFromNib()
    
    
    self.nameTextField.setCornerRadius(radius: 4)
    self.nameTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.nameTextField.setTextPadding(15)
    
    self.priceTextField.setCornerRadius(radius: 4)
    self.priceTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.priceTextField.setTextPadding(15)
  }
  
  @IBAction func textFieldDidChange(sender: UITextField) {
    if sender == self.nameTextField {
      self.parentsViewController?.item_array[self.indexPath.row].item_name = self.nameTextField.text
      if (sender.text?.count ?? 0 > 0) {
        sender.addBorder(width: 1, color: UIColor(named: "87B7FF")!)
      } else {
        sender.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
      }
    } else {
      self.parentsViewController?.item_array[self.indexPath.row].item_bill = "\(self.priceTextField.text?.toInt() ?? 0)"
      if (sender.text?.toInt() ?? 0 > 0) {
        sender.addBorder(width: 1, color: UIColor(named: "87B7FF")!)
      } else {
        sender.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
      }
    }
    
    self.parentsViewController?.item_array[self.indexPath.row].item_no = "\(self.indexPath.row)"
  }
}
