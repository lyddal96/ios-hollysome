//
//  APIResponse.swift
//  hollysome
//
//  Created by rocateer on 2023/06/16.
//  Copyright © 2023 rocateer. All rights reserved.
//


import Foundation
import Alamofire
import Defaults

class APIResponse {
  static let shared = APIResponse()
  
  final let HTTP_OK = 200
  final let HTTP_BAD_REQUEST = 400
  final let HTTP_UNAUTHORIZED = 401
  final let HTTP_FORBIDDEN = 403
  final let HTTP_NOT_FOUND = 404
  final let HTTP_INTERNAL_SERVER_ERROR = 500
  
  private init() {
  }
  
  
  //  HTTPURLResponse
  /// API 성공 유무를 판단
  /// - Parameter response:
  /// - Returns: 성공 여부
  func isSuccessStatus(response: AFDataResponse<Any>) -> Bool {
    if let underlyingError = response.error?.underlyingError, let urlError = underlyingError as? URLError {
      Tools.shared.showToast(message: urlError.localizedDescription)
      switch urlError.code {
      case .timedOut: log.debug("Timed out error")
      case .notConnectedToInternet: log.debug("Not connected")
      default: log.debug("Unmanaged error")
      }
      return false
    }
    
    
    switch response.response?.statusCode {
    case HTTP_OK: // 성공
      
      return true
    case HTTP_UNAUTHORIZED: // 유효하지 않은 access_token
      if let value = response.result.value {
        let baseResponse = BaseModel(JSON: value as! [String : Any])
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: baseResponse?.message ?? "", alertViewHiddenCheck: false) { position, title in
          if position == 0 {
            Defaults.removeAll()
            Defaults[.tutorial] = true
            
            self.goToMainTabBar()
          }
        }
      }
      return false
    case HTTP_BAD_REQUEST, HTTP_FORBIDDEN, HTTP_NOT_FOUND, HTTP_INTERNAL_SERVER_ERROR:
      log.debug("statusCode : \(response.response?.statusCode ?? 0)")
      if let error = response.result.error {
        Tools.shared.showToast(message: error.localizedDescription)
      }
      return false
    default:
      return false
    }

  }
  
  //  response
  /// API 성공 유무를 판단
  /// - Parameter response:
  /// - Returns: 성공 여부
  func isSuccessResponse(response: BaseModel) -> Bool {
    if response.success ?? false {
      return true
    } else {
      if let errors = response.errors, errors.count > 0 {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: errors[0], alertViewHiddenCheck: false) { position, title in
        }
      } else {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: response.message ?? "", alertViewHiddenCheck: false) { position, title in
        }
      }
      return false
    }
  }
  
  
  /// 로그인 화면으로
  func goToLogin() {
    let destination = LoginViewController.instantiate(storyboard: "Login")
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .zoom
    destination.modalPresentationStyle = .fullScreen
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    window?.rootViewController = destination
  }
  
  
  /// 메인 탭화면으로
  func goToMainTabBar() {
    let destination = MainTabBarViewController.instantiate(storyboard: "Main")
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    window?.rootViewController = destination
  }
  
}
