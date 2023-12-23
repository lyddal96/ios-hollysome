//
//  ModifyInfoViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/21/23.
//

import UIKit
import Defaults

class ModifyInfoViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var avatarView: UIView!
  @IBOutlet weak var shapeImageView: UIImageView!
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var nicknameTextField: UITextField!
//  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var modifyPwButton: UIButton!
  @IBOutlet weak var modifyButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var memberData = MemberModel()
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
    
    self.nicknameTextField.setCornerRadius(radius: 4)
    self.nicknameTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.modifyPwButton.setCornerRadius(radius: 12)
    self.modifyPwButton.addBorder(width: 1, color: UIColor(named: "accent")!)
    self.modifyButton.setCornerRadius(radius: 12)
    
    self.nicknameTextField.setTextPadding(15)
    
    self.setAvatarView()
    self.nicknameTextField.text = self.memberData.member_name ?? ""
    self.modifyPwButton.isHidden = Defaults[.member_join_type] != "C"
  }
  
  override func initRequest() {
    super.initRequest()
    
    /// 캐릭터 만들기
    self.avatarView.addTapGesture { recognizer in
      let destination = CreateAvatarViewController.instantiate(storyboard: "Commons")
      destination.selectedAvatar = [(self.memberData.member_role1 ?? "").toInt() ?? 0, (self.memberData.member_role2 ?? "").toInt() ?? 0, (self.memberData.member_role3 ?? "").toInt() ?? 0]
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
    self.shapeImageView.setCornerRadius(radius: 61.5)
    self.colorView.setCornerRadius(radius: 40)
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
    
    
    self.shapeImageView.image = UIImage(named: "\(shapeList[(self.memberData.member_role1 ?? "").toInt() ?? 0])71")
    
    self.faceImageView.image = UIImage(named: "face\(self.memberData.member_role2 ?? "")")
    
    self.colorView.backgroundColor = UIColor(named: "profile\(self.memberData.member_role3 ?? "")")
  }
  
  /// 내 정보 수정 API
  func memberInfoModUpAPI() {
    self.memberData.member_name = self.nicknameTextField.text
    
    APIRouter.shared.api(path: .member_info_mod_up, method: .post, parameters: self.memberData.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse, alertYn: true) {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "내 정보가 수정되었습니다.", aStrMessage: "", alertViewHiddenCheck: false, img: "check_circle") { position, title in
          if position == 0 {
            self.navigationController?.popViewController(animated: true)
          }
        }
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 비밀번호 변경하기
  /// - Parameter sender: 버튼
  @IBAction func modifyPwButtonTouched(sender: UIButton) {
    let destination = ModifyPwViewController.instantiate(storyboard: "My")
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 수정
  /// - Parameter sender: 버튼
  @IBAction func modifyButtonTouched(sender: UIButton) {
    self.memberInfoModUpAPI()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - AvatarDelegate
//-------------------------------------------------------------------------------------------
extension ModifyInfoViewController: AvatarDelegate {
  func avatarDelegate(selectedAvatar: [Int]) {

    self.memberData.member_role1 = selectedAvatar[0].toString
    self.memberData.member_role2 = selectedAvatar[1].toString
    self.memberData.member_role3 = selectedAvatar[2].toString
    
    self.setAvatarView()
  }
}
