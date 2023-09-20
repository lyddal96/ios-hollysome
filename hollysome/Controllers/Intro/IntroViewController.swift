//
//  IntroViewController.swift
//  hollysome
//
//  Created by rocateer on 2020/01/09.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Defaults

class IntroViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  
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
    self.perform(#selector(self.delay), with: nil, afterDelay: 1)
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  @objc func delay() {
//    Defaults[.access_token] = nil
    if Defaults[.access_token] != nil {
      let memberRequest = MemberModel()
      memberRequest.email = Defaults[.email]
      memberRequest.password = Defaults[.password]
      memberRequest.fcm_key = self.appDelegate.fcmKey ?? ""
      memberRequest.device_type = "I"
      APIRouter.shared.api(path: APIURL.login, parameters: memberRequest.toJSON()) { data in
        if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse) {
          if let result = memberResponse.result {
            Defaults[.access_token] = result.access_token
//            self.navigationController?.popViewController(animated: true)
            self.gotoMain()
          }
        }
      }
//      APIRouter.shared.api(path: .login, parameters: memberRequest.toJSON()) { response in
//        if let memberResponse = MemberModel(JSON: response) {
//          if memberResponse.success == true {
//
//            Defaults[.access_token] = memberResponse.access_token ?? ""
//            let destination = MainTabBarViewController.instantiate(storyboard: "Main")
//            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//            window?.rootViewController = destination
//            //
//          } else {
//            Defaults[.access_token] = nil
//            Defaults[.password] = nil
//            self.gotoMain()
//          }
//        }
//      }
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


