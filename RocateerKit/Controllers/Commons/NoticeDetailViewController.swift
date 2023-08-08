//
//  NoticeDetailViewController.swift
//  RocateerKit
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
  @IBOutlet weak var imageTableView: UITableView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var noticeResponse = NoticeModel()
  var notice_idx = ""
  var id: Int? = nil
  
  var imageList = [ImageModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.imageTableView.registerCell(type: ImageTableCell.self)
    self.imageTableView.delegate = self
    self.imageTableView.dataSource = self
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
    noticeRequest.id = self.id
    
    APIRouter.shared.api(path: .notice_detail, method: .get, parameters: noticeRequest.toJSON()) { response in
      if let noticeResponse = NoticeModel(JSON: response), Tools.shared.isSuccessResponse(response: noticeResponse) {
        if let result = noticeResponse.result {
          self.titleLabel.text = result.title ?? ""
          if var header = self.imageTableView.tableHeaderView {
            header.frame.size.height = self.titleLabel.frame.size.height + 55
            self.imageTableView.tableHeaderView = header
          }
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let date = dateFormatter.date(from: result.created_at ?? "") ?? Date()
          dateFormatter.dateFormat = "yyyy.MM.dd"
          self.dateLabel.text = dateFormatter.string(from: date)
          if let images = result.images, images.count > 0 {
            self.imageList = images
          }
          
          self.imageTableView.reloadData()
          self.noticeResponse = result
        }
      }
    }
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension NoticeDetailViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.imageList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableCell", for: indexPath) as! ImageTableCell
    let image = self.imageList[indexPath.row]
    cell.cellImageView.sd_setImage(with: URL(string: Tools.shared.imageUrl(path: image.path ?? "")))
    /// 저장된 이미지 width, height 계산
    cell.imageHeight.constant = ((image.height ?? 0).toCGFloat * (self.view.frame.size.width - 40)) / (image.width ?? 0).toCGFloat
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let contentLabel = UILabel(x: 20, y: 20, w: self.view.frame.size.width - 40, h: 0)
    contentLabel.font = UIFont.systemFont(ofSize: 16)
    contentLabel.numberOfLines = 0
    contentLabel.text = self.noticeResponse.content ?? ""
    contentLabel.sizeToFit()
    let headerView = UIView(x: 0, y: 0, w: self.view.frame.size.width, h: contentLabel.frame.size.height + 50)
    headerView.addSubview(contentLabel)
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    let contentLabel = UILabel(x: 20, y: 20, w: self.view.frame.size.width - 40, h: 0)
    contentLabel.font = UIFont.systemFont(ofSize: 16)
    contentLabel.numberOfLines = 0
    contentLabel.text = self.noticeResponse.content ?? ""
    contentLabel.sizeToFit()
    
    return contentLabel.frame.size.height + 50
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension NoticeDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
