//
//  MemberModel.swift
//  RocateerKit
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class MemberModel: BaseModel {
  // 이메일
  var email: String?
  // 비밀번호
  var password: String?
  // 비밀번호 확인
  var password_confirmation: String?
  // 이름
  var name: String?
  // 연락처
  var phone: String?
  // 생년월일
  var birth: String?
  // 팔로워 수
  var follower_count: Int?
  // 팔로잉 수
  var following_count: Int?
  // 성별 - 0 : 남자, 1: 여자
  var gender: String?
  
  var result: MemberModel?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.email <- map["email"]
    self.password <- map["password"]
    self.password_confirmation <- map["password_confirmation"]
    self.name <- map["name"]
    self.phone <- map["phone"]
    self.birth <- map["birth"]
    self.follower_count <- map["follower_count"]
    self.following_count <- map["following_count"]
    self.gender <- map["gender"]
    
    
    self.result <- map["result"]
  }
}
