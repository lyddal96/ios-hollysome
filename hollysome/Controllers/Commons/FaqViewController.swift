//
//  FaqViewController.swift
//  hollysome
//
//  Created by rocateer on 28/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//
import UIKit
import ExpyTableView
import DZNEmptyDataSet

class FaqViewController: RocateerViewController{
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var faqTableView: ExpyTableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var faqRequest = FaqModel()
  var faqList = [FaqModel]()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.faqTableView.registerCell(type: FaqCell.self)
    self.faqTableView.registerCell(type: FaqDetailCell.self)
    self.faqTableView.tableFooterView = UIView(frame: CGRect.zero)
    
    
    
    self.faqTableView.dataSource = self
    self.faqTableView.delegate = self
    self.faqTableView.rowHeight = UITableView.automaticDimension
    self.faqTableView.estimatedRowHeight = 80
    self.faqTableView.expandingAnimation = .fade
    self.faqTableView.collapsingAnimation = .fade
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.faqListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// faq 리스트
  func faqListAPI() {
    self.faqRequest.setNextPage()
    self.faqRequest.target = 0
    self.faqRequest.per_page = 10
    
    APIRouter.shared.api(path: .faq, method: .get, parameters: self.faqRequest.toJSON()) { response in
      if let faqResponse = FaqModel(JSON: response), Tools.shared.isSuccessResponse(response: faqResponse) {
        if let result = faqResponse.result {
          self.isLoadingList = true
          self.faqRequest.setTotalPage(total_page: faqResponse.total_page ?? 0)
          if let data = result.data, data.count > 0 {
            self.faqList += data
          }
          self.faqTableView.reloadData()
        }
        
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
}


extension FaqViewController: ExpyTableViewDataSource {
  func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
    return true
  }
  
  func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FaqCell") as! FaqCell
    let faqData = self.faqList[section]
    cell.titleLabel.text = faqData.title ?? ""
    
    cell.layoutMargins = UIEdgeInsets.zero
    return cell
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.faqList.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  
  
  func canExpand(section: Int, inTableView tableView: ExpyTableView) -> Bool {
    return true
  }
  
  // 상위 데이터
  func expandableCell(forSection section: Int, inTableView tableView: ExpyTableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FaqCell") as! FaqCell
    return cell
  }
  
  // 하위 데이터
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FaqDetailCell", for: indexPath) as! FaqDetailCell
    let faqData = self.faqList[indexPath.section]
    cell.faqDetailLabel.text = faqData.content ?? ""
    return cell
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDelegate
//-------------------------------------------------------------------------------------------
extension FaqViewController: ExpyTableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
    
    switch state {
    case .willExpand:
      
      break
    case .willCollapse:
      break
    case .didExpand:
      break
    case .didCollapse:
      break
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView == self.faqTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.faqRequest.isMore() {
          self.isLoadingList = false
          self.faqListAPI()
        }
      }
    }
  }
  
}
