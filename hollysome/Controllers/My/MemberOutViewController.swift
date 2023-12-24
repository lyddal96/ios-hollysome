//
//  MemberOutViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/25/23.
//

import UIKit
import Defaults

class MemberOutViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var agreeButton: UIButton!
  @IBOutlet weak var reasonTextView: UITextView!
  @IBOutlet weak var memberOutButton: UIButton!
  @IBOutlet weak var reasonView: UIView!
  @IBOutlet weak var dot1View: UIView!
  @IBOutlet weak var dot2View: UIView!
  @IBOutlet weak var noticeView: UIView!
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
    self.reasonView.setCornerRadius(radius: 8 )
    self.reasonView.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
    self.memberOutButton.setCornerRadius(radius: 12)
    self.dot1View.setCornerRadius(radius: 1.5)
    self.dot2View.setCornerRadius(radius: 1.5)
    self.noticeView.setCornerRadius(radius: 8)
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
  /// 회원 탈퇴 API
  func memberOutAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.member_leave_yn = "Y"
    memberRequest.member_leave_reason = self.reasonTextView.text
    
    APIRouter.shared.api(path: .member_out_up, method: .post, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse, alertYn: true) {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "회원 탈퇴가 완료되었습니다.\n서비스를 이용해 주셔서 감사합니다.", aStrMessage: "", alertViewHiddenCheck: false, img: "check_circle") { position, title in
          if position == 0 {
            self.resetDefaults()
            self.gotoLogin()
          }
        }
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 안내사항을 모두 확인하였으며, 이에 동의합니다.
  /// - Parameter sender: 버튼
  @IBAction func agreeButtonTouched(sender: UIButton) {
    self.agreeButton.isSelected = !self.agreeButton.isSelected
  }
  
  /// 탈퇴하기
  /// - Parameter sender: 버튼
  @IBAction func memberOutButtonTouched(sender: UIButton) {
    if self.agreeButton.isSelected == false {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "동의에 체크해 주세요.", aStrMessage: "", alertViewHiddenCheck: false, img: "error_circle") { position, title in
      }
    } else {
      self.memberOutAPI()
    }
  }
}
