//
//  Constants.swift
//  hollysome
//
//  Created by 이승아 on 12/13/23.
//

struct Constants {
  static var QNA_CATEGORY_LIST: [String] {
    ["불편 신고", "제안", "기타"]
  }
  
  /// 커뮤니티 스케줄 카테고리
    /// - Parameter item: 인덱스
    /// - Returns: text
    static func qna_category(item: String) -> String {
      // 0:전체, 1:방송, 2:발매, 3:축하, 4:행사, 7:기타
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
