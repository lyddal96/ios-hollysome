//
//  FindIdViewController.swift
//  hollysome
//

import UIKit

class FindIdViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var nicknameTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var notFoundIdLabel: UILabel!
  @IBOutlet weak var foundIdWrapView: UIView!
  @IBOutlet weak var foundIdLabel: UILabel!
  
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
  /// ID 찾기
//  func findIdAPI() {
//    let memberRequest = MemberModel()
//    memberRequest.member_nickname = self.nicknameTextField.text
//    memberRequest.member_phone = self.phoneTextField.text
//  
//    APIRouter.shared.api(path: .member_id_find, parameters: memberRequest.toJSON()) { response in
//      self.view.endEditing(true)
//      if let memberResponse = MemberModel(JSON: response) {
//        if memberResponse.code == "1000" {
//          self.foundIdLabel.text = memberResponse.member_id ?? ""
//          self.foundIdWrapView.isHidden = false
//        } else if memberResponse.code == "-2" {
//          self.notFoundIdLabel.isHidden = false
//          self.foundIdWrapView.isHidden = true
//        } else {
//        }
//      }
  
//    }
//  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 아이디 찾기 확인 버튼 처리시
  ///
  /// - Parameter sender: 버튼
  @IBAction func okButtonTouched(sender: UIButton) {
//    self.findIdAPI()
  }
}
