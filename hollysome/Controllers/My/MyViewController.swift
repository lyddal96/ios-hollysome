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
  @IBOutlet weak var avatarShapeImageView: UIImageView!
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var idView: UIView!
  @IBOutlet weak var loginTypeImageView: UIImageView!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var inputHouseCodeView: UIView!
  @IBOutlet weak var inviteView: UIView!
  @IBOutlet weak var modifyInfoView: UIView!
  @IBOutlet weak var alarmView: UIView!
  @IBOutlet weak var noticeView: UIView!
  @IBOutlet weak var qnaView: UIView!
  @IBOutlet weak var termsView: UIView!
  @IBOutlet weak var outHouseView: UIView!
  @IBOutlet weak var logoutView: UIView!
  @IBOutlet weak var memberOutView: UIView!
  @IBOutlet weak var houseNameLabel: UILabel!
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
    
    self.idView.setCornerRadius(radius: 12)
    self.colorView.setCornerRadius(radius: 20)
  }
  
  override func initRequest() {
    super.initRequest()
    
    // 하우스 코드 입력하기
    self.inputHouseCodeView.addTapGesture { recognizer in
      
    }
    
    // 눔메이트 초대하기
    self.inviteView.addTapGesture { recognizer in
      
    }
    
    // 내 정보 수정
    self.modifyInfoView.addTapGesture { recognizer in
      
    }
    
    // 알림설정
    self.alarmView.addTapGesture { recognizer in
      
    }
    
    // 눔메이트 공지사항
    self.noticeView.addTapGesture { recognizer in
      let destination = NoticeViewController.instantiate(storyboard: "Commons")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // 1:1 문의
    self.qnaView.addTapGesture { recognizer in
      let destination = QnaViewController.instantiate(storyboard: "Commons")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // 이용약관
    self.termsView.addTapGesture { recognizer in
      
    }
    
    // 하우스 나가기
    self.outHouseView.addTapGesture { recognizer in
      
    }
    
    // 로그아웃
    self.logoutView.addTapGesture { recognizer in
      AJAlertController.initialization().showAlert(astrTitle: "로그아웃 하시겠어요?", aStrMessage: "", aCancelBtnTitle: "닫기", aOtherBtnTitle: "로그아웃") { position, title in
        if position == 1 {
          self.logoutAPI()
        }
      }
    }
    
    // 회원탈퇴
    self.memberOutView.addTapGesture { recognizer in
      
    }
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    self.memberInfoDetailAPI()
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 사용자 프로필 정보 확인
  func memberInfoDetailAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .member_info_detail, method: .post, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.houseNameLabel.isHidden = memberResponse.house_code.isNil
        self.inputHouseCodeView.isHidden = !memberResponse.house_code.isNil
        self.inviteView.isHidden = memberResponse.house_code.isNil
        self.outHouseView.isHidden = memberResponse.house_code.isNil
        self.houseNameLabel.text = memberResponse.house_name
        self.nameLabel.text = memberResponse.member_name ?? ""
        self.idLabel.text = memberResponse.member_id ?? ""
        self.idView.isHidden = memberResponse.member_join_type != "C"
        self.loginTypeImageView.isHidden = Defaults[.member_join_type] == "C"
        self.loginTypeImageView.image = UIImage(named: Defaults[.member_join_type] == "K" ? "state_kko" : Defaults[.member_join_type] == "N" ? "state_naver" : "state_apple")
        let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
        
        self.avatarShapeImageView.image = UIImage(named: "\(shapeList[(memberResponse.member_role1 ?? "").toInt() ?? 0])71")
        
        self.faceImageView.image = UIImage(named: "face\(memberResponse.member_role2 ?? "")")
        
        self.colorView.backgroundColor = UIColor(named: "profile\(memberResponse.member_role3 ?? "")")
      }
    }
  }
  
  func logoutAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    APIRouter.shared.api(path: .logout, parameters: memberRequest.toJSON()) { data in
      if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.resetDefaults()
        let destination = LoginViewController.instantiate(storyboard: "Login")
        destination.hero.isEnabled = true
        destination.hero.modalAnimationType = .zoom
        destination.modalPresentationStyle = .fullScreen
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.rootViewController = destination
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
