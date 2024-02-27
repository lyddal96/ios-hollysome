//
//  FindPwViewController.swift
//  hollysome
//

import UIKit

class FindPwViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var okButton: UIButton!
  @IBOutlet weak var notFoundPwLabel: UILabel!
  //  @IBOutlet weak var foundPwWrapView: UIView!
  @IBOutlet weak var foundLabel: UILabel!
  @IBOutlet weak var idCheckLabel: UILabel!
  @IBOutlet weak var checkDotImageView: UIImageView!
  @IBOutlet weak var checkView: UIView!
  @IBOutlet weak var idView: UIView!
  @IBOutlet weak var emailCheckLabel: UILabel!
  @IBOutlet weak var emailcheckDotImageView: UIImageView!
  @IBOutlet weak var emailcheckView: UIView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.idTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.idView.setCornerRadius(radius: 4)
    self.emailTextField.setCornerRadius(radius: 4)
    self.idView.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.emailTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.emailTextField.setTextPadding(15)
    self.okButton.setCornerRadius(radius: 8)
  }
  
  override func initRequest() {
    super.initRequest()
  }

  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// Pw 찾기
  func findPwAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_email = self.emailTextField.text
    memberRequest.member_id = self.idTextField.text

    APIRouter.shared.api(path: .member_pw_reset_send_email, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response) {
        if memberResponse.code == "1000" {
          self.notFoundPwLabel.isHidden = true
          self.foundLabel.isHidden = false
        } else if memberResponse.code == "-2" {
          self.notFoundPwLabel.isHidden = false
          self.foundLabel.isHidden = true
        } else {
          Tools.shared.showToast(message: memberResponse.code_msg ?? "")
        }
      }
    }
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    if textField == self.idTextField {
      self.checkView.isHidden = true
      self.idView.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    } else {
      self.emailcheckView.isHidden = true
      self.emailTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  /// 비밀번호 찾기
  /// - Parameter sender: 버튼
  @IBAction func okButtonTouched(sender: UIButton) {
    if self.idTextField.text?.count ?? 0 == 0 {
      self.checkView.isHidden = false
      self.idCheckLabel.text = "아이디를 입력해주세요."
      self.idView.addBorder(width: 1, color: UIColor(named: "accent")!)
    } else if self.emailTextField.text?.count ?? 0 == 0 || self.emailTextField.text?.isEmail ?? false == false {
      self.emailcheckView.isHidden = false
      self.emailCheckLabel.text = "이메일을 입력해주세요."
      self.emailTextField.addBorder(width: 1, color: UIColor(named: "accent")!)
    } else {
      self.findPwAPI()
    }
  }
  
}
