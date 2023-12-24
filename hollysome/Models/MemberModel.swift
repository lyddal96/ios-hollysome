//
//  MemberModel.swift
//  hollysome
//
//  Created by rocket on 10/06/2019.
//
//

import Foundation
import ObjectMapper

class MemberModel: BaseModel {
  // 이메일
  var member_id: String?
  // 비밀번호
  var member_pw: String?
  // 비밀번호 확인
  var member_pw_confirm: String?
  // 이름
  var member_name: String?
  /// 닉네임
  var member_nickname: String?
  // 연락처
  var member_phone: String?
  // 생년월일
  var birth: String?
  // 팔로워 수
  var follower_count: Int?
  // 팔로잉 수
  var following_count: Int?
  // 성별 - 0 : 남자, 1: 여자
  var gender: String?
  /// 이메일
  var member_email: String?
  /// 회원가입 타입
  var member_join_type: String?
  /// 새 비밀번호
  var member_new_pw: String?
  /// 새 비밀번호 확인
  var member_confirm_pw: String?
  /// 전체 알림
  var all_alarm_yn: String?
  /// 나의 할일
  var alarm_my_item_yn: String?
  /// 콕 찌르기
  var alarm_call_out_yn: String?
  /// 0: 전체 알림 1: 나의 할일 2: 콕찌르기
  var alarm_type: String?
  /// 알림 여부 YN
  var alarm_yn: String?
  /// 동의 여부
  var member_leave_yn: String?
  /// 탈퇴 사유
  var member_leave_reason: String?
  
  
  
  var result: MemberModel?


  var isSelected: Bool?

  /// 리스트
  var data_array: [MemberModel]?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.member_id <- map["member_id"]
    self.member_pw <- map["member_pw"]
    self.member_pw_confirm <- map["member_pw_confirm"]
    self.member_name <- map["member_name"]
    self.member_nickname <- map["member_nickname"]
    self.member_phone <- map["member_phone"]
    self.birth <- map["birth"]
    self.follower_count <- map["follower_count"]
    self.following_count <- map["following_count"]
    self.gender <- map["gender"]
    self.member_email <- map["member_email"]
    self.member_join_type <- map["member_join_type"]
    self.member_new_pw <- map["member_new_pw"]
    self.member_confirm_pw <- map["member_confirm_pw"]
    self.all_alarm_yn <- map["all_alarm_yn"]
    self.alarm_my_item_yn <- map["alarm_my_item_yn"]
    self.alarm_call_out_yn <- map["alarm_call_out_yn"]
    self.alarm_type <- map["alarm_type"]
    self.alarm_yn <- map["alarm_yn"]
    self.member_leave_yn <- map["member_leave_yn"]
    self.member_leave_reason <- map["member_leave_reason"]
    
    self.result <- map["result"]
    self.data_array <- map["data_array"]
  }
}
