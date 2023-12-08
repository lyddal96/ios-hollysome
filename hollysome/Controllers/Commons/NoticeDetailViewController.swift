//
//  NoticeDetailViewController.swift
//  hollysome
//
//  Created by rocateer on 28/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import UIKit

class NoticeDetailViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var imageHeight: NSLayoutConstraint!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var noticeResponse = NoticeModel()
  var notice_idx = ""
  
  var image = ""
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
    self.noticeDetailAPI()
  }

  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 공지사항 상세
  private func noticeDetailAPI() {
    let noticeRequest = NoticeModel()
    noticeRequest.notice_idx = self.notice_idx
    
    APIRouter.shared.api(path: .notice_detail, method: .get, parameters: noticeRequest.toJSON()) { response in
      if let noticeResponse = NoticeModel(JSON: response), Tools.shared.isSuccessResponse(response: noticeResponse) {
        self.titleLabel.text = noticeResponse.title ?? ""
        self.dateLabel.text = noticeResponse.ins_date ?? ""
        /// 저장된 이미지 width, height 계산
        if let img_path = noticeResponse.img_path {
          let image:UIImage = UIImage(urlString: "\(baseURL)\(img_path)") ?? UIImage()
          self.imageView.sd_setImage(with: URL(string: "\(baseURL)\(img_path)"), completed: nil)
          self.imageHeight.constant = (image.size.height * (self.view.frame.size.width - 32)) / image.size.width
          self.imageView.isHidden = false
        } else {
          self.imageView.isHidden = true
        }
        self.contentLabel.text = noticeResponse.contents ?? ""
        self.noticeResponse = noticeResponse
      }
    }
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
