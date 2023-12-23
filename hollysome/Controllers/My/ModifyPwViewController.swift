//
//  ModifyPwViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/21/23.
//

import UIKit
import Defaults

class ModifyPwViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var newPwTextField: UITextField!
  @IBOutlet weak var newPwConfirmTextField: UITextField!
  @IBOutlet weak var modifyButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.passwordTextField.setCornerRadius(radius: 4)
    self.passwordTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.passwordTextField.setTextPadding(16)
    self.newPwTextField.setCornerRadius(radius: 4)
    self.newPwTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.newPwTextField.setTextPadding(16)
    self.newPwConfirmTextField.setCornerRadius(radius: 4)
    self.newPwConfirmTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.newPwConfirmTextField.setTextPadding(16)
    
    self.modifyButton.setCornerRadius(radius: 4)
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
  func pwModUpAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.member_pw = self.passwordTextField.text
    memberRequest.member_new_pw = self.newPwTextField.text
    memberRequest.member_confirm_pw = self.newPwConfirmTextField.text
    
    APIRouter.shared.api(path: .pw_mod_up, method: .post, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse, alertYn: true) {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "비밀번호가 변경되었습니다.", aStrMessage: "", alertViewHiddenCheck: false, img: "check_circle") { position, title in
          Defaults[.member_pw] = self.newPwTextField.text
          self.navigationController?.popViewController(animated: true)
        }
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 비밀번호 변경
  /// - Parameter sender: 버튼
  @IBAction func modifyButtonTouched(sender: UIButton) {
    self.pwModUpAPI()
  }
}
