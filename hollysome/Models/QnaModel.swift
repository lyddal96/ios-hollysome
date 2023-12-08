//
//  QnaModel.swift
//  hollysome
//
//  Created by rocket on 10/06/2019.
//
//

import Foundation
import ObjectMapper

class QnaModel: BaseModel {
  /// QNA 인덱스
  var qa_idx: String?
  /// QNA 질문 제목
  var title: String?
  /// QNA 질문 내용
  var content: String?
  /// QNA 답변 유무: (1: 답변 있음, 0: 답변 없음)
  var reply_yn: Int?
  /// QNA 답변 내용
  var reply_content: String?
  /// QNA 답변일
  var reply_date: String?
  /// QNA 등록일
  var ins_date: String?
  /// 1:1 문의 카테고리 (0:신고, 1:건의, 2:기타)
  var category: Int?
  /// 등록일
  var created_at: String?
  
  /// QNA 리스트
  var data_array: [QnaModel]?
  var data: [QnaModel]?
  /// 결과
  var result: QnaModel?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.qa_idx <- map["qa_idx"]
    self.title <- map["title"]
    self.content <- map["content"]
    self.reply_yn <- map["reply_yn"]
    self.reply_content <- map["reply_content"]
    self.reply_date <- map["reply_date"]
    self.ins_date <- map["ins_date"]
    self.category <- map["category"]
    self.created_at <- map["created_at"]
    
    self.data_array <- map["data_array"]
    self.data <- map["data"]
    self.result <- map["result"]
  }
}
