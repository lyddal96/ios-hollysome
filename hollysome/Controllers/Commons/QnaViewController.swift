//
//  QaViewController.swift
//  hollysome
//

import UIKit
import DZNEmptyDataSet

class QnaViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var qnaTableView: UITableView!
  @IBOutlet weak var registButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var qnaRequest = QnaModel()
  var qnaList = [QnaModel]()
  
  let notificationCenter = NotificationCenter.default
  let refresh = UIRefreshControl()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.qnaTableView.registerCell(type: QnaListCell.self)
    self.qnaTableView.tableFooterView = UIView(frame: CGRect.zero)
    self.qnaTableView.delegate = self
    self.qnaTableView.dataSource = self
    
    self.notificationCenter.addObserver(self, selector: #selector(self.qnaListUpdate), name: Notification.Name("QnaListUpdate"), object: nil)
    self.refresh.addTarget(self, action: #selector(self.qnaListUpdate), for: .valueChanged)
    self.qnaTableView.refreshControl = self.refresh
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.registButton.setCornerRadius(radius: 25)
    self.registButton.addShadow(cornerRadius: 25)
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.qnaListAPI()
  }

  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// QnA 리스트
  private func qnaListAPI() {
    self.qnaRequest.setNextPage()
//    self.qnaRequest.member_idx = "1"
    self.qnaRequest.per_page = 10
    
    APIRouter.shared.api(path: .qa, method: .get, parameters: self.qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        if let result = qnaResponse.result {
          self.isLoadingList = true
          self.qnaRequest.total_page = qnaResponse.total_page
          if let data = result.data, data.count > 0 {
            self.qnaList += data
          }
          
          self.qnaTableView.emptyDataSetSource = self
          self.qnaTableView.reloadData()
          self.refresh.endRefreshing()
        }
        
      }
    }
    
  }
  
  
  /// Qna 리스트 업데이트
  @objc func qnaListUpdate() {
    self.qnaList.removeAll()
    self.qnaRequest.resetPage()
    self.qnaListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// Qna 등록 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func registButtonTouched(sender: UIButton) {
    let destination = QnaRegistViewController.instantiate(storyboard: "Commons")
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension QnaViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.qnaList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QnaListCell", for: indexPath)
    self.qnaListCell(cell: cell, indexPath: indexPath)
    return cell
  }
  
  /// QNA 리스트
  ///
  /// - Parameters:
  ///   - cell: 테이블 뷰 셀
  ///   - indexPath: indexPath
  private func qnaListCell(cell: UITableViewCell, indexPath: IndexPath) {
    let cell = cell as! QnaListCell
    let qna = self.qnaList[indexPath.row]
    cell.qnaTitleLabel.text = qna.title ?? ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: qna.created_at ?? "") ?? Date()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    cell.qnaDateLabel.text = dateFormatter.string(from: date)
    
    if qna.reply_yn == 1 {
      cell.stateLabel.text = "답변완료"
      cell.stateLabel.textColor = UIColor(named: "4CAF50")
      cell.stateView.backgroundColor = UIColor(named: "E8F5E9")
    } else {
      cell.stateLabel.text = "미답변"
      cell.stateLabel.textColor = UIColor(named: "F44336")
      cell.stateView.backgroundColor = UIColor(named: "FFEBEE")
      
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension QnaViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destination = QnaDetailViewController.instantiate(storyboard: "Commons")
    destination.id = self.qnaList[indexPath.row].id
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.qnaTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.qnaRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.qnaListAPI()
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension QnaViewController: DZNEmptyDataSetSource {
//  func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//    return -100
//  }
  
  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -100
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "1:1 문의가 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor : UIColor(named: "666666")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

