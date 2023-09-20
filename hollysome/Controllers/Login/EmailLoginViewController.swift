//
//  EmailLoginViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/09/11.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit

class EmailLoginViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var pwTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var emailErrorView: UIView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.emailTextField.delegate = self
    self.pwTextField.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.emailTextField.setCornerRadius(radius: 4)
    self.pwTextField.setCornerRadius(radius: 4)
    self.loginButton.setCornerRadius(radius: 12)
    self.loginButton.setBackgroundColor(UIColor(named: "E4E6EB")!, forState: .disabled)
    self.loginButton.setTitleColor(UIColor(named: "C8CCD5"), for: .disabled)
    
    self.loginButton.setBackgroundColor(UIColor(named: "accent")!, forState: .normal)
    self.loginButton.setTitleColor(UIColor(named: "FFFFFF"), for: .normal)
    
    self.emailTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.pwTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    
    self.emailTextField.setTextPadding(16)
    self.pwTextField.setTextPadding(16)
  }
  
  override func initRequest() {
    super.initRequest()
    
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 로그인하기
  /// - Parameter sender: 버튼
  @IBAction func loginButtonTouched(sender: UIButton) {
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITextFieldDelegate
//-------------------------------------------------------------------------------------------
extension EmailLoginViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField == self.emailTextField {
      if textField.text?.count ?? 0 == 0 {
        textField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
        self.emailErrorView.isHidden = true
      } else if textField.text?.isEmail ?? false {
        textField.addBorder(width: 1, color: UIColor(named: "87B7FF")!)
        self.emailErrorView.isHidden = true
      } else {
        textField.addBorder(width: 1, color: UIColor(named: "ERROR")!)
        self.emailErrorView.isHidden = false
      }
    }
    
    self.loginButton.isEnabled = self.pwTextField.text?.count ?? 0 > 0 && self.emailTextField.text?.isEmail ?? false == true
    
    
    return true
  }
}
