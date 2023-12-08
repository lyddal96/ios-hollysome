//
//  NoticeViewController.swift
//  hollysome
//
//  Created by rocket on 11/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class NoticeViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var noticeTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var noticeRequest = NoticeModel()
  var noticeList = [NoticeModel]()
  
  let refresh = UIRefreshControl()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.noticeTableView.registerCell(type: NoticeListCell.self)
    self.noticeTableView.tableFooterView = UIView(frame: CGRect.zero)
    self.noticeTableView.delegate = self
    self.noticeTableView.dataSource = self
    self.refresh.addTarget(self, action: #selector(self.noticeListRefresh), for: .valueChanged)
    self.noticeTableView.refreshControl = self.refresh
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.noticeListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 공지사항 리스트
  private func noticeListAPI() {
    self.noticeRequest.setNextPage()
    APIRouter.shared.api(path: .notice_list, method: .get, parameters: self.noticeRequest.toJSON()) { response in
      if let noticeResponse = NoticeModel(JSON: response), Tools.shared.isSuccessResponse(response: noticeResponse) {
        self.isLoadingList = true
        self.noticeRequest.total_page = noticeResponse.total_page
        if let data = noticeResponse.data_array, data.count > 0 {
          self.noticeList += data
        }
        self.noticeTableView.emptyDataSetSource = self
        self.noticeTableView.reloadData()
        self.refresh.endRefreshing()
      }
    }

  }
  
  /// 공지사항 새로고침
  @objc func noticeListRefresh() {
    self.noticeList.removeAll()
    self.noticeRequest.resetPage()
    self.noticeListAPI()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension NoticeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.noticeList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListCell", for: indexPath)
    self.noticeListCell(cell: cell, indexPath: indexPath)
    return cell
  }
  
  /// 공지사항 리스트
  ///
  /// - Parameters:
  ///   - cell: 테이블 뷰 셀
  ///   - indexPath: indexPath
  private func noticeListCell(cell: UITableViewCell, indexPath: IndexPath) {
    let cell = cell as! NoticeListCell
    let notice = self.noticeList[indexPath.row]
    cell.noticeTitleLabel.text = notice.title ?? ""
    cell.noticeDateLabel.text = notice.ins_date
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension NoticeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destination = NoticeDetailViewController.instantiate(storyboard: "Commons")
    destination.notice_idx = self.noticeList[indexPath.row].notice_idx ?? ""
    self.navigationController?.pushViewController(destination, animated: true)
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.noticeTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.noticeRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.noticeListAPI()
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension NoticeViewController: DZNEmptyDataSetSource {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "새로운 공지사항이 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor : UIColor(named: "C8CCD5")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

