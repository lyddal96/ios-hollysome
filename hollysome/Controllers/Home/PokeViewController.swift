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
  var member = MemberModel()
  var schedule = ""
  
  private var rewardedAd: GADRewardedAd?
  
  var activityData = ActivityData(size: CGSize(width: 50, height: 50), message: "", messageFont: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor(named: "333333"), padding: nil, displayTimeThreshold: 1, minimumDisplayTime: 300, backgroundColor: UIColor.clear, textColor: UIColor.black)
  
  var pokeCnt = 0
  var authState: OIDAuthState?
  
//  let oauthswift = OAuth2Swift(
//    consumerKey: "Your_Client_ID",
//    consumerSecret: "Your_Client_Secret",
//    authorizeUrl: "https://accounts.google.com/o/oauth2/auth",
//    responseType: "code",
//    redirectUri: "Your_Redirect_URI"
//  )
  

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
    
    self.loadState()

  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  func setMember() {
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
    
    self.shapeImageView.image = UIImage(named: "\(shapeList[0])71")
    self.faceImageView.image = UIImage(named: "face\(0)")
    self.colorView.backgroundColor = UIColor(named: "profile\(0)")
    
    let name = "아이유(이)가\n".stylize().font(UIFont.systemFont(ofSize: 14, weight: .bold)).color(UIColor(named: "3A3A3C")!).attr
    let content = "아직 분리수거을(를) 완료하지 않았어요.\n메이트를 콕 찔러 알려주세요.".stylize().font(UIFont.systemFont(ofSize: 14, weight: .regular)).color(UIColor(named: "3A3A3C")!).attr
    self.contentLabel.attributedText = name + content
  }

  
  func loadState() {
    let kAppAuthExampleAuthStateKey: String = "authState";
      guard let data = UserDefaults(suiteName: "group.net.openid.appauth.Example")?.object(forKey: kAppAuthExampleAuthStateKey) as? Data else {
          return
      }

      if let authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState {
          self.setAuthState(authState)
      }
  }
  
  func setAuthState(_ authState: OIDAuthState?) {
        if (self.authState == authState) {
            return;
        }
        self.authState = authState;
        self.authState?.stateChangeDelegate = self;
        self.sendNotification()
    }

  /// 광고 띄우기
//  func showAd() {
//    guard let rewardedInterstitialAd = rewardedInterstitialAd else {
//      return print("Ad wasn't ready.")
//    }
//    
//    rewardedInterstitialAd.present(fromRootViewController: self) {
//      let reward = rewardedInterstitialAd.adReward
//      // TODO: Reward the user!
//      log.debug("reward")
//    }
//  }
  
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
        
//        self.callbackAd()
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
    var registrationIds = [String]()
//    GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
//        guard error == nil else { return }
//        guard let signInResult = signInResult else { return }
//
//        let authCode = signInResult.serverAuthCode
//      log.debug("authCode::::::::::::\(authCode)")
//    }
    
    APIRouter.shared.getToken(parameters: nil) { data in
      log.debug("Token::::::::::\(data.toJsonString() ?? "")")
    } fail: { error in
      log.debug("error::::::::::::\(error)")
    }

    
//    guard let tokenExchangeRequest = authState?.lastAuthorizationResponse.tokenExchangeRequest() else {
//      log.debug("Error creating authorization code exchange request")
//      return
//    }
//    OIDAuthorizationService.perform(tokenExchangeRequest) { response, error in
//      log.debug("accessToken ========\(response?.accessToken ?? "")")
//      log.debug("refreshToken ========\(response?.refreshToken ?? "")")
//    }
    
//      guard let fcmKeyList = self.chatInfo.fcm_key_list, fcmKeyList.count > 0 else { return }
    
    
//      for value in fcmKeyList {
//        registrationIds.append(value.fcm_key ?? "")
//      }
    registrationIds = [appDelegate.fcmKey ?? ""]
    
//    alarmRequest.registration_ids = registrationIds
    alarmRequest.message = PlanModel()
    alarmRequest.message?.token = appDelegate.fcmKey ?? ""
    let notificationModel = PlanModel()
//    notificationModel.title = ""
    notificationModel.body = "찌르기~~~~~~~~~"
//    notificationModel.msg = "찌르기~~~~~"
//    
//    notificationModel.sound = "default"
//    notificationModel.mutable_content = true
//    notificationModel.priority = "high"
//    notificationModel.click_action = "FCMActivity"
    
    alarmRequest.message?.notification = notificationModel
    
    let data = PlanModel()
    data.member_nickname = "우와아아앙아아ㅣㅏㅇ러니ㅏㅇ러이나ㅓㄹ"
    alarmRequest.message?.data = data
//    UserDefaults.standard.string(forKey:"kakao.open.sdk.RefreshToken")
    APIRouter.shared.fcmapi(method: .post, parameters: alarmRequest.toJSON()) { data in
      if let _ = PlanModel(JSON: data) {
        
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  private func authenticationService() {
      // create an instance and retain it
      let oauthswift = OAuth2Swift(
          consumerKey:    "xx",
          consumerSecret: "xxx",
          authorizeUrl:   "https://accounts.google.com/o/oauth2/v2/auth + userId",
          responseType:   "token"
      )
      oauthswift.authorizeURLHandler = OAuthSwiftOpenURLExternally.sharedInstance
      let handle = oauthswift.authorize(
          withCallbackURL: "???",
          scope: "", state:"") { result in
          switch result {
          case .success(let (credential, response, parameters)):
            print(credential.oauthToken)
            // Do your request
          case .failure(let error):
            print(error.localizedDescription)
          }
      }
  }
  func getAccessToken() {
    let authManager = GCPAuthManager()
    authManager.getAccessToken { result in
        switch result {
        case .success(let accessToken):
          log.debug("Access Token: \(accessToken)")
            // 여기에서 액세스 토큰을 사용하여 GCP 리소스에 액세스할 수 있습니다.
        case .failure(let error):
          log.debug("OAuth Error: \(error.localizedDescription)")
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
    self.sendNotification()
//    self.getAccessToken()
    
//    APIRouter.shared.getToken(parameters: nil) { data in
//      log.debug(data)
//    } fail: { error in
//      log.debug(error)
//    }

    
    
//    log.debug("GTMOAuth2KeychainCompatibility.googleTokenURL() \(AppAuth.OIDRegistrationAccessTokenParam)")
//    APIRouter.shared.getToken(parameters: nil) { data in
//      log.debug("success :::::::::\(data.toJsonString())")
//    } fail: { error in
//      log.debug("error :::::::::\(error)")
//    }

    

//    if let poke_cnt = Defaults[.poke_cnt], poke_cnt != 0 {
//      Defaults[.poke_cnt] = poke_cnt - 1
//    } else {
//      self.loadRewardedAd()
//    }
//    if Defaults[.poke_cnt] ?? 0 == 0 {
//      self.pokeButton.setTitle("광고보고 콕콕!", for: .normal)
//    } else {
//      self.pokeButton.setTitle("콕찌르기 \(Defaults[.poke_cnt]!)", for: .normal)
//    }
    
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
extension PokeViewController: OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate {

    func didChange(_ state: OIDAuthState) {
        self.sendNotification()
    }

    func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
      log.debug("Received authorization error: \(error)")
    }
}
