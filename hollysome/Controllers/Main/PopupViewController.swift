//
//  PopupViewController.swift
//  hollysome
//
//  Created by rocateer on 19/09/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//
import UIKit
import Defaults

class PopupViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var popupHeight: NSLayoutConstraint!
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  
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
  }
  
  override func initRequest() {
    super.initRequest()
    self.startPopupDetail()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  ///시작 팝업
  func startPopupDetail() {
//    let eventRequest = EventModel()
//    
//    APIRouter.shared.api(path: .start_popup_detail, parameters: eventRequest.toJSON()) { response in
//      if let eventResponse = EventModel(JSON: response), Tools.shared.isSuccessResponse(response: eventResponse) {
//        self.bannerImageView.sd_setImage(with: URL(string: eventResponse.img_url ?? ""), completed: nil)
//        
//        let height = 320 / CGFloat(eventResponse.img_width ?? 0) * CGFloat(eventResponse.img_height ?? 0)
//        self.popupHeight.constant = height + 46
//        
//        
//        self.bannerImageView.addTapGesture(action: { (recognizer) in
//          if let url = URL(string: eventResponse.link_url ?? "https://naver.com")  {
//            if #available(iOS 10.0, *) {
//              UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//              UIApplication.shared.openURL(url)
//            }
//          }
//        })
//      }
//    } 

  }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 오늘 하루 안보기
  ///
  /// - Parameter sender: 버튼
  @IBAction func oneDayCloseButtonTouched(sender: UIButton) {
    Defaults[.bannerDay] = Date()
    self.dismiss(animated: false, completion: nil)
  }
  
  /// 닫기
  ///
  /// - Parameter sender: 버튼
  @IBAction func popUpCloseButtonTouched(sender: UIButton) {
    Defaults[.bannerDay] = nil
    self.dismiss(animated: false, completion: nil)
  }
  
}
