//
//  FaqCategoryViewController.swift
//  hollysome
//

import UIKit
import ExpyTableView
import DZNEmptyDataSet

class FaqCategoryViewController: BaseViewController{
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var faqTableView: ExpyTableView!
  @IBOutlet weak var categoryTextField: UITextField!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var faqRequest = FaqModel()
  var faqList = [FaqModel]()
  
  var pickerView = UIPickerView()
  var categoryList = [FaqModel]()
  var faq_category_idx = ""
  
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
    
    self.categoryTextField.addBorder(width: 1, color: UIColor(named: "757575")!)
    self.pickerView.delegate = self
    self.categoryTextField.inputView = pickerView
    self.categoryTextField.tintColor = UIColor.clear
    self.categoryTextField.addLeftTextPadding(15)
    
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
    self.categoryListAPI()
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 키테고리 리스트
  func categoryListAPI() {
    
//    APIRouter.shared.api(path: .faq_category_list, parameters: nil) { response in
//      if let faqResponse = FaqModel(JSON: response), Tools.shared.isSuccessResponse(response: faqResponse) {
//        self.isLoadingList = true
//        if let data_array = faqResponse.data_array {
//          self.categoryList += data_array
//          if self.categoryList.count > 0 {
//            self.faq_category_idx = self.categoryList[0].faq_category_idx ?? ""
//            self.categoryTextField.text = self.categoryList[0].faq_category_name ?? ""
//            self.faqListAPI()
//          }
//        }
//      }
//    } 
    
  }
  
  /// faq 리스트
  func faqListAPI() {
//    self.faqRequest.setNextPage()
//    self.faqRequest.faq_category_idx = self.faq_category_idx
//    
//    APIRouter.shared.api(path: .faq_list_1, parameters: self.faqRequest.toJSON()) { response in
//      if let faqResponse = FaqModel(JSON: response), Tools.shared.isSuccessResponse(response: faqResponse) {
//        self.isLoadingList = true
//        if let data_array = faqResponse.data_array {
//          self.faqRequest.setTotalPage(total_page: faqResponse.total_page ?? 0)
//          self.faqList += data_array
//          self.faqTableView.reloadData()
//        }
//      }
//    } 
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
}


extension FaqCategoryViewController: ExpyTableViewDataSource {
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
extension FaqCategoryViewController: ExpyTableViewDelegate {
  
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
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.faqTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.faqRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.faqListAPI()
        }
      }
    }
  }
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UIPickerViewDelegate
//-------------------------------------------------------------------------------------------
extension FaqCategoryViewController: UIPickerViewDelegate {
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UIPickerViewDataSource
//-------------------------------------------------------------------------------------------
extension FaqCategoryViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.categoryList.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.categoryList[row].faq_category_name ?? ""
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//    self.type = "\(row - 1)"
    self.faq_category_idx = self.categoryList[row].self.faq_category_idx ?? ""
    self.categoryTextField.text = self.categoryList[row].faq_category_name ?? ""
    self.faqRequest.resetPage()
    self.faqList.removeAll()
    self.faqListAPI()
    
  }
}
