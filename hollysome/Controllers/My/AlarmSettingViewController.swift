//
//  AlarmSettingViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/24/23.
//

import UIKit
import Defaults

class AlarmSettingViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var allAlarmSwitch: UISwitch!
  @IBOutlet weak var myView: UIView!
  @IBOutlet weak var mySwitch: UISwitch!
  @IBOutlet weak var pokeView: UIView!
  @IBOutlet weak var pokeSwitch: UISwitch!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

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
    
    self.myView.isHidden = Defaults[.house_idx] == nil
    self.pokeView.isHidden = Defaults[.house_idx] == nil
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.alarmToggleViewAPI()
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 알림 상태 확인
  func alarmToggleViewAPI() {
    let alarmRequest = MemberModel()
    alarmRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .alarm_toggle_view, method: .post, parameters: alarmRequest.toJSON()) { response in
      if let alarmResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: alarmResponse) {
        self.allAlarmSwitch.isOn = alarmResponse.all_alarm_yn == "Y"
        self.mySwitch.isOn = alarmResponse.alarm_my_item_yn == "Y"
        self.pokeSwitch.isOn = alarmResponse.alarm_call_out_yn == "Y"
      }
    }
  }
  
  /// 알림 설정 API
  func alarmToggleModUpAPI(alarm_type: String, alarm_yn: String) {
    let alarmRequest = MemberModel()
    alarmRequest.member_idx = Defaults[.member_idx]
    alarmRequest.alarm_type = alarm_type
    alarmRequest.alarm_yn = alarm_yn
    
    APIRouter.shared.api(path: .alarm_toggle_mod_up, method: .post, parameters: alarmRequest.toJSON()) { response in
      if let alarmResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: alarmResponse) {
        self.alarmToggleViewAPI()
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 전체 알림
  /// - Parameter sender: 스위치
  @IBAction func allAlarmSwitchToggled(sender: UISwitch) {
    log.debug("all Alarm \(sender.isOn)")
    self.alarmToggleModUpAPI(alarm_type: "0", alarm_yn: sender.isOn ? "Y" : "N")
  }
  
  /// 나의 할일
  /// - Parameter sender: 스위치
  @IBAction func mySwitchToggled(sender: UISwitch) {
    self.alarmToggleModUpAPI(alarm_type: "1", alarm_yn: sender.isOn ? "Y" : "N")
  }
  
  /// 콕 찌르기
  /// - Parameter sender: 스위치
  @IBAction func pokeSwitchToggled(sender: UISwitch) {
    self.alarmToggleModUpAPI(alarm_type: "2", alarm_yn: sender.isOn ? "Y" : "N")
  }
}
