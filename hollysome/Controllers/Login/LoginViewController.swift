//
//  LoginViewController.swift
//  hollysome
//

import UIKit
import Defaults
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKUser
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseAuth
import NVActivityIndicatorView
import AuthenticationServices
import CryptoKit

class LoginViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var naverButton: UIButton!
  @IBOutlet weak var kakaoButton: UIButton!
  @IBOutlet weak var appleButton: UIButton!
  @IBOutlet weak var emailJoinButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var pwTextField: UITextField!
  @IBOutlet weak var findPwButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

  var activityData = ActivityData(size: CGSize(width: 50, height: 50), message: "", messageFont: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor(named: "333333"), padding: nil, displayTimeThreshold: 1, minimumDisplayTime: 300, backgroundColor: UIColor.clear, textColor: UIColor.black)
  fileprivate var currentNonce: String?
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
    
    
    self.naverButton.setCornerRadius(radius: 25)
    self.kakaoButton.setCornerRadius(radius: 25)
    self.appleButton.setCornerRadius(radius: 25)
    
    self.idTextField.setCornerRadius(radius: 4)
    self.pwTextField.setCornerRadius(radius: 4)
    self.idTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.pwTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    
    self.loginButton.setCornerRadius(radius: 12)
    self.loginButton.addBorder(width: 1, color: UIColor(named: "accent")!)
    
    self.idTextField.setTextPadding(10)
    self.pwTextField.setTextPadding(10)
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 회원 로그인 API
  private func memberLoginAPI() {
    let memberReqeust = MemberModel()
    memberReqeust.member_id = self.idTextField.text
    memberReqeust.member_pw = self.pwTextField.text
    memberReqeust.device_os = "I"
    memberReqeust.gcm_key = self.appDelegate.fcmKey

    APIRouter.shared.api(path: .login, parameters: memberReqeust.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response) {
        if memberResponse.code == "1000" {
          Defaults[.member_idx] = memberResponse.member_idx
          Defaults[.member_id] = self.idTextField.text
          Defaults[.member_pw] = self.pwTextField.text
          Defaults[.member_join_type] = "C"
          Defaults[.house_code] = memberResponse.house_code
          Defaults[.house_idx] = memberResponse.house_idx
          let destination = MainTabBarViewController.instantiate(storyboard: "Main")
          let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
          window?.rootViewController = destination
        } else {
          AJAlertController.initialization().showAlertWithOkButton(astrTitle: memberResponse.code_msg ?? "", aStrMessage: "", alertViewHiddenCheck: false, img: "error_circle") { position, title in
          }
        }
        
      }
    } 
  }
  
  /// 소셜 로그인
  func snsLoginAPI(member_id: String, member_join_type: String) {
    let memberRequest = MemberModel()
    memberRequest.member_id = member_id
    memberRequest.member_join_type = member_join_type
    memberRequest.device_os = "I"
    memberRequest.gcm_key = self.appDelegate.fcmKey
    
    APIRouter.shared.api(path: .sns_member_login, method: .post, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response) {
        if memberResponse.code == "1000" || memberResponse.code == "2000" {
          Defaults[.member_idx] = memberResponse.member_idx
          Defaults[.member_id] = member_id
          Defaults[.member_join_type] = member_join_type
          Defaults[.house_code] = memberResponse.house_code
          Defaults[.house_idx] = memberResponse.house_idx
          let destination = MainTabBarViewController.instantiate(storyboard: "Main")
          let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
          window?.rootViewController = destination
        } else {
          let viewController = JoinViewController.instantiate(storyboard: "Login")
          viewController.memberRequest.member_id = member_id
          viewController.memberRequest.member_join_type = member_join_type
          viewController.memberRequest.gcm_key = self.appDelegate.fcmKey
          viewController.memberRequest.device_os = "I"
          viewController.loginType = .sns
          let destination = viewController.coverNavigationController()
          destination.modalPresentationStyle = .fullScreen
          destination.hero.isEnabled = true
          destination.heroModalAnimationType = .autoReverse(presenting: .cover(direction: .left))
          self.present(destination, animated: true)
        }
      }
    }
  }

  
  /// 네이버
  func naverDataFetch(){
    guard let naverConnection = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
    guard let accessToken = naverConnection.accessToken else { return }
    let authorization = "Bearer \(accessToken)"
    
    if let url = URL(string: "https://openapi.naver.com/v1/nid/me") {
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      request.setValue(authorization, forHTTPHeaderField: "Authorization")
      
      URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data else { return }
        
        do {
          guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
          guard let response = json["response"] as? [String: AnyObject] else { return }
          let id = response["id"] as? String ?? ""
          let name = response["name"] as? String ?? ""
          let email = response["email"] as? String ?? ""
          let profileImage = response["profile_image"] as? String ?? ""
          print("id: \(id)")
          print("email: \(email)")
          print("name: \(name)")
          print("profileImage: \(profileImage)")
          print("accessToken: \(accessToken)")
          //          self.site = "naver"
          //          self.loginAPI(snsMode: "sns_naver", accessToken: accessToken, userId: "", name: name, email: email, phone: "", image: profileImage)
        } catch let error as NSError {
          print(error)
        }
      }.resume()
    }
  }
  
  // 카카오 로그인
  func kakaoLogin() {
    
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
        if let error = error {
          print(error)
          NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        else {
          print("loginWithKakaoTalk() success.")
          UserApi.shared.me { user, error in
            log.debug(user?.id ?? "")
            self.snsLoginAPI(member_id: "\(user?.id ?? 0)", member_join_type: "K")
          }
        }
      }
    } else {
      // 카카오톡 미설치 -> 카카오계정으로 로그인
      UserApi.shared.loginWithKakaoAccount(prompts:[.Login]) {(oauthToken, error) in
        if let error = error {
          print(error)
          NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        else {
          print("loginWithKakaoAccount() success.")
          
          //do something
          _ = oauthToken
          
          UserApi.shared.me { user, error in
            log.debug(user?.id ?? "")
            self.snsLoginAPI(member_id: "\(user?.id ?? 0)", member_join_type: "K")
          }
          
        }
      }
    }
  }
  
  // 구글 로그인
  func googleLogin() {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
      if let error = error {
        log.error(error.localizedDescription)
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        return
      }
      
      guard let user = signInResult?.user else { return }
      
      let credential = GoogleAuthProvider.credential(withIDToken: user.idToken?.tokenString ?? "",
                                                     accessToken: user.accessToken.tokenString)
      
      Auth.auth().signIn(with: credential) { result, error in
        if let error = error {
          log.error(error.localizedDescription)
          NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
          return
        }
        
//        self.snsLoginAPI(member_id: user.userID ?? "", member_join_type: "G")
      }
      
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 로그인
  /// - Parameter sender: 버튼
  @IBAction func emailLoginButtonTouched(sender: UIButton) {
    self.memberLoginAPI()
  }
  
  /// 비밀번호 찾기
  /// - Parameter sender: 버튼
  @IBAction func findPwButtonTouched(sender: UIButton) {
    
  }
  
  /// 회원가입
  /// - Parameter sender: 버튼
  @IBAction func joinButtonTouched(sender: UIButton) {
//    let destination = JoinViewController.instantiate(storyboard: "Login")
//    self.navigationController?.pushViewController(destination, animated: true)
    
    let destination = EmailJoinViewController.instantiate(storyboard: "Login").coverNavigationController()
    destination.modalPresentationStyle = .fullScreen
    destination.hero.isEnabled = true
    destination.heroModalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    self.present(destination, animated: true)
    
//    let destination = CreateAvatarViewController.instantiate(storyboard: "Commons").coverNavigationController()
//    destination.modalPresentationStyle = .fullScreen
//    destination.hero.isEnabled = true
//    destination.heroModalAnimationType = .autoReverse(presenting: .cover(direction: .left))
//    self.present(destination, animated: true)
  }
  
  /// 카카오톡 로그인
  ///
  /// - Parameter sender: 버튼
  @IBAction func kakaoLoginButtonTouched(sender: UIButton) {
    self.kakaoLogin()
    
  }
  /// 네이버 로그인
  ///
  /// - Parameter sender: 버튼
  @IBAction func naverLoginButtonTouched(sender: UIButton) {
    let destination = MainTabBarViewController.instantiate(storyboard: "Main")
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    window?.rootViewController = destination
//    let naverConnection = NaverThirdPartyLoginConnection.getSharedInstance()
//    naverConnection?.delegate = self
//    naverConnection?.requestThirdPartyLogin()
    //      self.site = "naver"
  }
  
  /// 애플 로그인
  ///
  /// - Parameter sender: 버튼
  @IBAction func appleLoginButtonTouched(sender: UIButton) {
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
//    let destination = MainTabBarViewController.instantiate(storyboard: "Main")
//    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//    window?.rootViewController = destination
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - NaverThirdPartyLoginConnectionDelegate
//-------------------------------------------------------------------------------------------
extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    // 로그인 성공 (로그인된 상태에서 requestThirdPartyLogin()를 호출하면 이 메서드는 불리지 않는다.)
    self.naverDataFetch()
  }
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    // 로그인된 상태(로그아웃이나 연동해제 하지않은 상태)에서 로그인 재시도
    self.naverDataFetch()
  }
  
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    //  접근 토큰, 갱신 토큰, 연동 해제등이 실패
    
  }
  
  func oauth20ConnectionDidFinishDeleteToken() {
    // 연동해제 콜백
    
  }
  
  func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
    //    self.present(NLoginThirdPartyOAuth20InAppBrowserViewController(request: request), animated: true, completion: nil)
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - ASAuthorizationControllerDelegate
//-------------------------------------------------------------------------------------------
extension LoginViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
      switch authorization.credential {
      case let appleIDCredential as ASAuthorizationAppleIDCredential:
        
        // Create an account in your system.
        let userIdentifier = appleIDCredential.user
        let fullName = "\(appleIDCredential.fullName?.familyName ?? "")\(appleIDCredential.fullName?.middleName ?? "")\(appleIDCredential.fullName?.givenName ?? "")"
        let email = appleIDCredential.email ?? ""
        
        //      // For the purpose of this demo app, store the `userIdentifier` in the keychain.
        //      self.saveUserInKeychain(userIdentifier)
        //
        //      // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
        //      self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
        log.debug("userIdentifier : \(userIdentifier)")
        log.debug("fullName : \(fullName)")
        log.debug("email : \(email)")
        
        self.snsLoginAPI(member_id: userIdentifier, member_join_type: "A")
      case let passwordCredential as ASPasswordCredential:
        
        // Sign in using an existing iCloud Keychain credential.
        let username = passwordCredential.user
        let password = passwordCredential.password
        
        // For the purpose of this demo app, show the password credential as an alert.
        DispatchQueue.main.async {
          //        self.showPasswordCredentialAlert(username: username, password: password)
          log.debug("username : \(username)")
          log.debug("password : \(password)")
        }
        
      default:
        break
      }
      
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    log.debug(error.localizedDescription)
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - ASAuthorizationControllerPresentationContextProviding
//-------------------------------------------------------------------------------------------
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
  
}
