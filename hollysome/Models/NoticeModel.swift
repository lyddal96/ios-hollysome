//
//  NoticeModel.swift
//  hollysome
//
//  Created by rocket on 10/06/2019.
//
//

import Foundation
import ObjectMapper

class NoticeModel: BaseModel {
  /// 공지사항 인덱스
  var notice_idx: String?
  /// 공지사항 제목
  var title: String?
  /// 공지사항 이미지
  var img_path: String?
  /// 이미지 가로 길이 (px)
  var img_width: Int?
  /// 이미지 세로 길이 (px)
  var img_height: Int?
  /// 공지사항 내용
  var contents: String?
  /// 공지사항 등록일
  var created_at: String?
  var img: String?
  /// 이미지 경로
  var path: String?
  /// 이미지 가로 길이
  var width: Int?
  /// 이미지 세로 길이
  var height: Int?
  /// 날짜
  var ins_date: String?
  
  /// 결과
  var result: NoticeModel?
  /// 공지사항 리스트
  var data_array: [NoticeModel]?
  var data: [NoticeModel]?
  /// 이미지 리스트
  var images: [ImageModel]?
  
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.notice_idx <- map["notice_idx"]
    self.title <- map["title"]
    self.img_path <- map["img_path"]
    self.img_width <- map["img_width"]
    self.img_height <- map["img_height"]
    self.contents <- map["contents"]
    self.created_at <- map["created_at"]
    self.img <- map["img"]
    self.path <- map["path"]
    self.width <- map["width"]
    self.height <- map["height"]
    self.ins_date <- map["ins_date"]
    
    self.result <- map["result"]
    self.data_array <- map["data_array"]
    self.data <- map["data"]
    self.images <- map["images"]
  }
}
