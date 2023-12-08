//
//  EmailJoinViewController.swift
//  hollysome
//
//  Created by 이승아 on 10/23/23.
//
//

import UIKit


class EmailJoinViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var pwTextField: UITextField!
  @IBOutlet weak var confirmPwTextField: UITextField!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var idCheckButton: UIButton!
  @IBOutlet weak var idCheckLabel: UILabel!
  @IBOutlet weak var checkDotImageView: UIImageView!
  @IBOutlet weak var checkView: UIView!
  @IBOutlet weak var idView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var isIdChecked = false
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
    
    self.idView.setCornerRadius(radius: 4)
    self.emailTextField.setCornerRadius(radius: 4)
    self.pwTextField.setCornerRadius(radius: 4)
    self.confirmPwTextField.setCornerRadius(radius: 4)
    self.nextButton.setCornerRadius(radius: 12)
    self.idCheckButton.setCornerRadius(radius: 12)
    
    self.idView.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.emailTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.pwTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.confirmPwTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    
    self.emailTextField.setTextPadding(15)
    self.pwTextField.setTextPadding(15)
    self.confirmPwTextField.setTextPadding(15)
    
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
  /// 아이디 중복확인
  func memberIdCheckAPI() {
    let idRequest = MemberModel()
    idRequest.member_id = self.idTextField.text
    
    APIRouter.shared.api(path: .member_id_check, method: .post, parameters: idRequest.toJSON()) { response in
      if let idResponse = MemberModel(JSON: response) {
        self.checkView.isHidden = false
        self.idCheckLabel.text = idResponse.code_msg ?? ""
        self.isIdChecked = idResponse.id_check == "Y"
        if let id_check = idResponse.id_check {
          self.idCheckLabel.textColor = id_check == "Y" ? UIColor(named: "87B7FF") : UIColor(named: "FF2525")
          self.checkDotImageView.image = id_check == "Y" ? UIImage(named: "blue_dot") : UIImage(named: "red_dot")
          self.idView.addBorder(width: 1, color: id_check == "Y" ? UIColor(named: "87B7FF")! : UIColor(named: "FF2525")!)
        } else {
          self.idCheckLabel.textColor = UIColor(named: "FF2525")
          self.checkDotImageView.image = UIImage(named: "red_dot")
          self.idView.addBorder(width: 1, color: UIColor(named: "FF2525")!)
        }
      }
    }
  }
  
  func pwEmailCheckAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_id = self.idTextField.text
    memberRequest.member_email = self.emailTextField.text
    memberRequest.member_pw = self.pwTextField.text
    memberRequest.member_pw_confirm = self.confirmPwTextField.text
    
    APIRouter.shared.api(path: .passwordemail_check_in, parameters: memberRequest.toJSON()) { data in
      if let memberResponse = MemberModel(JSON: data) {
        if memberResponse.code == "1000" {
          let destination = JoinViewController.instantiate(storyboard: "Login")
          destination.memberRequest = memberRequest
          self.navigationController?.pushViewController(destination, animated: true)
        } else {
          AJAlertController.initialization().showAlertWithOkButton(astrTitle: memberResponse.code_msg ?? "", aStrMessage: "", alertViewHiddenCheck: false, img: "error_circle") { position, title in
            
          }
        }
        
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 중복확인
  /// - Parameter sender: 버튼
  @IBAction func idCheckButtonTouched(sender: UIButton) {
    self.memberIdCheckAPI()
  }
  
  /// 다음
  /// - Parameter sender: 버튼
  @IBAction func nextButtonTouched(sender: UIButton) {
    if self.isIdChecked {
      self.pwEmailCheckAPI()
    } else {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "아이디 중복 확인이 필요합니다.", aStrMessage: "", alertViewHiddenCheck: false, img: "error_circle") { position, title in
        
      }
    }
  }
}
