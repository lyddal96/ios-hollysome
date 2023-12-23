//
//  HouseModel.swift
//  hollysome
//
//  Created by 이승아 on 12/5/23.

import Foundation
import ObjectMapper

class HouseModel: BaseModel {
  /// 하우스 이미지
  var house_img: String?
  /// 알림장 키
  var note_idx: String?
  /// 내용
  var contents: String?
  /// 작성일시
  var ins_date: String?
  /// 차단 여부
  var block_yn: String?
  /// 신고 여부
  var report_yn: String?
  /// 신고 내용
  var report_contents: String?
  /// 0영리목적홍보성 1음란성,선정성 2욕설,인신공격 3같은내용반복게시(도배) 4기타
  var report_type: String?

  /// 리스트
  var data_array: [HouseModel]?
  override func mapping(map: Map) {
    super.mapping(map: map)
    
    self.house_img <- map["house_img"]
    self.note_idx <- map["note_idx"]
    self.contents <- map["contents"]
    self.ins_date <- map["ins_date"]
    self.block_yn <- map["block_yn"]
    self.report_yn <- map["report_yn"]
    self.report_contents <- map["report_contents"]
    self.report_type <- map["report_type"]

    self.data_array <- map["data_array"]
  }
}
