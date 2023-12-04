//
//  APIRouter.swift
//  hollysome
//
//  Created by rocket on 11/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Alamofire
import ObjectMapper
import SwiftyJSON
import Result
import NVActivityIndicatorView
import Defaults

#if DEBUG
//let baseURL = "http://192.168.50.81/"
let baseURL = "http://noom.api.hollysome.com/"
#else
//let baseURL = "http://192.168.50.81/"
let baseURL = "http://noom.api.hollysome.com/"
#endif

typealias JSONDict = [String: AnyObject]
typealias APIParams = [String: AnyObject]?

enum APIResult<T, Error> {
  case success(T)
  case fail(NSError)
  case unexpect(NSError)
}

enum APIURL: String {
  /// 인증
  case member_reg_in = "join_v_1_0_0/member_reg_in" // 회원가입
  case sns_member_login = "sns_login_v_1_0_0/sns_member_login" // sns 로그인
  case login = "login_v_1_0_0/member_login" // 로그인
  case me = "api/me" // 사용자 프로필 정보 확인
  case logout = "logout_v_1_0_0/member_logout" // 로그아웃
  case member_id_check = "join_v_1_0_0/member_id_check" // 아이디 중복확인
  case passwordemail_check_in = "join_v_1_0_0/passwordemail_check_in" // 비밀번호/이메일 유효성 확인
  case app_info_mod_up = "sns_join_v_1_0_0/app_info_mod_up" // 추가정보 입력
  
  
  
  
  /// CS
  case notice = "api/notice/list" // 공지시항 리스트
  case notice_detail = "api/notice/detail" // 공지사항 상세
  case faq = "api/faq/list" // faq
  case qa = "api/qa/list" // 1:1문의 리스트
  case qa_detail = "api/qa/detail" // 1:1문의 상세
  case qa_create = "api/qa/create" // 1:1문의 등록
  case qa_delete = "api/qa/delete" // 1:1문의 삭제
  
  
  
  /// 파일 업로드
  case imageupload = "api/imageupload" // 이미지 업로드
  case imageMultiUpload = "api/imageMultiUpload" // 이미지 다중 업로드
  
}


class APIRouter {
  // Singleton
  static let shared = APIRouter()
  var activityData: ActivityData = ActivityData()
  
  private init() {
    self.activityData = ActivityData(size: CGSize(width: 50, height: 50), message: "", messageFont: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor(named: "333333"), padding: nil, displayTimeThreshold: 1, minimumDisplayTime: 300, backgroundColor: UIColor.clear, textColor: UIColor.black)
  }
  
  
  /// Simple API
  /// - Parameters:
  ///   - path: API URL
  ///   - method: HTTP Method
  ///   - parameters: parameter
  ///   - success: 성공
  ///   - fail: 실패
  func api(path: APIURL, method: HTTPMethod = .post, parameters: [String: Any]?, success: @escaping(_ data: [String: Any])-> Void) {
    
    var headers: HTTPHeaders = []
//    if let access_token = Defaults[.access_token], access_token != "", path != .login {
//      headers = [
//        "Authorization" : "Bearer \(access_token)",
//      ]
//    }
    
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData, nil)
    AF.request( baseURL + path.rawValue, method:method, parameters: parameters, headers: headers).responseJSON(completionHandler: { response in
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      
      if APIResponse.shared.isSuccessStatus(response: response) {
        success(response.result.value as! [String : Any])
      }
    })
  }
  
  
  /// Multipart Form
  /// - Parameters:
  ///   - path: API URL
  ///   - method: HTTP Method
  ///   - userFile: File
  ///   - success: 성공
  ///   - fail: 실패
  func api(path: APIURL, method: HTTPMethod = .post, file : Data, success: @escaping(_ data: [String: Any])-> Void) {
    let headers: HTTPHeaders = [
      "Content-type": "multipart/form-data"
    ]
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData, nil)
    AF.upload(multipartFormData: { (multipartFormData) in
      multipartFormData.append(file, withName: "image", fileName: "rocateer.png", mimeType: "image/jpeg")
    }, to: baseURL + path.rawValue, method: .post, headers: headers).responseJSON(completionHandler: { response in
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      if APIResponse.shared.isSuccessStatus(response: response) {
        success(response.result.value as! [String : Any])
      }
    })
  }
  
  /// Multipart Form
  /// - Parameters:
  ///   - path: API URL
  ///   - method: HTTP Method
  ///   - userFile: File
  ///   - success: 성공
  ///   - fail: 실패
  func multiApi(path: APIURL, method: HTTPMethod = .post, fileList: [Data], success: @escaping(_ data: [String: Any])-> Void) {
    let headers: HTTPHeaders = [
      "Content-type": "multipart/form-data"
    ]
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData, nil)
    AF.upload(multipartFormData: { (multipartFormData) in
      for value in fileList {
        multipartFormData.append(value, withName: "image[]", fileName: "rocateer.png", mimeType: "image/jpeg")
      }
    }, to: baseURL + path.rawValue, method: .post, headers: headers).responseJSON(completionHandler: { response in
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      if APIResponse.shared.isSuccessStatus(response: response) {
        success(response.result.value as! [String : Any])
      }
    })
  }
  
}


