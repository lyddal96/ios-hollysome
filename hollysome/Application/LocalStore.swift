//
//  LocalStore.swift
//

import UIKit
import Defaults

extension Defaults.Keys {
  static let name = Key<String?>("name")
  static let member_idx = Key<String?>("member_idx")
  static let password = Key<String?>("password")
  static let member_join_type = Key<String?>("member_join_type")
  static let member_id = Key<String?>("member_id")
  static let member_pw = Key<String?>("member_pw")
  static let bannerDay = Key<Date?>("bannerDay")
  static let tutorial = Key<Bool?>("tutorial") // false 면 tutorial열고, true면 열지 않음
  static let house_code = Key<String?>("house_code") // 하우스 코드
  static let house_idx = Key<String?>("house_idx") // 하우스 키
  static let poke_cnt = Key<Int?>("poke_cnt")
  static let mate_poke_cnt = Key<Int?>("mate_poke_cnt")
  static let fcm_key = Key<String?>("fcm_key")
  static let access_token = Key<String?>("access_token")
  static let token_time = Key<Date?>("token_time")
  static let member_name = Key<String?>("member_name")
}
