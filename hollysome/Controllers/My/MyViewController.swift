//
//  MyViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/05/26.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit
import Defaults

class MyViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var beforeLoginView: UIView!
  @IBOutlet weak var memberView: UIView!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var birthLabel: UILabel!
  @IBOutlet weak var followerLabel: UILabel!
  @IBOutlet weak var followingLabel: UILabel!
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var noticeButton: UIButton!
  @IBOutlet weak var faqButton: UIButton!
  @IBOutlet weak var qnaButton: UIButton!
  @IBOutlet weak var authButton: UIButton!
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
    
    self.noticeButton.addShadow(cornerRadius: 25)
    self.faqButton.addShadow(cornerRadius: 25)
    self.qnaButton.addShadow(cornerRadius: 25)
    self.authButton.addShadow(cornerRadius: 25)
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.beforeLoginView.isHidden = !Defaults[.access_token].isNil
    self.memberView.isHidden = Defaults[.access_token].isNil
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 사용자 프로필 정보 확인
 
  
  func logoutAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    APIRouter.shared.api(path: .logout, parameters: memberRequest.toJSON()) { data in
      if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.resetDefaults()
        
        self.beforeLoginView.isHidden = false
        self.memberView.isHidden = true
      }
    }

  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 로그인
  /// - Parameter sender: 버튼
  @IBAction func loginButtonTouched(sender: UIButton) {
    let destination = LoginViewController.instantiate(storyboard: "Login")
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 공지사항
  /// - Parameter sender: 버튼
  @IBAction func noticeButtonTouched(sender: UIButton) {
    self.loginCheck {
      let destination = NoticeViewController.instantiate(storyboard: "Commons")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
  }
  
  /// FAQ
  /// - Parameter sender: 버튼
  @IBAction func faqButtonTouched(sender: UIButton) {
    self.loginCheck {
      let destination = FaqViewController.instantiate(storyboard: "Commons")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
  }
  
  /// 1:1문의
  /// - Parameter sender: 버튼
  @IBAction func qnaButtonTouched(sender: UIButton) {
    self.loginCheck {
      let destination = QnaViewController.instantiate(storyboard: "Commons")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
  }
  
  /// 이용약관
  /// - Parameter sender: 버튼
  @IBAction func authButtonTouched(sender: UIButton) {
    let destination = WebViewController.instantiate(storyboard: "Commons")
    destination.webType = .address
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 로그아웃
  /// - Parameter sender: 버튼
  @IBAction func logoutButtonTouched(sender: UIButton) {
    AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "로그아웃 하시겠습니까?", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
      if position == 1 {
        self.logoutAPI()
      }
    }
  }
}
