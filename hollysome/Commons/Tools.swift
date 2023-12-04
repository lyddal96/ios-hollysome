//
//  Tools.swift
//  자주 사용하는 함수 모음
//
//  Created by rocket on 2021/05/11.
//  Copyright © 2021 rocateer. All rights reserved.
//

import Foundation
import NotificationBannerSwift
import UIKit

class Tools {
  static let shared = Tools()
  
  private init() {
  }
  
  
  /// API 성공 유무를 판단
  /// - Parameter response:
  /// - Returns: 성공 여부
  func isSuccessResponse(response: BaseModel) -> Bool {
    
    if response.code == "1000" {
      return true
    } else {
      if let errors = response.errors, errors.count > 0 {
        self.showToast(message: errors[0])
      } else {
        self.showToast(message: response.message ?? "")
      }
      return false
    }
  }
  
  /// 숫자 String 에 ",(콤마)" 표시 추가
  /// - Parameter value: 숫자 String
  /// - Returns: 결과 값
  func numberPlaceValue(_ value: String?) -> String {
    guard value != nil else { return "0" }
    let doubleValue = Double(value!) ?? 0.0
    let formatter = NumberFormatter()
    formatter.currencyCode = "KRW"
    formatter.currencySymbol = ""
    formatter.minimumFractionDigits = 0 //(value!.contains(".00")) ? 0 : 2
    formatter.maximumFractionDigits = 0
    formatter.numberStyle = .currencyAccounting
    return formatter.string(from: NSNumber(value: doubleValue)) ?? "\(doubleValue)"
  }
  
  
  /// 토스트 표시
  /// - Parameter message: 배너 내용
  func showToast(message: String) {
    let banner = FloatingNotificationBanner(title: message, subtitle: nil, titleFont: UIFont.systemFont(ofSize: 14), titleColor: .white, titleTextAlign: .left, subtitleFont: nil, subtitleColor: nil, subtitleTextAlign: nil, leftView: nil, rightView: nil, style: .info, colors: .none, iconPosition: .center)
    banner.backgroundColor = UIColor(named: "333333")!
    banner.duration = 2
    banner.animationDuration = 0.3
    banner.bannerHeight = 70

    banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: nil, edgeInsets: UIEdgeInsets(inset: 10), cornerRadius: 5, shadowColor: .black, shadowOpacity: 0.3, shadowBlurRadius: 5, shadowCornerRadius: 5, shadowOffset: UIOffset(horizontal: 0, vertical: 10), shadowEdgeInsets: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
  }
  
  /// 토스트 표시
  /// - Parameter message: 배너 내용
  func showToastWithImage(message: String, image: UIImage) {
    let imageView = UIImageView(x: 0, y: 0, w: 30, h: 30, image: image)
    imageView.setCornerRadius(radius: 12)
    let banner = FloatingNotificationBanner(title: message, subtitle: nil, titleFont: UIFont.systemFont(ofSize: 14), titleColor: UIColor(named: "282828")!, titleTextAlign: .left, subtitleFont: nil, subtitleColor: nil, subtitleTextAlign: nil, leftView: imageView, rightView: nil, style: .info, colors: .none, iconPosition: .center)
    banner.backgroundColor = UIColor(named: "F7F7F7")!
    banner.duration = 2
    banner.animationDuration = 0.3
    banner.bannerHeight = 70

    banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: nil, edgeInsets: UIEdgeInsets(inset: 10), cornerRadius: 20, shadowColor: .black, shadowOpacity: 0.2, shadowBlurRadius: 5, shadowCornerRadius: 3, shadowOffset: UIOffset(horizontal: 0, vertical: 10), shadowEdgeInsets: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
  }
  
  
  /// 전화 걸기
  /// - Parameter tel: 전화번호
  func openPhone(tel: String) {
    if let url = URL(string: "tel://\(tel)"), UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:], completionHandler:nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
  
  /// 외부 링크 열기
  /// - Parameter url: 링크
  func openBrowser(urlString: String) {
    if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  /// 공유하기
  /// - Parameter shareString: 링크
  func openShare(shareString: String, viewController: UIViewController) {
    let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: ["\(shareString)"], applicationActivities: nil)
    viewController.present(activityViewController, animated: true, completion: nil)
  }
  
  /// 클립보드에 복사
  /// - Parameter text: 복사할 문자
  func copyToClipboard(text: String) {
    UIPasteboard.general.string = text
  }
  
  
  /// 이미지 url
  /// - Parameter path: url
  /// - Returns: 이미지 url
  func imageUrl(path: String) -> String {
    return "\(baseURL)storage/image/\(path)"
  }

  
  /// 썸네일 url
  /// - Parameter url: url
  /// - Returns: 썸네일 url
  func thumbnailImageUrl(path: String) -> String {
    return "\(baseURL)storage/thumb/\(path)"
  }


}
