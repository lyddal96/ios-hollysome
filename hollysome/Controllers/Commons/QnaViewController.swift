//
//  QaViewController.swift
//  hollysome
//

import UIKit
import DZNEmptyDataSet
import Defaults

class QnaViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var qnaTableView: UITableView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var qnaRequest = QnaModel()
  var qnaList = [QnaModel]()
  
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
    self.qnaRequest.member_idx = Defaults[.member_idx]
    self.qnaRequest.per_page = 10
    
    APIRouter.shared.api(path: .qa, method: .get, parameters: self.qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        self.isLoadingList = true
        self.qnaRequest.total_page = qnaResponse.total_page
        if let data = qnaResponse.data_array, data.count > 0 {
          self.qnaList += data
        }
        
        self.qnaTableView.emptyDataSetSource = self
        self.qnaTableView.reloadData()
        self.refresh.endRefreshing()
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
  /// - Parameter sender: 바버튼
  @IBAction func registBarButtonItemTouched(sender: UIBarButtonItem) {
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
    cell.qnaTitleLabel.text = qna.qa_title ?? ""
    cell.qnaDateLabel.text = qna.ins_date ?? ""
    cell.categoryLabel.text = Constants.qna_category(item: qna.qa_type ?? "")
    
    if qna.reply_yn == "Y" {
      cell.stateLabel.text = "답변완료"
      cell.stateLabel.textColor = UIColor(named: "accent")
    } else {
      cell.stateLabel.text = "미답변"
      cell.stateLabel.textColor = UIColor(named: "A3A7B6")
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension QnaViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destination = QnaDetailViewController.instantiate(storyboard: "Commons")
    destination.qa_idx = self.qnaList[indexPath.row].qa_idx ?? ""
    self.navigationController?.pushViewController(destination, animated: true)
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
    return -250
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "궁금하신 내용이\n자주묻는질문(FAQ)으로는\n해결이 어려우신가요?\n\n1:1 문의 글을 작성하시면\n확인 후에 답변을 드립니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor : UIColor(named: "C8CCD5")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

