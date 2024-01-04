//
//  PokeViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
import StringStylizer
import Defaults
import GoogleMobileAds
import NVActivityIndicatorView
import FirebaseMessaging
import FirebaseAuth
import GoogleSignIn
import AppAuth
import OAuthSwift


class PokeViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var avatarView: UIView!
  @IBOutlet weak var shapeImageView: UIImageView!
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var pokeButton: UIButton!
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var popupView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var member = PlanModel()
  var schedule_name = ""
  var schedule = ""
  
  private var rewardedAd: GADRewardedAd?
  
  var activityData = ActivityData(size: CGSize(width: 50, height: 50), message: "", messageFont: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor(named: "333333"), padding: nil, displayTimeThreshold: 1, minimumDisplayTime: 300, backgroundColor: UIColor.clear, textColor: UIColor.black)
  
  var pokeCnt = 0
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.callbackAd()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.closeButton.setCornerRadius(radius: 12)
    self.pokeButton.setCornerRadius(radius: 12)
    self.popupView.setCornerRadius(radius: 12)
    
    self.setMember()
    if Defaults[.poke_cnt] ?? 0 == 0 {
      self.pokeButton.setTitle("광고보고 콕콕!", for: .normal)
    } else {
      self.pokeButton.setTitle("콕찌르기 \(Defaults[.poke_cnt]!)", for: .normal)
    }
    
  }
  
  override func initRequest() {
    super.initRequest()

    let interval = Date().timeIntervalSince(Defaults[.token_time] ?? Date())
    let time = Int(interval / 3600)
    
    if (time > 0 || Defaults[.token_time] == nil) {
      self.getAccessToken()
    }
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  func setMember() {
//    self.nameLabel.text = mate.member_nickname ?? ""
    self.shapeImageView.image = UIImage(named: "\(Constants.SHAPE_LIST[self.member.member_role1?.toInt() ?? 0])71")
    self.faceImageView.image = UIImage(named: "face\(self.member.member_role2?.toInt() ?? 0)")
    self.colorView.backgroundColor = UIColor(named: "profile\(self.member.member_role3?.toInt() ?? 0)")
    
    let name = "\(self.member.member_nickname ?? "")(이)가\n".stylize().font(UIFont.systemFont(ofSize: 14, weight: .bold)).color(UIColor(named: "3A3A3C")!).attr
    let content = "아직 \(self.schedule_name)을(를) 완료하지 않았어요.\n메이트를 콕 찔러 알려주세요.".stylize().font(UIFont.systemFont(ofSize: 14, weight: .regular)).color(UIColor(named: "3A3A3C")!).attr
    self.contentLabel.attributedText = name + content
  }

  
  func callbackAd() {
    let request = GADRequest()
    GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
                       request: request,
                       completionHandler: { [self] ad, error in
      if let error = error {
        print("Failed to load rewarded ad with error: \(error.localizedDescription)")
        return
      }
      rewardedAd = ad
      print("Rewarded ad loaded.")
      rewardedAd?.fullScreenContentDelegate = self
      
    }
    )
  }

  func loadRewardedAd() {
    
    if let ad = rewardedAd {
      ad.present(fromRootViewController: self) {
        let reward = ad.adReward
        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
        // TODO: Reward the user.
        
        Defaults[.poke_cnt] = 3
        self.pokeButton.setTitle("콕찌르기 \(Defaults[.poke_cnt]!)", for: .normal)
        
        self.callbackAd()
        GADMobileAds().initializationStatus
      }
    } else {
      print("Ad wasn't ready")
    }
    
    
    
//    self.rewardedAd?.present(fromRootViewController: self, userDidEarnRewardHandler: {
//      let reward = self.rewardedAd?.adReward
//      
//      log.debug("reward : \(reward)")
//    })
   }
  
  func sendNotification() {
    let alarmRequest = PlanModel()
    
    
//    alarmRequest.registration_ids = registrationIds
    alarmRequest.message = PlanModel()
    alarmRequest.message?.token = appDelegate.fcmKey ?? ""
    let notificationModel = PlanModel()
//    notificationModel.title = ""
    notificationModel.body = "\(Defaults[.member_name] ?? "") 메이트가 나를 콕 찔렀어요."
//    notificationModel.msg = "찌르기~~~~~"
//    
//    notificationModel.sound = "default"
//    notificationModel.mutable_content = true
//    notificationModel.priority = "high"
//    notificationModel.click_action = "FCMActivity"
    
    alarmRequest.message?.notification = notificationModel
    
    let data = PlanModel()
    data.member_nickname = "\(Defaults[.member_name] ?? "")"
    alarmRequest.message?.data = data
    
    APIRouter.shared.fcmapi(method: .post, parameters: alarmRequest.toJSON()) { data in
      if let poke_cnt = Defaults[.poke_cnt], poke_cnt != 0 {
        Defaults[.poke_cnt] = poke_cnt - 1
      }
      if let _ = PlanModel(JSON: data) {
        
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  func getAccessToken() {
    APIRouter.shared.api(path: .getAccessToken, parameters: nil) { response in
      if let tokenResponse = BaseModel(JSON: response), Tools.shared.isSuccessResponse(response: tokenResponse) {
        Defaults[.access_token] = tokenResponse.access_token
        Defaults[.token_time] = Date()
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 닫기
  /// - Parameter sender: 버튼
  @IBAction func closeButtonTouched(sender: UIButton) {
    self.dismiss(animated: false)
  }
  
  /// 콕찌르기
  /// - Parameter sender: 버튼
  @IBAction func pokeButtonTouched(sender: UIButton) {
    
    
    if let poke_cnt = Defaults[.poke_cnt], poke_cnt != 0 {
      self.sendNotification()
    } else {
      self.loadRewardedAd()
    }
    if Defaults[.poke_cnt] ?? 0 == 0 {
      self.pokeButton.setTitle("광고보고 콕콕!", for: .normal)
    } else {
      self.pokeButton.setTitle("콕찌르기 \(Defaults[.poke_cnt]!)", for: .normal)
    }
    
  }
}

extension PokeViewController: GADFullScreenContentDelegate {

  /// Tells the delegate that the ad failed to present full screen content.
  func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    print("Ad did fail to present full screen content.")
  }

  /// Tells the delegate that the ad will present full screen content.
  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad will present full screen content.")
  }

  /// Tells the delegate that the ad dismissed full screen content.
  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad did dismiss full screen content.")

  }
  
  
}
