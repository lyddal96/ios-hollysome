//
//  WebViewController.swift
//  hollysome
//
//  Created by rocateer on 19/09/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//
import UIKit
import WebKit
import Defaults


@objc protocol WebResultDelegate {
  @objc optional func resultAddress(zonecode: String, address: String, lat: String, lng: String)
  
}

enum WebType {
  case terms0
  case terms1
  case terms2
  case terms3
  case auth
  case address
  case payment
  
  var detail: (title: String, url: String) {
    switch self {
    case .terms0:
      return ("이용약관", "terms_web_view_v_1_0_0/terms_detail?type=0")
    case .terms1:
      return ("개인정보처리방침", "terms_web_view_v_1_0_0/terms_detail?type=1")
    case .terms2:
      return ("위치기반 서비스", "terms_web_view_v_1_0_0/terms_detail?type=2")
    case .terms3:
      return ("마케팅 수신 동의", "terms_web_view_v_1_0_0/terms_detail?type=3")
    case .auth:
      return ("본인인증", "kmc_web_view/member_auth?member_idx=")
    case .address:
      return ("주소검색", "mobile/address/daum")
    case .payment:
      return ("결제", "payment/order_start?pg_gate=ksnet&order_number=")
    }
  }
}

class WebViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var webWrapView: UIView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var webType = WebType.terms0
  var webView: WKWebView?
  var delegate: WebResultDelegate?
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.initWebView()
    self.navigationItem.title = self.webType.detail.title
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  // 웹뷰 세팅
  func initWebView() {
    let configuration = WKWebViewConfiguration()
    configuration.userContentController.add(self, name: "resultAddress")
    
    
    self.webView = WKWebView(frame: self.webWrapView.bounds, configuration: configuration)
    self.webView?.scrollView.isScrollEnabled = true
    
    self.webView?.uiDelegate = self
    self.webView?.navigationDelegate = self
    
    let url = URL(string: "\(baseURL)\(self.webType.detail.url)")!
    
    if UIApplication.shared.canOpenURL(url) {
      let request = URLRequest(url: url)
      self.webView?.load(request)
      
    } else {
      let defaultURL = URL(string: "https://m.naver.com")!
      let request = URLRequest(url: defaultURL)
      self.webView?.load(request)
    }
    
    
    let urlRequest = URLRequest(url: url)
    self.webView?.load(urlRequest)
    self.webWrapView.addSubview(self.webView!)
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


//-------------------------------------------------------------------------------------------
// MARK: - WKScriptMessageHandler
//-------------------------------------------------------------------------------------------
extension WebViewController: WKScriptMessageHandler {
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    log.debug(message.name)
    if (message.name == "resultAddress") {
      let values: [String: Any] = message.body as! Dictionary
      
      log.debug("zonecode : \(values["zonecode"] ?? "")")
      log.debug("address : \(values["address"] ?? "")")
      log.debug("lat : \(values["lat"] ?? "")")
      log.debug("lng : \(values["lng"] ?? "")")
      
      let zonecode = values["zonecode"] as? String ?? ""
      let address = values["address"] as? String ?? ""
      let lat = values["lat"] as? String ?? ""
      let lng = values["lng"] as? String ?? ""

      self.delegate?.resultAddress?(zonecode: zonecode, address: address, lat: lat, lng: lng)
      
      self.closeViewController()
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - WKNavigationDelegate
//-------------------------------------------------------------------------------------------
extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
    let reqUrl = navigationAction.request.url?.absoluteString ?? ""
    log.debug("reqUrl : \(String(describing: reqUrl))")
    
    let device = UIDevice.current
    let backgroundSupported = device.isMultitaskingSupported
    if !backgroundSupported {
      
      let alertController = UIAlertController(title: "안내", message: "멀티테스킹을 지원하는 기기 또는 어플만 공인인증서비스가 가능합니다.", preferredStyle: .actionSheet)
      alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
      }))
    }
    
    
    if reqUrl.contains("apps.apple.com") || reqUrl.contains("it/ms-appss")
        || reqUrl.contains("ispmobile") || reqUrl.contains("payco")
        || reqUrl.contains("kakaotalk") || reqUrl.contains("kb-acp")
        || reqUrl.contains("hdcardappcardansimclick") || reqUrl.contains("lotteappcard")
        || reqUrl.contains("cloudpay") || reqUrl.contains("hanawalletmembers")
        || reqUrl.contains("nhallonepayansimclick") || reqUrl.contains("citimobileapp")
        || reqUrl.contains("wooripay") || reqUrl.contains("shinhan-sr-ansimclick")
        || reqUrl.contains("mpocket.online.ansimclick") || reqUrl.contains("kftc-bankpay")
        || reqUrl.contains("lguthepay-xpay") || reqUrl.contains("SmartBank2WB")
        || reqUrl.contains("bankpay") || reqUrl.contains("com.wooricard.wcard") {
      UIApplication.shared.open(URL(string: reqUrl)!, options: [:], completionHandler: nil)
      decisionHandler(.cancel)
      return
    }

    if reqUrl.contains("shinsegaeeasypayment")
    || reqUrl.contains("lpayapp") {
      if reqUrl.contains("apps.apple.com") {
        UIApplication.shared.open(URL(string: reqUrl)!, options: [:], completionHandler: nil)
        decisionHandler(.cancel)
        return
      }
    }

    decisionHandler(.allow)
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - WKUIDelegate
//-------------------------------------------------------------------------------------------
extension WebViewController: WKUIDelegate {
  func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
      completionHandler()
    }))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
      completionHandler(true)
    }))
    alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
      completionHandler(false)
    }))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .actionSheet)
    alertController.addTextField { (textField) in
      textField.text = defaultText
    }
    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
      if let text = alertController.textFields?.first?.text {
        completionHandler(text)
      } else {
        completionHandler(defaultText)
      }
    }))
    alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
      completionHandler(nil)
    }))
    self.present(alertController, animated: true, completion: nil)
  }
  
}

