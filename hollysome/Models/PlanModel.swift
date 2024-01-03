//
//  PlanModel.swift
//  hollysome
//
//  Created by 이승아 on 12/24/23.
//

import Foundation
import ObjectMapper

class PlanModel: BaseModel {
  /// 일정명
  var plan_name: String?
  /// 알림 여부
  var alarm_yn: String?
  /// 알림 시간 (00 ~ 23)
  var alarm_hour: String?
  /// 일정 및 인원 ex) [{"week_arr": "1,2", "member_arr": "2,3"},{"week_arr": "3,4,5,6,7", "member_arr": "3,10"}]
  var item_array: String?
  /// 닉네임
  var member_nickname: String?
  /// 요일 리스트 ( 1 : 일 2: 월 ........ 7 : 토 )
  var week_arr: String?
  /// 회원 키 리스트
  var member_arr: String?
  /// 날짜
  var today: String?
  /// 할일 키
  var plan_idx: String?
  /// 일정 키 ( 인당 )
  var schedule_idx: String?
  /// 완료 여부
  var schedule_yn: String?
  /// 월 시작
  var s_date: String?
  /// 말일
  var e_date: String?
  /// 일정 날짜
  var schedule_date: String?
  /// 알림 제목
  var title: String?
  /// 내용
  var msg: String?
  var body: String?
  /// fcm키
  var registration_ids: [String]?
  var token: String?
  
  var sound: String?
  var mutable_content: Bool?
  var priority: String?
  var index: String?
  var notification: PlanModel?
  var count: Int?
  var click_action: String?
  var message: PlanModel?
  var data: PlanModel?
  
  var month: String?


  /// 선택 회원 리스트
  var selected_mate_list: [PlanModel]?
  var selected_week_list: [String]?

  /// 리스트
  var data_array: [PlanModel]?
  /// 일정 리스트(인원)
  var member_list: [PlanModel]?
  var schedule_item_member_list: [PlanModel]?
  var schedule_member_list: [PlanModel]?
  var plan_item_list: [PlanModel]?
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.plan_name <- map["plan_name"]
    self.alarm_yn <- map["alarm_yn"]
    self.alarm_hour <- map["alarm_hour"]
    self.item_array <- map["item_array"]
    self.member_nickname <- map["member_nickname"]
    self.week_arr <- map["week_arr"]
    self.member_arr <- map["member_arr"]
    self.today <- map["today"]
    self.plan_idx <- map["plan_idx"]
    self.schedule_idx <- map["schedule_idx"]
    self.schedule_yn <- map["schedule_yn"]
    self.s_date <- map["s_date"]
    self.e_date <- map["e_date"]
    self.schedule_date <- map["schedule_date"]
    self.title <- map["title"]
    self.msg <- map["msg"]
    self.body <- map["body"]
    self.registration_ids <- map["registration_ids"]
    self.token <- map["token"]
    self.sound <- map["sound"]
    self.mutable_content <- map["mutable_content"]
    self.priority <- map["priority"]
    self.index <- map["index"]
    self.notification <- map["notification"]
    self.count <- map["count"]
    self.click_action <- map["click_action"]
    self.message <- map["message"]
    self.data <- map["data"]
    
    self.data_array <- map["data_array"]
    self.member_list <- map["member_list"]
    self.schedule_item_member_list <- map["schedule_item_member_list"]
    self.schedule_member_list <- map["schedule_member_list"]
    self.plan_item_list <- map["plan_item_list"]
  }
}
