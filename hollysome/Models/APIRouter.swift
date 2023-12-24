//
//  APIRouter.swift
//  hollysome
//
//  Created by rocket on 11/06/2019.
//
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
  case sns_member_reg_in = "sns_join_v_1_0_0/sns_member_reg_in" // 소셜 회원가입
  
  /// 홈
  case house_list = "house_v_1_0_0/house_list" // 홈리스트
  case today_schedule_end = "house_v_1_0_0/today_schedule_end" // 오늘 할일 완료하기
  case today_schedule_list = "house_v_1_0_0/today_schedule_list" // 오늘 할일 리스트
  
  
  /// 마이페이지
  case member_info_detail = "member_info_v_1_0_0/member_info_detail" // 내 정보
  case member_info_mod_up = "member_info_v_1_0_0/member_info_mod_up" // 내정보 수정
  case member_out_up = "member_out_v_1_0_0/member_out_up" // 탈퇴하기
  case pw_mod_up = "member_info_v_1_0_0/pw_mod_up" // 비밀번호 수정
  case alarm_toggle_view = "alarm_v_1_0_0/alarm_toggle_view" // 알림 상태 보기
  case alarm_toggle_mod_up = "alarm_v_1_0_0/alarm_toggle_mod_up" // 알림 변경
  
  /// 알림
  case alarm_list = "alarm_v_1_0_0/alarm_list" // 알림 리스트
  case alarm_del = "alarm_v_1_0_0/alarm_del" // 알림 삭제
  case alarm_all_del = "alarm_v_1_0_0/alarm_all_del" // 알림 전체 삭제
  
  /// 하우스
  case house_reg_in = "house_v_1_0_0/house_reg_in" // 하우스 만들기
  case house_join_in = "house_v_1_0_0/house_join_in" // 하우스 들어가기
  case house_out_up = "house_v_1_0_0/house_out_up" // 하우스 나가기
  case house_mod_up = "house_v_1_0_0/house_mod_up" // 하우스 사진 등록
  case mate_list = "book_v_1_0_0/mate_list" // 메이트 리스트
  
  /// 알림장
  case note_list = "note_v_1_0_0/note_list" // 알림장 리스트
  case note_reg_in = "note_v_1_0_0/note_reg_in" // 알림장 등록
  case note_detail = "note_v_1_0_0/note_detail" // 알림장 상세
  case note_mod_up = "note_v_1_0_0/note_mod_up" // 알림장 수정
  case note_del = "note_v_1_0_0/note_del" // 알림장 삭제
  case report_reg_in = "note_v_1_0_0/report_reg_in" // 알림장 신고
  case block_mod_up = "note_v_1_0_0/block_mod_up" // 알림장 차단

  /// 일정
  case schedule_list = "plan_v_1_0_0/schedule_list" // 날짜별 할일 리스트
  case plan_reg_in = "plan_v_1_0_0/plan_reg_in" // 새 일정 등록
  case schedule_date_list = "plan_v_1_0_0/schedule_date_list" // 달력 리스트
  case schedule_date_member_list = "plan_v_1_0_0/schedule_date_member_list" // 일자별 일정 리스트(달력)
  case plan_detail = "plan_v_1_0_0/plan_detail" // 일정 상세
  case plan_mod_up = "plan_v_1_0_0/plan_mod_up" // 일정 수정
  case plan_del = "plan_v_1_0_0/plan_del" // 일정 삭제

  /// 가계부
  case book_view = "book_v_1_0_0/book_view" // 당월 가계부
  case book_list = "book_v_1_0_0/book_list" // 전체 가계부 리스트
  case book_reg_in = "book_v_1_0_0/book_reg_in" // 가계부 등록
  case book_detail = "book_v_1_0_0/book_detail" // 가계부 상세
  case book_mod_up = "book_v_1_0_0/book_mod_up" // 가계부 수정
  
  
  /// CS
  case notice_list = "notice_v_1_0_0/notice_list" // 공지시항 리스트
  case notice_detail = "notice_v_1_0_0/notice_detail" // 공지사항 상세
  case faq = "api/faq/list" // faq
  case qa = "qa_v_1_0_0/qa_list" // 1:1문의 리스트
  case qa_detail = "qa_v_1_0_0/qa_detail" // 1:1문의 상세
  case qa_reg_in = "qa_v_1_0_0/qa_reg_in" // 1:1문의 등록
  case qa_del = "qa_v_1_0_0/qa_del" // 1:1문의 삭제
  case terms_list = "terms_web_view_v_1_0_0/terms_list" // 이용약관 리스트
  case terms_detail = "terms_web_view_v_1_0_0/terms_detail" // 이용약관 상세
  
  
  
  /// 파일 업로드
  case imageupload = "api/imageupload" // 이미지 업로드
  case imageMultiUpload = "api/imageMultiUpload" // 이미지 다중 업로드
  case fileUpload_action = "common/fileUpload_action" // 이미지 업로드
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
//  func api(path: APIURL, method: HTTPMethod = .post, file : Data, success: @escaping(_ data: [String: Any])-> Void) {
//    let headers: HTTPHeaders = [
//      "Content-type": "multipart/form-data"
//    ]
//    NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData, nil)
//    AF.upload(multipartFormData: { (multipartFormData) in
//      multipartFormData.append(file, withName: "image", fileName: "rocateer.png", mimeType: "image/jpeg")
//    }, to: baseURL + path.rawValue, method: .post, headers: headers).responseJSON(completionHandler: { response in
//      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//      if APIResponse.shared.isSuccessStatus(response: response) {
//        success(response.result.value as! [String : Any])
//      }
//    })
//  }
  
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
    multipartFormData.append(file, withName: "file", fileName: "rocateer.jpg", mimeType: "image/jpeg")
    }, to: baseURL + path.rawValue, method: .post, headers: headers).responseJSON(completionHandler: { response in
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      switch response.result {
      case .success(let value):
        success(value as! [String : Any])
      case .failure(let error):
        break
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


