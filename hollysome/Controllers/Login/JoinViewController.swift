//
//  JoinViewController.swift
//  hollysome
//

import UIKit
import Defaults

enum LoginType {
  case normal
  case sns
}
class JoinViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var makeImageView: UIImageView!
  @IBOutlet weak var charactorView: UIView!
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var shapeImageView: UIImageView!
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var nicknameTextField: UITextField!
  @IBOutlet weak var houseCodeTextField: UITextField!
  @IBOutlet weak var allTermsButton: UIButton!
  @IBOutlet weak var terms1Button: UIButton!
  @IBOutlet weak var terms2Button: UIButton!
  @IBOutlet weak var terms1DetailButton: UIButton!
  @IBOutlet weak var terms2DetailButton: UIButton!
  @IBOutlet weak var joinButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var termsButtons: [UIButton] = []
  var selectedAvatar: [Int?] = [nil,nil,nil]
  var memberRequest = MemberModel()
  var loginType = LoginType.normal
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.termsButtons.append(self.terms1Button)
    self.termsButtons.append(self.terms2Button)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.nicknameTextField.setCornerRadius(radius: 4)
    self.houseCodeTextField.setCornerRadius(radius: 4)
    self.nicknameTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.houseCodeTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.nicknameTextField.setTextPadding(16)
    self.houseCodeTextField.setTextPadding(16)
    
    self.joinButton.setCornerRadius(radius: 16)
  }
  
  override func initRequest() {
    super.initRequest()
    
    /// 캐릭터 만들기
    self.charactorView.addTapGesture { recognizer in
      let destination = CreateAvatarViewController.instantiate(storyboard: "Commons")
      if self.selectedAvatar != [nil,nil,nil] {
        destination.selectedAvatar = [self.selectedAvatar[0]!, self.selectedAvatar[1]!, self.selectedAvatar[2]!]
      }
      destination.delegate = self
      self.navigationController?.pushViewController(destination, animated: true)
    }
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  func setAvatarView() {
    self.makeImageView.isHidden = true
    self.shapeImageView.setCornerRadius(radius: 61.5)
    self.colorView.setCornerRadius(radius: 40)
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
    if let shape = self.selectedAvatar[0] {
      self.shapeImageView.image = UIImage(named: "\(shapeList[shape])119")
    }
    
    if let shape = self.selectedAvatar[0] {
      self.shapeImageView.image = UIImage(named: "\(shapeList[shape])119")
    }
    
    if let face = self.selectedAvatar[1] {
      self.faceImageView.image = UIImage(named: "face119_\(face)")
    }
    
    if let color = self.selectedAvatar[2] {
      self.colorView.backgroundColor = UIColor(named: "profile\(color)")
    }
  }
  
  /// 화원가입 API
  func emailJoinAPI() {
    self.memberRequest.member_name = self.nicknameTextField.text
    self.memberRequest.member_role1 = self.selectedAvatar[0]!.toString
    self.memberRequest.member_role2 = self.selectedAvatar[1]!.toString
    self.memberRequest.member_role3 = self.selectedAvatar[2]!.toString
    self.memberRequest.house_code = self.houseCodeTextField.text
    self.memberRequest.id_check = "Y"
    
    
    APIRouter.shared.api(path: .member_reg_in, parameters: self.memberRequest.toJSON()) { data in
      if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse, alertYn: true) {
        self.memberLoginAPI()
      }
    }
  }
  
  /// 회원 로그인 API
  func memberLoginAPI() {
    self.memberRequest.device_os = "I"
    self.memberRequest.gcm_key = self.appDelegate.fcmKey

    APIRouter.shared.api(path: .login, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        Defaults[.member_idx] = memberResponse.member_idx
        Defaults[.member_id] = self.memberRequest.member_id
        Defaults[.member_pw] = self.memberRequest.member_pw
        Defaults[.member_join_type] = "C"
        Defaults[.house_code] = memberResponse.house_code
        Defaults[.house_idx] = memberResponse.house_idx
        Defaults[.access_token] = memberResponse.access_token
        Defaults[.token_time] = Date()
        Defaults[.member_name] = memberResponse.member_name
        let destination = JoinFinishViewController.instantiate(storyboard: "Login")
        if var viewControllers = self.navigationController?.viewControllers {
          viewControllers = [destination]
          self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
        
      }
    }
  }
  
  /// 소셜 가입
  func snsJoinAPI() {
    self.memberRequest.member_name = self.nicknameTextField.text
    self.memberRequest.member_role1 = self.selectedAvatar[0]!.toString
    self.memberRequest.member_role2 = self.selectedAvatar[1]!.toString
    self.memberRequest.member_role3 = self.selectedAvatar[2]!.toString
    self.memberRequest.house_code = self.houseCodeTextField.text
    
    APIRouter.shared.api(path: .sns_member_reg_in, parameters: self.memberRequest.toJSON()) { data in
      if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse, alertYn: true) {
        self.snsLoginAPI()
        
      }
    }
  }
  
  /// 소셜 로그인
  func snsLoginAPI() {
    self.memberRequest.device_os = "I"
    self.memberRequest.gcm_key = self.appDelegate.fcmKey
    
    APIRouter.shared.api(path: .sns_member_login, method: .post, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        Defaults[.member_idx] = memberResponse.member_idx
        Defaults[.member_id] = self.memberRequest.member_id
        Defaults[.member_join_type] = self.memberRequest.member_join_type
        Defaults[.house_idx] = memberResponse.house_idx
        Defaults[.house_code] = memberResponse.house_code
        Defaults[.access_token] = memberResponse.access_token
        Defaults[.token_time] = Date()
        Defaults[.member_name] = memberResponse.member_name
        let destination = JoinFinishViewController.instantiate(storyboard: "Login")
        if var viewControllers = self.navigationController?.viewControllers {
          viewControllers = [destination]
          self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 회원가입
  /// - Parameter sender: 버튼
  @IBAction func joinButtonTouched(sender: UIButton) {
    if self.selectedAvatar == [nil,nil,nil] {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "아직 캐릭터가 없어요.\n캐릭터를 만들어 주세요.", aStrMessage: "", alertViewHiddenCheck: false, img: "error_circle") { position, title in
      }
    } else if self.nicknameTextField.text?.count ?? 0 == 0 {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "이름 또는 닉네임을 입력해 주세요.", aStrMessage: "", alertViewHiddenCheck: false, img: "error_circle") { position, title in
      }
    } else if !terms1Button.isSelected || !terms2Button.isSelected {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "필수 이용약관의 동의가 필요합니다.", aStrMessage: "", alertViewHiddenCheck: false, img: "error_circle") { position, title in
      }
    } else {
      if self.loginType == .normal {
        self.emailJoinAPI()
      } else {
        self.snsJoinAPI()
      }
    }
  }
  
  /// 약관
  /// - Parameter sender: 버튼
  @IBAction func termsTouched(sender: UIButton) {
    sender.isSelected = !sender.isSelected
    
    let buttonSelected = self.termsButtons.filter { (button) -> Bool in
      return (button.isSelected == false)
    }
    
    self.allTermsButton.isSelected = !(buttonSelected.count > 0)
  }
  
  /// 약관 전체보기
  /// - Parameter sender: 버튼
  @IBAction func termsDetailTouched(sender: UIButton) {
    let destination = WebViewController.instantiate(storyboard: "Commons")
    switch sender.tag {
    case 0:
      destination.webType = .terms0
      break
    case 1:
      destination.webType = .terms1
      break
    case 2:
      destination.webType = .terms2
      break
    case 3:
      destination.webType = .terms3
      break
    default:
      break
    }
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 전체 선택
  /// - Parameter sender: UIButton
  @IBAction func allTouched(sender: UIButton) {
    sender.isSelected = !sender.isSelected
    for value in self.termsButtons {
      value.isSelected = sender.isSelected
    }
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - AvatarDelegate
//-------------------------------------------------------------------------------------------
extension JoinViewController: AvatarDelegate {
  func avatarDelegate(selectedAvatar: [Int]) {
    self.selectedAvatar = selectedAvatar
    self.setAvatarView()
  }
}
