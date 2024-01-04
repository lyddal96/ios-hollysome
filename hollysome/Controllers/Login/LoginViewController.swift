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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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
          Defaults[.access_token] = memberResponse.access_token
          Defaults[.token_time] = Date()
          Defaults[.member_name] = memberResponse.member_name
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
          Defaults[.access_token] = memberResponse.access_token
          Defaults[.token_time] = Date()
          Defaults[.member_name] = memberResponse.member_name
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
  // 애플로그인
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)
      
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    // 로그인 요청과 함께 nonce의 SHA256 해시를 전송하면 Apple은 이에 대한 응답으로 원래의 값을 전달합니다. Firebase는 원래의 nonce를 해싱하고 Apple에서 전달한 값과 비교하여 응답을 검증합니다.
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()
      
      return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    // 로그인 요청마다 임의의 문자열인 'nonce'가 생성되며, 이 nonce는 앱의 인증 요청에 대한 응답으로 ID 토큰이 명시적으로 부여되었는지 확인하는 데 사용됩니다. 재전송 공격을 방지하려면 이 단계가 필요합니다.
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length
      
      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }
        
        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }
          
          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }
      
      return result
    }
    
    
    @objc func taskFunc() {
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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
//    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//    let request = ASAuthorizationAppleIDProvider().createRequest()
//    request.requestedScopes = [.fullName, .email]
//    let controller = ASAuthorizationController(authorizationRequests: [request])
//    controller.delegate = self
//    controller.presentationContextProvider = self
//    controller.performRequests()
    
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
        self.startSignInWithAppleFlow()
    
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
//  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
//      switch authorization.credential {
//      case let appleIDCredential as ASAuthorizationAppleIDCredential:
//        
//        // Create an account in your system.
//        let userIdentifier = appleIDCredential.user
//        let fullName = "\(appleIDCredential.fullName?.familyName ?? "")\(appleIDCredential.fullName?.middleName ?? "")\(appleIDCredential.fullName?.givenName ?? "")"
//        let email = appleIDCredential.email ?? ""
//        
//        //      // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//        //      self.saveUserInKeychain(userIdentifier)
//        //
//        //      // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
//        //      self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
//        log.debug("userIdentifier : \(userIdentifier)")
//        log.debug("fullName : \(fullName)")
//        log.debug("email : \(email)")
//        
//        self.snsLoginAPI(member_id: userIdentifier, member_join_type: "A")
//      case let passwordCredential as ASPasswordCredential:
//        
//        // Sign in using an existing iCloud Keychain credential.
//        let username = passwordCredential.user
//        let password = passwordCredential.password
//        
//        // For the purpose of this demo app, show the password credential as an alert.
//        DispatchQueue.main.async {
//          //        self.showPasswordCredentialAlert(username: username, password: password)
//          log.debug("username : \(username)")
//          log.debug("password : \(password)")
//        }
//        
//      default:
//        break
//      }
//      
//    }
//  }
//  
//  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//    log.debug(error.localizedDescription)
//  }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }
        
        // Initialize a Firebase credential, including the user's full name.
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                          rawNonce: nonce,
                                                          fullName: appleIDCredential.fullName)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if (error != nil) {
            // Error. If error.code == .MissingOrInvalidNonce, make sure
            // you're sending the SHA256-hashed nonce as a hex string with
            // your request to Apple.
            print(error!.localizedDescription)
            return
          }
          // User is signed in to Firebase with Apple.
          // ...
          self.snsLoginAPI(member_id: appleIDCredential.user, member_join_type: "A")
          
        }
      }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
      print("Sign in with Apple errored: \(error)")
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
