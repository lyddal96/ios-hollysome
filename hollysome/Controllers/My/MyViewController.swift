//
//  MyViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/05/26.
//
//

import UIKit
import Defaults
import SwiftUI
import GoogleMobileAds

class MyViewController: BaseViewController {
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
  @IBOutlet weak var faqView: UIView!
  @IBOutlet weak var qnaView: UIView!
  @IBOutlet weak var termsView: UIView!
  @IBOutlet weak var outHouseView: UIView!
  @IBOutlet weak var logoutView: UIView!
  @IBOutlet weak var memberOutView: UIView!
  @IBOutlet weak var houseNameLabel: UILabel!
  @IBOutlet weak var donateView: UIView!
  @IBOutlet weak var adView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var memberResponse = MemberModel()
  
  var bannerView: GADBannerView!
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // In this case, we instantiate the banner with desired ad size.
    self.bannerView = GADBannerView(adSize: GADAdSizeBanner)
    bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    bannerView.rootViewController = self
    bannerView.load(GADRequest())
    bannerView.frame.size.width = self.view.frame.size.width
    bannerView.frame.size.height = 50 / 320 * self.view.frame.size.width
    self.addBannerViewToView(self.bannerView)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.idView.setCornerRadius(radius: 12)
    self.colorView.setCornerRadius(radius: 20)
    self.colorView.setCornerRadius(radius: 26)
    
    self.donateView.isHidden = true
  }
  
  override func initRequest() {
    super.initRequest()
    
    // 하우스 코드 입력하기
    self.inputHouseCodeView.addTapGesture { recognizer in
      // 하우스 코드 입력하기
      let destination = InputHouseCodeViewController.instantiate(storyboard: "Home")
      destination.modalTransitionStyle = .crossDissolve
      destination.modalPresentationStyle = .overCurrentContext
      destination.hidesBottomBarWhenPushed = true
//      self.present(destination, animated: false, completion: nil)
      self.tabBarController?.present(destination, animated: true)
    }
    
    // 눔메이트 초대하기
    self.inviteView.addTapGesture { recognizer in
      Tools.shared.openShare(shareString: "http://noom.api.hollysome.com/share/house_share?member_idx=\(Defaults[.member_idx] ?? "")&house_code=\(Defaults[.house_code] ?? "")", viewController: self)
    }
    
    // 내 정보 수정
    self.modifyInfoView.addTapGesture { recognizer in
      let destination = ModifyInfoViewController.instantiate(storyboard: "My")
      destination.memberData = self.memberResponse
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // 알림설정
    self.alarmView.addTapGesture { recognizer in
      let destination = AlarmSettingViewController.instantiate(storyboard: "My")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // 눔메이트 공지사항
    self.noticeView.addTapGesture { recognizer in
      let destination = NoticeViewController.instantiate(storyboard: "Commons")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    //faq
    self.faqView.addTapGesture { recognizer in
      let destination = FaqViewController.instantiate(storyboard: "Commons")
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
      AJAlertController.initialization().showAlert(astrTitle: "하우스의 일정, 가계부 등은 삭제되어 더 이상 볼 수 없게 됩니다. \(self.memberResponse.house_name ?? "") 을(를) 나가시겠어요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "하우스 나가기", img: "error_circle") { position, title in
        if position == 1 {
          self.outHouseAPI()
        }
      }
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
      let destination = MemberOutViewController.instantiate(storyboard: "My")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // 눔메이트 개발자 후원하기
    self.donateView.addTapGesture { recognizer in
      let destination = DonateViewController.instantiate(storyboard: "My")
//      destination.delegate = self
      destination.modalTransitionStyle = .crossDissolve
      destination.modalPresentationStyle = .overCurrentContext
      self.tabBarController?.present(destination, animated: true)
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
  func addBannerViewToView(_ bannerView: GADBannerView) {
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bannerView)
    view.addConstraints(
      [NSLayoutConstraint(item: bannerView,
                          attribute: .bottom,
                          relatedBy: .equal,
                          toItem: view.safeAreaLayoutGuide,
                          attribute: .bottom,
                          multiplier: 1,
                          constant: 0),
       NSLayoutConstraint(item: bannerView,
                          attribute: .centerX,
                          relatedBy: .equal,
                          toItem: view,
                          attribute: .centerX,
                          multiplier: 1,
                          constant: 0)
      ])
  }
  
  /// 사용자 프로필 정보 확인
  func memberInfoDetailAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .member_info_detail, method: .post, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.memberResponse = memberResponse
        self.houseNameLabel.isHidden = memberResponse.house_code.isNil
        self.inputHouseCodeView.isHidden = !memberResponse.house_code.isNil
        self.inviteView.isHidden = memberResponse.house_code.isNil
        self.outHouseView.isHidden = memberResponse.house_code.isNil
        self.houseNameLabel.text = memberResponse.house_name
        self.nameLabel.text = memberResponse.member_name ?? ""
        self.idLabel.text = memberResponse.member_id ?? ""
        self.idView.isHidden = memberResponse.member_join_type != "C"
        self.loginTypeImageView.isHidden = Defaults[.member_join_type] == "C"
        self.loginTypeImageView.image = UIImage(named: memberResponse.member_join_type == "K" ? "state_kko" : Defaults[.member_join_type] == "N" ? "state_naver" : "state_apple")
        let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
        
        self.avatarShapeImageView.image = UIImage(named: "\(shapeList[(memberResponse.member_role1 ?? "").toInt() ?? 0])71")
        
        self.faceImageView.image = UIImage(named: "face\(memberResponse.member_role2 ?? "")")
        
        self.colorView.backgroundColor = UIColor(named: "profile\(memberResponse.member_role3 ?? "")")
      }
    }
  }
  
  /// 하우스 나가기 APi
  func outHouseAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.house_idx = Defaults[.house_idx]
    
    APIRouter.shared.api(path: .house_out_up, method: .post, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        Defaults[.house_code] = nil
        self.memberInfoDetailAPI()
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "\(self.memberResponse.house_name ?? "")하우스를 나왔습니다.", aStrMessage: "", alertViewHiddenCheck: false, img: "check_circle") { position, title in
        }
      }
    }
  }
  
  /// 로그아웃 API
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

//-------------------------------------------------------------------------------------------
// MARK: - GADBannerViewDelegate
//-------------------------------------------------------------------------------------------
extension MyViewController: GADBannerViewDelegate {
  func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
    self.addBannerViewToView(bannerView)
    print("bannerViewDidReceiveAd")
  }

  func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
    print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
  }

  func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
    print("bannerViewDidRecordImpression")
  }

  func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
    print("bannerViewWillPresentScreen")
  }

  func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
    print("bannerViewWillDIsmissScreen")
  }

  func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
    print("bannerViewDidDismissScreen")
  }
}

extension MyViewController: GADAdSizeDelegate {
  func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
    
  }
  
  
}
