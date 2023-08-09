//
//  JoinViewController.swift
//  hollysome
//
//  Created by rocateer on 19/09/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import UIKit
import Defaults

class JoinViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var pwTextField: UITextField!
  @IBOutlet weak var pwConfirmTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var birthTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var certificationButton: UIButton!
  @IBOutlet weak var certificationTextField: UITextField!
  @IBOutlet weak var certificationOKButton: UIButton!
  
  @IBOutlet weak var nicknameTextField: UITextField!
  @IBOutlet weak var manButton: UIButton!
  @IBOutlet weak var womanButton: UIButton!
  @IBOutlet weak var neutralButton: UIButton!
  
  @IBOutlet weak var authButton: UIButton!
  
  @IBOutlet weak var allTermsButton: UIButton!
  @IBOutlet weak var terms1Button: UIButton!
  @IBOutlet weak var terms2Button: UIButton!
  @IBOutlet weak var terms3Button: UIButton!
  @IBOutlet weak var terms4Button: UIButton!
  @IBOutlet weak var terms1DetailButton: UIButton!
  @IBOutlet weak var terms2DetailButton: UIButton!
  @IBOutlet weak var terms3DetailButton: UIButton!
  @IBOutlet weak var terms4DetailButton: UIButton!

  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var gender = 0
  
  var time = 300
  var timer: Timer?
  
  var verify_idx = ""
  var verify_yn = "N"
  var termsButtons: [UIButton] = []
  
  let memberRequest = MemberModel()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let datePickerView: UIDatePicker = UIDatePicker()
////    datePickerView.datePickerMode = .date
//    datePickerView.datePickerMode = .date
//    datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
//    datePickerView.maximumDate = Date()
//    self.birthTextField.inputView = datePickerView
    self.birthTextField.setInputViewDatePicker(target: self, selector: #selector(self.tapDone), minimumDate: nil, maximumDate: Date())
   
    self.phoneTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.birthTextField.tintColor = .clear
    self.idTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.pwTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.pwConfirmTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.nameTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.birthTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.phoneTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.nicknameTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.certificationButton.addBorder(width: 1, color: UIColor(named: "DDDDDD")!)
    self.certificationTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.certificationOKButton.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.authButton.addBorder(width: 1, color: UIColor(named: "primary")!)
    self.authButton.setCornerRadius(radius: 10)
    self.termsButtons.append(self.terms1Button)
    self.termsButtons.append(self.terms2Button)
    self.termsButtons.append(self.terms3Button)
    self.termsButtons.append(self.terms4Button)
    
  }
  
  override func initRequest() {
    super.initRequest()
    
    let genderButtons = [self.manButton, self.womanButton, self.neutralButton]
    
    for value in genderButtons {
      value?.addTapGesture(action: { (recognizer) in
        for value2 in genderButtons {
          value2?.isSelected = false
        }
        let index = genderButtons.firstIndex(of: value)
        self.gender = index ?? 0
        value?.isSelected = true
      })
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     
     self.timer?.invalidate()
     self.timer = nil
     
   }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
//  /// 회원가입 API
//  func memberRegInAPI() {
//    let memberRequest = MemberModel()
//    memberRequest.member_id = self.idTextField.text ?? ""
//    memberRequest.member_pw = self.pwTextField.text ?? ""
//    memberRequest.member_pw_confirm = self.pwConfirmTextField.text ?? ""
//    memberRequest.member_name = self.nameTextField.text ?? ""
//    memberRequest.member_birth = self.birthTextField.text ?? ""
//    memberRequest.member_phone = self.phoneTextField.text ?? ""
//    memberRequest.member_gender = "\(self.gender)"
//    memberRequest.member_nickname = self.nicknameTextField.text ?? ""
//
//    APIRouter.shared.api(path: .member_reg_in, parameters: memberRequest.toJSON()) { response in
//      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
//        let destination = JoinFinishViewController.instantiate(storyboard: "Intro")
//        self.navigationController?.pushViewController(destination, animated: true)
//      }
//    } 
//
//  }
//
  
  /// 회원가입 API
  func registerAPI() {
    let memberRequest = MemberModel()
    memberRequest.email = self.idTextField.text ?? ""
    memberRequest.password = self.pwTextField.text ?? ""
    memberRequest.password_confirmation = self.pwConfirmTextField.text ?? ""
    memberRequest.name = self.nameTextField.text ?? ""
    memberRequest.phone = self.phoneTextField.text ?? ""
    memberRequest.gender = self.manButton.isSelected ? "0" : self.womanButton.isSelected ? "1" : nil
    memberRequest.birth = self.birthTextField.text ?? ""
    
    
    APIRouter.shared.api(path: APIURL.register, parameters: memberRequest.toJSON()) { data in
      if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse) {
        if let result = memberResponse.result {
          Defaults[.access_token] = result.access_token ?? ""
          Defaults[.name] = result.name ?? ""
          Defaults[.email] = self.idTextField.text ?? ""
          Defaults[.password] = self.pwTextField.text ?? ""
        }
      }
    }

  }
  
  @objc func datePickerValueChanged(sender: UIDatePicker) {
    self.birthTextField.text = sender.date.toString(format: "yyyyMMdd")
  }
  
  // 날짜 선택
  @objc func tapDone() {
    if let datePicker = self.birthTextField.inputView as? UIDatePicker {
      let dateformatter = DateFormatter()
      dateformatter.dateFormat = "yyyyMMdd"
      self.birthTextField.text = dateformatter.string(from: datePicker.date)
    }
    self.birthTextField.resignFirstResponder()
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    self.verify_idx = ""
    self.verify_yn = "N"
    self.certificationTextField.text = ""
    self.time = 300
//    self.timeLabel.text = "05:00"
//    self.timeLabel.isHidden = true
  }
  
  /// 인증번호 타이머
  @objc func timerAction() {
    if self.time > 0 {
      log.debug(self.time)
      self.time -= 1
      let minutes = self.time / 60 % 60
      let seconds = self.time % 60
      //      self.certificationTextField.placeholder = "\(minutes):\(seconds) 이내 입력해 주세요"
      self.certificationTextField.placeholder = String(format:"%02i:%02i 이내 입력해 주세요", minutes, seconds)
      
    } else {
      self.timer?.invalidate()
      self.timer = nil
      
    }
  }
//
//  /// 휴대전화 인증키 발급
//  private func telVerifySettingAPI() {
//    let memberReqeust = MemberModel()
//    memberReqeust.member_phone = self.phoneTextField.text
//
//    APIRouter.shared.api(path: .tel_verify_setting, parameters: memberReqeust.toJSON()) { response in
//      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
//        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: memberResponse.code_msg ?? "", alertViewHiddenCheck: false) { (position, title) in
//        }
//
//        self.certificationButton.setTitle("재요청", for: .normal)
//        self.verify_idx = memberResponse.verify_idx ?? ""
//        self.certificationTextField.isUserInteractionEnabled = true
//
//        // 임시로 테스트를 위해 세팅
//        self.certificationTextField.text = memberResponse.verify_num
//        self.certificationOKButton.isUserInteractionEnabled = true
//        self.verify_yn = memberResponse.verify_yn ?? ""
//
//        self.timer?.invalidate()
//        self.timer = nil
//        self.certificationTextField.text = ""
//        if self.timer == nil {
//          self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
//        }
//      }
//    } 
//  }
//
//  /// 휴대전화 인증키 확인
//  private func telVerifyConfirmAPI() {
//    let memberReqeust = MemberModel()
//    memberReqeust.verify_idx = self.verify_idx
//    memberReqeust.verify_num = self.certificationTextField.text
//
//    APIRouter.shared.api(path: .tel_verify_confirm, parameters: memberReqeust.toJSON()) { response in
//      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
//        self.view.endEditing(true)
//        self.timer?.invalidate()
//        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: memberResponse.code_msg ?? "", alertViewHiddenCheck: false) { (position, title) in
//        }
//      }
//    } 
//  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 가입 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func joinButtonTouched(sender: UIButton) {
    self.registerAPI()
//    if self.verify_yn == "N" {
//      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "전화 번호 인증이 완료 되지 않았습니다. 인증번호를 입력 후 확인을 눌러 주세요.", alertViewHiddenCheck: false) { (position, title) in
    //본인 인증을 하지 않으셨습니다.
//      }
//    } else {
//      self.memberRegInAPI()
//    }
    
  }
  
  /// 인증번호 요청
  /// - Parameter sender: 버튼
  @IBAction func certificationTouched(sender: UIButton) {
//    self.telVerifySettingAPI()
  }
  
  /// 인증번호 확인
  /// - Parameter sender: 버튼
  @IBAction func okTouched(sender: UIButton) {
    if self.time <= 0 {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "인증 번호 입력 시간을 초과하였습니다. 다시 진행해 주세요.", alertViewHiddenCheck: false) { (position, title) in
      }
    } else {
//      self.telVerifyConfirmAPI()
    }
  }
  
  /// 본인인증
  /// - Parameter sender: 버튼
  @IBAction func authTouched(sender: UIButton) {
    let destination = WebViewController.instantiate(storyboard: "Commons")
    destination.webType = .auth
    destination.delegate = self
    self.navigationController?.pushViewController(destination, animated: true)
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
// MARK: - WebResultDelegate
//-------------------------------------------------------------------------------------------
extension JoinViewController: WebResultDelegate {
  // [TODO][2023/06/13][Yujin] : 결과값 전달
}

