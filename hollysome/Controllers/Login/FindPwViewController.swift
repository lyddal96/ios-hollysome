//
//  FindPwViewController.swift
//  hollysome
//

import UIKit

class FindPwViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var nicknameTextField: UITextField!
  @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var okButton: UIButton!
  @IBOutlet weak var notFoundPwLabel: UILabel!
  @IBOutlet weak var foundPwWrapView: UIView!
  
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
   
  }
  
  override func initRequest() {
    super.initRequest()
  }

  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// Pw 찾기
//  func findPwAPI() {
//    let memberRequest = MemberModel()
//    memberRequest.member_nickname = self.nicknameTextField.text
//    memberRequest.member_id = self.idTextField.text
//
//    APIRouter.shared.api(path: .member_pw_reset_send_email, parameters: memberRequest.toJSON()) { response in
//      if let memberResponse = MemberModel(JSON: response) {
//        if memberResponse.code == "1000" {
//          self.foundPwWrapView.isHidden = false
//        } else if memberResponse.code == "-2" {
//          self.notFoundPwLabel.isHidden = false
//          self.foundPwWrapView.isHidden = true
//        } else {
//          Tools.shared.showToast(message: memberResponse.code_msg ?? "")
//        }
//      }
//    } 
//
//    self.notFoundPwLabel.isHidden = true
//    self.foundPwWrapView.isHidden = false
//  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  /// 비밀번호 찾기
  /// - Parameter sender: 버튼
  @IBAction func okButtonTouched(sender: UIButton) {
//    self.findPwAPI()
  }
  
}


