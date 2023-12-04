//
//  LoginViewController.swift
//  hollysome
//
//  Created by rocateer on 19/09/2019.
//  Copyright © 2019 rocateer. All rights reserved.
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

class LoginViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var naverButton: UIButton!
  @IBOutlet weak var kakaoButton: UIButton!
  @IBOutlet weak var appleButton: UIButton!
  @IBOutlet weak var emailLoginButton: UIButton!
  @IBOutlet weak var emailJoinButton: UIButton!
  
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
    
    
    self.naverButton.setCornerRadius(radius: 12)
    self.kakaoButton.setCornerRadius(radius: 12)
    self.appleButton.setCornerRadius(radius: 12)
    
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 회원 로그인 API
//  private func memberLoginAPI() {
//    let memberReqeust = MemberModel()
//    memberReqeust.member_id = self.idTextField.text
//    memberReqeust.member_pw = self.pwTextField.text
//    memberReqeust.device_os = "I"
//    memberReqeust.gcm_key = "test"
//
//    APIRouter.shared.api(path: .member_login, parameters: memberReqeust.toJSON()) { response in
//      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
//        Defaults[.member_idx] = memberResponse.member_idx
//        Defaults[.member_id] = self.idTextField.text
//        Defaults[.member_pw] = self.pwTextField.text
//
//        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "Rocateer", aStrMessage: "로그인 성공", alertViewHiddenCheck: false) { (position, title) in
//        }
//      }
//    } 
//  }
  
  
  /// 로그인
  private func loginAPI() {
//    let memberReqeust = MemberModel()
//    memberReqeust.email = self.idTextField.text
//    memberReqeust.password = self.pwTextField.text
//    memberReqeust.fcm_key = "test"
//    memberReqeust.device_type = "1"
//
//    APIRouter.shared.api(path: APIURL.login, parameters: memberReqeust.toJSON()) { data in
//      if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse) {
//        if let result = memberResponse.result {
//          Defaults[.access_token] = result.access_token
//          Defaults[.email] = self.idTextField.text
//          Defaults[.password] = self.pwTextField.text
//          self.navigationController?.popViewController(animated: true)
//        }
//      }
//    }
//
//
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
//            self.snsLoginAPI(member_id: "\(user?.id ?? 0)", member_join_type: "K")
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
//            self.snsLoginAPI(member_id: "\(user?.id ?? 0)", member_join_type: "K")
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
  @IBAction func emailLoginButtonTouched(sender: UIButton) {
    let destination = EmailLoginViewController.instantiate(storyboard: "Login").coverNavigationController()
    destination.modalPresentationStyle = .fullScreen
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    self.present(destination, animated: true)
  }
   
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
//    self.kakaoLogin()
    let destination = MainTabBarViewController.instantiate(storyboard: "Main")
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    window?.rootViewController = destination
    
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
//    NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
//    self.startSignInWithAppleFlow()
    let destination = MainTabBarViewController.instantiate(storyboard: "Main")
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    window?.rootViewController = destination
  }
  
  
}


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
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
          print(error?.localizedDescription ?? "")
          return
        }
        // User is signed in to Firebase with Apple.
        // ...
        log.debug("LOGIN!!!!!!!!")
        log.debug("\(Auth.auth().currentUser?.displayName ?? "")")
        log.debug("\(Auth.auth().currentUser?.email ?? "")")
        log.debug("\(Auth.auth().currentUser?.uid ?? "")")
        log.debug("\(appleIDCredential.user)")
        
//        self.snsLoginAPI(member_id: Auth.auth().currentUser?.uid ?? "", member_join_type: "A")
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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
