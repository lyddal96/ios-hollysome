//
//  EventViewController.swift
//  RocateerKit
//
//  Created by rocateer on 2020/01/17.
//  Copyright © 2020 rocateer. All rights reserved.
//


import UIKit
import DZNEmptyDataSet

class EventViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var eventTableView: UITableView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var eventRequest = EventModel()
  var eventList = [EventModel]()
  
  
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
    self.eventTableView.registerCell(type: EventCell.self)
    self.eventTableView.tableFooterView = UIView(frame: CGRect.zero)
    self.eventTableView.delegate = self
    self.eventTableView.dataSource = self
  }
  
  override func initRequest() {
    super.initRequest()
//    self.eventListAPI()
  }

  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 이벤트 리스트
  private func eventListAPI() {
//    self.eventRequest.setNextPage()
//    self.eventRequest.member_idx = "1"
//    
//    APIRouter.shared.api(path: .event_list, parameters: self.eventRequest.toJSON()) { response in
//      if let eventResponse = EventModel(JSON: response), Tools.shared.isSuccessResponse(response: eventResponse) {
//        self.isLoadingList = true
//        if let data_array = eventResponse.data_array {
//          self.eventRequest.setTotalPage(total_page: eventResponse.total_page ?? 0)
//          self.eventList += data_array
//          self.eventTableView.reloadData()
//        } else {
//          self.eventTableView.emptyDataSetSource = self
//        }
//      }
//    } 
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------

}


//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension EventViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10 //self.eventList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
    self.eventListCell(cell: cell, indexPath: indexPath)
    return cell
  }
  
  /// 이벤트 리스트
  ///
  /// - Parameters:
  ///   - cell: 테이블 뷰 셀
  ///   - indexPath: indexPath
  private func eventListCell(cell: UITableViewCell, indexPath: IndexPath) {
    let cell = cell as! EventCell
//    let event = self.eventList[indexPath.row]
//    cell.qnaTitleLabel.text = qna.qa_title ?? ""
//
//    let date = Date(fromString: qna.ins_date ?? "", format: "yyyy-MM-dd") ?? Date()
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy.MM.dd"
//    cell.qnaDateLabel.text = dateFormatter.string(from: date)
    if indexPath.row % 2 == 0 {
      cell.stateLabel.text = "진행중"
      cell.stateLabel.textColor = .black
    } else {
      cell.stateLabel.text = "마감"
      cell.stateLabel.textColor = UIColor(named: "999999")
    }
  
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension EventViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destination = EventDetailViewController.instantiate(storyboard: "Commons")
//    destination.event_idx = self.eventList[indexPath.row].event_idx ?? ""
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.eventTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.eventRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.eventListAPI()
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension EventViewController: DZNEmptyDataSetSource {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "이벤트가 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor : UIColor(named: "666666")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

