//
//  LocalStore.swift
//

import UIKit
import Defaults

extension Defaults.Keys {
  static let access_token = Key<String?>("access_token")
  static let name = Key<String?>("name")
  static let member_idx = Key<String?>("member_idx")
  static let password = Key<String?>("password")
  static let member_join_type = Key<String?>("member_join_type")
  static let member_id = Key<String?>("member_id")
  static let member_pw = Key<String?>("member_pw")
  static let bannerDay = Key<Date?>("bannerDay")
  static let tutorial = Key<Bool?>("tutorial") // false 면 tutorial열고, true면 열지 않음
}
