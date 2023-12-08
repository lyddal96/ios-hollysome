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
  
  var result: MemberModel?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.member_id <- map["member_id"]
    self.member_pw <- map["member_pw"]
    self.member_pw_confirm <- map["member_pw_confirm"]
    self.member_name <- map["member_name"]
    self.member_phone <- map["member_phone"]
    self.birth <- map["birth"]
    self.follower_count <- map["follower_count"]
    self.following_count <- map["following_count"]
    self.gender <- map["gender"]
    self.member_email <- map["member_email"]
    self.member_join_type <- map["member_join_type"]
    
    self.result <- map["result"]
  }
}
