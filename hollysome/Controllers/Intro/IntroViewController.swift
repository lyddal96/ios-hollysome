//
//  IntroViewController.swift
//  hollysome
//
import UIKit
import Defaults

class IntroViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var timer: Timer?
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
//    self.perform(#selector(self.delay), with: nil, afterDelay: 1)
    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.retry), userInfo: nil, repeats: true)
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  @objc func retry() {
    if self.appDelegate.fcmKey.isNil {
      return
    } else {
      self.timer?.invalidate()
      self.timer = nil
      self.delay()
    }
  }
  @objc func delay() {
    Defaults[.poke_cnt] = 3

    if Defaults[.member_idx] != nil && Defaults[.member_join_type] == "C" {
      let memberRequest = MemberModel()
      memberRequest.member_id = Defaults[.member_id]
      memberRequest.member_pw = Defaults[.member_pw]
      memberRequest.device_os = "I"
      memberRequest.gcm_key = self.appDelegate.fcmKey
      APIRouter.shared.api(path: APIURL.login, parameters: memberRequest.toJSON()) { data in
        if let memberResponse = MemberModel(JSON: data), memberResponse.code == "1000" {
          Defaults[.member_idx] = memberResponse.member_idx
          Defaults[.member_join_type] = "C"
          Defaults[.house_code] = memberResponse.house_code
          Defaults[.house_idx] = memberResponse.house_idx
          self.gotoMain()
        } else {
          self.resetDefaults()
          self.gotoLogin()
        }
      }
    } else if Defaults[.member_idx] != nil && Defaults[.member_join_type] != "C" {
      let memberRequest = MemberModel()
      memberRequest.member_id = Defaults[.member_id]
      memberRequest.member_join_type = Defaults[.member_join_type]
      memberRequest.device_os = "I"
      memberRequest.gcm_key = self.appDelegate.fcmKey
      APIRouter.shared.api(path: APIURL.sns_member_login, parameters: memberRequest.toJSON()) { data in
        if let memberResponse = MemberModel(JSON: data), memberResponse.code == "1000" {
          Defaults[.member_idx] = memberResponse.member_idx
          Defaults[.house_code] = memberResponse.house_code
          Defaults[.house_idx] = memberResponse.house_idx
          self.gotoMain()
        } else {
          self.resetDefaults()
          self.gotoLogin()
        }
      }
    } else {
//      self.gotoMain()
      self.gotoLogin()
    }

      //    } else { //SNS 로그인
      //      if Defaults[.member_join_type] == "K" && Defaults[.member_idx] != nil {
      //        let memberParam = MemberModel()
      //        memberParam.member_id = Defaults[.id]
      //        memberParam.member_join_type = "K"
      //        memberParam.gcm_key = self.appDelegate.fcmKey ?? ""
      //        memberParam.device_os = "I"
      //
      //        let router = APIRouter(path: APIURL.sns_member_login, method: .post, parameters: memberParam.toJSON())
      //        router.sns_member_login(success: { (response) in
      //          if response.code == "1000" {
      //
      //            Defaults[.member_idx] = response.member_idx ?? ""
      //            Defaults[.member_join_type] = "K"
      //
      //            let destination = MainTabBarViewController.instantiate(storyboard: "Main")
      //            destination.hero.isEnabled = true
      //            destination.hero.modalAnimationType = .zoom
      //            destination.modalPresentationStyle = .fullScreen
      //            self.present(destination, animated: true, completion: nil)
      //
      //          } else if response.code == "2000" {
      //            self.gotoMain()
      //          } else {
      //            let alert = UIAlertController(title: "", message: response.code_msg ?? "", preferredStyle: .alert)
      //            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
      //              self.gotoMain()
      //            }))
      //            alert.show()
      //          }
      //        })
      //    } else {
      //      self.gotoMain()
      //    }
//    } else {
//      self.gotoMain()
//    }
//
  }
  
  
  
  /// 메인 화면으로
  func gotoMain() {
    let destination = MainTabBarViewController.instantiate(storyboard: "Main")
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    window?.rootViewController = destination
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


