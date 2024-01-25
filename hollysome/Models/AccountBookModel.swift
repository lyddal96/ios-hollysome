//
//  AccountBookModel.swift
//  hollysome
//
//  Created by 이승아 on 12/21/23.
//

import Foundation
import ObjectMapper

class AccountBookModel: BaseModel {
  /// 가계부 키
  var book_idx: String?
  /// 가스비
  var book_item_1: String?
  /// 수도세
  var book_item_2: String?
  /// 전기세
  var book_item_3: String?
  /// 항목 키
  var item_idx: String?
  /// 항목 순서
  var item_no: String?
  /// 항목 명
  var item_name: String?
  /// 항목 금액
  var item_bill: String?
  var item_price: String?
  /// 월
  var month: String?
  /// 그외항목 리스트
  var item_array: String?
  /// 회원키
  var member_arr: String?
  /// 총 메이트 수
  var mate_cnt: String?
  
  
  /// 리스트
  var data_array: [AccountBookModel]?
  /// 항목 리스트
  var item_list: [AccountBookModel]?
  /// 그외리스트
  var detail_list: [AccountBookModel]?
  override func mapping(map: Map) {
    super.mapping(map: map)
    
    self.book_idx <- map["book_idx"]
    self.book_item_1 <- map["book_item_1"]
    self.book_item_2 <- map["book_item_2"]
    self.book_item_3 <- map["book_item_3"]
    self.item_idx <- map["item_idx"]
    self.item_no <- map["item_no"]
    self.item_name <- map["item_name"]
    self.item_bill <- map["item_bill"]
    self.item_price <- map["item_price"]
    self.month <- map["month"]
    self.item_array <- map["item_array"]
    self.member_arr <- map["member_arr"]
    self.mate_cnt <- map["mate_cnt"]
    
    
    self.data_array <- map["data_array"]
    self.item_list <- map["item_list"]
    self.detail_list <- map["detail_list"]
    
  }
}
