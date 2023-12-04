//
//  BaseModel.swift
//  hollysome
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel: Mappable {
  /// 메세지
  var code_msg: String?
  var code: String?
  // 회원 키
  var member_idx: String?
  // 성공 여부
  var success: Bool?
  // 메세지
  var message: String?
  // Google FCM Key
  var gcm_key: String?
  // 디바이스 종류. 1: Android, 2: IOS, 3: Other
  var device_os: String?
  // 에러목록
  var errors: [String]?
  // 키
  var id: Int?
  
  /// 현재 페이지 번호
  var page: Int?
  /// 리스트 갯수
  var list_cnt: Int?
  /// 총 페이지 수
  var total_page: Int?
  /// 총 아이템 갯수
  var total_cnt: Int?
  /// 페이지당 갯수
  var per_page: Int?
  // 공지사항 타겟 - 0 : 사용자 , 1 : 파트너
  var target: Int?
  /// 캐릭터 얼굴
  var member_role1: String?
  /// 캐릭터 표정
  var member_role2: String?
  /// 캐릭터 컬러
  var member_role3: String?
  /// 하우스 코드
  var house_code: String?
  /// 아이디 중복확인 YN
  var id_check: String?
  /// 필수 이용 약관
  var term_arr: String?
  
  init() {
  }
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    self.code_msg <- map["code_msg"]
    self.code <- map["code"]
    self.member_idx <- map["member_idx"]
    self.success <- map["success"]
    self.message <- map["message"]
    self.gcm_key <- map["gcm_key"]
    self.device_os <- map["device_os"]
    self.errors <- map["errors"]
    self.id <- map["id"]
    self.page <- map["page"]
    self.list_cnt <- map["list_cnt"]
    self.total_page <- map["total_page"]
    self.total_cnt <- map["total_cnt"]
    self.per_page <- map["per_page"]
    self.target <- map["target"]
    self.member_role1 <- map["member_role1"]
    self.member_role2 <- map["member_role2"]
    self.member_role3 <- map["member_role3"]
    self.house_code <- map["house_code"]
    self.id_check <- map["id_check"]
    self.term_arr <- map["term_arr"]
  }
  
  
  /// 다음 페이지 넘버 받아오는 함수
  /// : 페이지 넘버가 없을 경우에는 1로 시작한다.
  /// - Parameter pageNum: 현재 페이지 넘버
  func setNextPage() {
    if let page = self.page {
      self.page = page + 1
    } else {
      self.page = 1
    }
  }
  
  /// 페이징 초기화
  func resetPage() {
    self.page = 0
  }
  
  
  /// total Page 세팅
  ///
  /// - Parameter total_page: totalPage
  func setTotalPage(total_page: Int) {
    self.total_page = total_page
  }
  
  
  /// total page 가져오기
  ///
  /// - Returns: total page
  func getTotalPage() -> Int {
    return self.total_page ?? 0
  }
  
  /// 다음 페이지가 있는지 체크
  ///
  /// - Returns: 다음페이지가 있는지 체크
  func isMore() -> Bool {
    if getTotalPage() > (self.page ?? 1) {
      return true
    } else {
      return false
    }
  }
}

