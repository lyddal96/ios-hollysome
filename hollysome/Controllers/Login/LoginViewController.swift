//
//  LoginViewController.swift
//  hollysome
//
//  Created by rocateer on 19/09/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//
import UIKit
import Defaults
import FBSDKLoginKit
import FBSDKCoreKit
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKUser
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseAuth
import NVActivityIndicatorView

class LoginViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var pwTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var findIdButton: UIButton!
  @IBOutlet weak var findPwButton: UIButton!
  @IBOutlet weak var joinButton: UIButton!
//  @IBOutlet weak var kakaoWrapView: UIView!
//  @IBOutlet weak var kakaoLoginButton: UIButton!
//  @IBOutlet weak var naverWrapView: UIView!
//  @IBOutlet weak var naverLoginButton: UIButton!
//  @IBOutlet weak var facebookWrapView: UIView!
//  @IBOutlet weak var facebookLoginButton: UIButton!
//  @IBOutlet weak var googleWrapView: UIView!
//  @IBOutlet weak var googleLoginButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let facebookManager = LoginManager()
  
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
    
    self.loginButton.setCornerRadius(radius: 3)
    self.findIdButton.setCornerRadius(radius: 3)
    self.findPwButton.setCornerRadius(radius: 3)
    self.joinButton.setCornerRadius(radius: 3)
    
//    self.joinButton.isHidden = true
    
//    self.kakaoWrapView.setCornerRadius(radius: 5)
//    self.kakaoWrapView.layer.masksToBounds = false
//    self.kakaoWrapView.addShadow(offset: CGSize(width: 0, height: 1), radius: 3, color: UIColor.black, opacity: 0.1)
//    self.naverWrapView.setCornerRadius(radius: 5)
//    self.naverWrapView.layer.masksToBounds = false
//    self.naverWrapView.addShadow(offset: CGSize(width: 0, height: 1), radius: 3, color: UIColor.black, opacity: 0.1)
//    self.facebookWrapView.setCornerRadius(radius: 5)
//    self.facebookWrapView.layer.masksToBounds = false
//    self.facebookWrapView.addShadow(offset: CGSize(width: 0, height: 1), radius: 3, color: UIColor.black, opacity: 0.1)
//    self.googleWrapView.setCornerRadius(radius: 5)
//    self.googleWrapView.layer.masksToBounds = false
//    self.googleWrapView.addShadow(offset: CGSize(width: 0, height: 1), radius: 3, color: UIColor.black, opacity: 0.1)
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
    let memberReqeust = MemberModel()
    memberReqeust.email = self.idTextField.text
    memberReqeust.password = self.pwTextField.text
    memberReqeust.fcm_key = "test"
    memberReqeust.device_type = "1"
    
    APIRouter.shared.api(path: APIURL.login, parameters: memberReqeust.toJSON()) { data in
      if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse) {
        if let result = memberResponse.result {
          Defaults[.access_token] = result.access_token
          Defaults[.email] = self.idTextField.text
          Defaults[.password] = self.pwTextField.text
          self.navigationController?.popViewController(animated: true)
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
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 로그인 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func loginButtonTouched(sender: UIButton) {
    self.loginAPI()
  }
  
  /// 아이디 찾기 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func findIdButtonTouched(sender: UIButton) {
    let destination = FindIdViewController.instantiate(storyboard: "Login").coverNavigationController()
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  /// 비밀번호 찾기 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func findPwButtonTouched(sender: UIButton) {
    let destination = FindPwViewController.instantiate(storyboard: "Login").coverNavigationController()
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  @IBAction func joinButtonTouched(sender: UIButton) {
    let destination = JoinViewController.instantiate(storyboard: "Login")
    self.navigationController?.pushViewController(destination, animated: true)
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
    let naverConnection = NaverThirdPartyLoginConnection.getSharedInstance()
    naverConnection?.delegate = self
    naverConnection?.requestThirdPartyLogin()
    //      self.site = "naver"
  }
  
  /// 페이스북 로그인
  ///
  /// - Parameter sender: 버튼
  @IBAction func facebookLoginButtonTouched(sender: UIButton) {
    facebookManager.logIn(permissions: ["public_profile", "email"], from: self) { (loginResult, error) in
      if let error = error {
        log.error(error.localizedDescription)
      } else if loginResult?.isCancelled ?? false {
        log.debug("사용자 로그인 취소")
      } else {
        if let accessToken = loginResult?.token {
          log.debug("FB access token = \(accessToken.tokenString)")
          
          GraphRequest.init(graphPath: "me", parameters: ["fields": "id,name,email"]).start { (connection, result, error) in
            if let error = error {
              log.error(error.localizedDescription)
            } else {
              if let dic = result as? [String: Any] {
                
                let id = dic["id"] as? String ?? ""
                let name = dic["name"] as? String ?? ""
                let email = dic["email"] as? String ?? ""
                let profile = dic["profile"] as? String ?? ""
                log.debug(id)
                log.debug(email)
                log.debug(profile)
                //                  self.site = "facebook"
                //                  self.loginAPI(snsMode: "sns_facebook", accessToken: accessToken.tokenString, userId: "", name: name, email: email, phone: "", image: profile)
                
              }
            }
          }
        }
      }
    }
  }
  /// 구글 로그인
  ///
  /// - Parameter sender: 버튼
  @IBAction func googleLoginButtonTouched(sender: UIButton) {
    self.googleLogin()
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
