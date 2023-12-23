//
//  Constants.swift
//  hollysome
//
//  Created by 이승아 on 12/13/23.
//

struct Constants {
  static var SHAPE_LIST: [String] {
    ["round", "clover", "heart", "square", "cloud", "star"]
  }
  static var QNA_CATEGORY_LIST: [String] {
    ["불편 신고", "제안", "기타"]
  }

  static var REPORT_TYPE: [String] {
    ["영리목적홍보성", "음란성,선정성", "욕설,인신공격", "같은내용반복게시(도배)", "기타"]
  }

  /// 신고 타입
    /// - Parameter item: 인덱스
    /// - Returns: text
    static func report_type(item: String) -> String {
      switch item {
//      0영리목적홍보성 1음란성,선정성 2욕설,인신공격 3같은내용반복게시(도배) 4기타
      case "0": return "영리목적홍보성"
      case "1": return "음란성,선정성"
      case "2": return "욕설,인신공격"
      case "3": return "같은내용반복게시(도배)"
      case "4": return "기타"
      default: return ""
      }
    }

  /// qna 타입
    /// - Parameter item: 인덱스
    /// - Returns: text
    static func qna_category(item: String) -> String {
      switch item {
      case "0": return "불편 신고"
      case "1": return "제안"
      case "2": return "기타"
      default: return ""
      }
    }
}

// 웹뷰 html
func webViewContents(contents: String) -> String {
  "<!DOCTYPE html><html>" +
  "<head>" +
  "<meta charset='UTF-8'><meta name='viewport' content='width=device-width,initial-scale=1.0, user-scalable=no'>" +
  "<style type='text/css'>" +
  "body {" +
  "margin: 0;" +
  "padding: 0;" +
  "}" +
  "img {" +
      "max-width: 100%;" +
      "width: 100%;" +
      "height: auto;" +
      "display: inline" +
  "}" +
  "p {"  +
    "max-width: 100%;" +
    "width: 100%;" +
    "word-wrap: break-word;" +
  "}" +
  "span {"  +
    "max-width: 100%;" +
    "width: 100%;" +
    "word-wrap: break-word;" +
  "}" +
  "</style>" +
  "</head>" +
  "<body>\(contents)</body></html>"
}
