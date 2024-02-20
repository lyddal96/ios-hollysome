//
//  AlarmViewController.swift
//  hollysome
//

import UIKit
import Defaults
import DZNEmptyDataSet

class AlarmViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var alarmTableView: UITableView!
  @IBOutlet weak var deleteAllBarButtonItem: UIBarButtonItem!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var alarmRequest = AlarmModel()
  var alarmList = [AlarmModel]()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.alarmTableView.delegate = self
    self.alarmTableView.dataSource = self
    self.alarmTableView.tableFooterView = UIView(frame: CGRect.zero)
    self.alarmTableView.registerCell(type: AlarmCell.self)
    self.alarmTableView.emptyDataSetSource = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
    self.alarmListAPI()
  }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 알림 리스트
  func alarmListAPI() {
    self.alarmRequest.setNextPage()
    self.alarmRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .alarm_list, parameters: self.alarmRequest.toJSON()) { response in
      if let alarmResponse = AlarmModel(JSON: response), Tools.shared.isSuccessResponse(response: alarmResponse) {
        if let data_array = alarmResponse.data_array {
          self.isLoadingList = true
          self.alarmRequest.setTotalPage(total_page: alarmResponse.total_page ?? 0)
          self.alarmList += data_array
          self.alarmTableView.reloadData()
        }
      }
    } 
  }
  
  func alarmMove(alarm: AlarmModel) {
    switch alarm.data?.index {
    case "101", "201":
      NotificationCenter.default.post(name: Notification.Name("GoToHome"), object: nil)
      self.dismiss(animated: true)
      break
    case "102":
      let destination = HouseNoticeViewController.instantiate(storyboard: "Home")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
      break
    case "103", "104":
      NotificationCenter.default.post(name: Notification.Name("GoToTodo"), object: nil)
      self.dismiss(animated: true)
      break
    case "105":
      NotificationCenter.default.post(name: Notification.Name("GoToBook"), object: nil)
      self.dismiss(animated: true)
      break
    default:
      break
    }
  }
  
  
  /// 알림 삭제
  /// - Parameter alarm_idx: 알림 인덱스
  func alarmDel(alarm_idx: String) {
    let alarmRequest = AlarmModel()
    alarmRequest.alarm_idx = alarm_idx

    APIRouter.shared.api(path: .alarm_del, parameters: alarmRequest.toJSON()) { response in
      if let alarmResponse = AlarmModel(JSON: response), Tools.shared.isSuccessResponse(response: alarmResponse) {
        self.alarmRequest.resetPage()
        self.alarmList.removeAll()
        self.alarmListAPI()
      }
    } 
  }
  
  /// 알림 전체 삭제
  func alarmAllDelAPI() {
    let alarmParam = AlarmModel()
    alarmParam.member_idx = Defaults[.member_idx]

    APIRouter.shared.api(path: .alarm_all_del, parameters: alarmParam.toJSON()) { response in
      if let alarmResponse = AlarmModel(JSON: response), Tools.shared.isSuccessResponse(response: alarmResponse) {
        self.alarmRequest.resetPage()
        self.alarmList.removeAll()
        self.alarmListAPI()
      }
    } 
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 전체삭제
  /// - Parameter sender: 바 버튼
  @IBAction func allDeleteBarButtonTouched(sender: UIBarButtonItem) {
    self.alarmAllDelAPI()
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension AlarmViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let alarmData = self.alarmList[indexPath.row]
    self.alarmMove(alarm: alarmData)
    
  }
  
  
//  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//    let contextItem = UIContextualAction(style: .normal, title: "") {  (contextualAction, view, boolValue) in
//      self.alarmDel(alarm_idx: self.alarmList[indexPath.row].alarm_idx ?? "")
//    }
////    contextItem.image = UIImage(named: "btn_delete")
//    contextItem.backgroundColor = UIColor(named: "DDDDDD")
//    
//    let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
//    
//    return swipeActions
//  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.alarmTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.alarmRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.alarmListAPI()
        }
      }
    }
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension AlarmViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.alarmList.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
    let alarmData = self.alarmList[indexPath.row]
    cell.contentsLabel.text = alarmData.msg ?? ""
    cell.dateLabel.text = alarmData.ins_date ?? ""
    
    /// 알림 삭제
    cell.deleteButton.addTapGesture { recognizer in
      self.alarmDel(alarm_idx: self.alarmList[indexPath.row].alarm_idx ?? "")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension AlarmViewController: DZNEmptyDataSetSource {
//  func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//    return -100
//  }
  
  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -250
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "새로운 알림이 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor : UIColor(named: "C8CCD5")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}


