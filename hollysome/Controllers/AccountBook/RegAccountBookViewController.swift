//
//  RegAccountBookViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/20/23.
//

import UIKit
import Defaults

class RegAccountBookViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var gasTextField: UITextField!
  @IBOutlet weak var waterTextField: UITextField!
  @IBOutlet weak var elecTextField: UITextField!
  @IBOutlet weak var etcTableView: UITableView!
  @IBOutlet weak var finishButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var modifyButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var enrollType = EnrollType.enroll
  var bookData = AccountBookModel()
  var item_array = [AccountBookModel(), AccountBookModel(), AccountBookModel()]
  var etcList = ["넷플릭스", "관리비", "통신비"]
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.etcTableView.registerCell(type: RegEtcBookCell.self)
    self.etcTableView.delegate = self
    self.etcTableView.dataSource = self
    self.etcTableView.showsVerticalScrollIndicator = false
    self.gasTextField.delegate = self
    self.waterTextField.delegate = self
    self.elecTextField.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.gasTextField.setCornerRadius(radius: 4)
    self.gasTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.gasTextField.setTextPadding(15)
    self.waterTextField.setCornerRadius(radius: 4)
    self.waterTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.waterTextField.setTextPadding(15)
    self.elecTextField.setCornerRadius(radius: 4)
    self.elecTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.elecTextField.setTextPadding(15)
    self.finishButton.setCornerRadius(radius: 12)
    self.cancelButton.setCornerRadius(radius: 12)
    self.modifyButton.setCornerRadius(radius: 12)
    self.modifyButton.addBorder(width: 1, color: UIColor(named: "accent")!)
    
    self.finishButton.isHidden = self.enrollType == .modify
    self.modifyButton.isHidden = self.enrollType == .enroll
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY년 MM월"
    self.navigationItem.title = dateFormatter.string(from: Date())
    
    if self.bookData.book_idx != nil {
      self.gasTextField.text = self.bookData.book_item_1
      self.gasTextField.addBorder(width: 1, color: UIColor(named: (self.gasTextField.text?.toInt() ?? 0) > 0 ? "87B7FF" : "C8CCD5")!)
      self.waterTextField.text = self.bookData.book_item_2
      self.waterTextField.addBorder(width: 1, color: UIColor(named: self.waterTextField.text?.toInt() ?? 0 > 0 ? "87B7FF" : "C8CCD5")!)
      self.elecTextField.text = self.bookData.book_item_3
      self.elecTextField.addBorder(width: 1, color: UIColor(named: self.elecTextField.text?.toInt() ?? 0 > 0 ? "87B7FF" : "C8CCD5")!)
      if let detail_list = self.bookData.detail_list, detail_list.count > 0 {
        for value in detail_list {
          self.item_array[value.item_no?.toInt() ?? 0] = value
        }
      }
      self.etcTableView.reloadData()
    }
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 가계부 등록 API
  func bookRegInAPI() {
    let bookRequest = AccountBookModel()
    bookRequest.house_code = Defaults[.house_code]
    bookRequest.book_item_1 = "\(self.gasTextField.text?.toInt() ?? 0)"
    bookRequest.book_item_2 = "\(self.waterTextField.text?.toInt() ?? 0)"
    bookRequest.book_item_3 = "\(self.elecTextField.text?.toInt() ?? 0)"
    var item_array = [AccountBookModel]()
    for value in self.item_array {
      if value.item_name?.count ?? 0 > 0 && value.item_bill?.toInt() ?? 0 > 0 {
        item_array.append(value)
      }
    }
    bookRequest.item_array = item_array.toJSONString() ?? ""
    log.debug(item_array.toJSONString() ?? "")
    bookRequest.book_idx = self.bookData.book_idx
    
    let path = self.enrollType == .enroll ? APIURL.book_reg_in : .book_mod_up

    APIRouter.shared.api(path: path, method: .post, parameters: bookRequest.toJSON()) { response in
      if let bookResponse = AccountBookModel(JSON: response), Tools.shared.isSuccessResponse(response: bookResponse, alertYn: true) {
        self.notificationCenter.post(name: Notification.Name("BookUpdate"), object: nil)
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 작성완료
  /// - Parameter sender: 버튼
  @IBAction func finishButtonTouched(sender: UIButton) {
    AJAlertController.initialization().showAlert(astrTitle: "가계부를 작성하시겠어요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "작성하기") { position, title in
      if position == 1 {
        self.bookRegInAPI()
      }
    }
  }
  
  /// 취소하기
  /// - Parameter sender: 버튼
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  /// 수정
  /// - Parameter sender: 버튼
  @IBAction func modifyButtonTouched(sender: UIButton) {
    AJAlertController.initialization().showAlert(astrTitle: "가계부를 수정하시겠어요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "작성하기") { position, title in
      if position == 1 {
        self.bookRegInAPI()
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITextFieldDelegate
//-------------------------------------------------------------------------------------------
extension RegAccountBookViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if (textField.text?.toInt() ?? 0 > 0) {
      textField.addBorder(width: 1, color: UIColor(named: "87B7FF")!)
    } else {
      textField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    }
    return true
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension RegAccountBookViewController: UITableViewDelegate {
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension RegAccountBookViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RegEtcBookCell", for: indexPath) as! RegEtcBookCell
//    cell.namaTitleLabel.text = "항목 \(indexPath.row + 1)"
    cell.namaTitleLabel.text = "항목명"
    cell.parentsViewController = self
    cell.indexPath = indexPath
    
    cell.nameTextField.text = self.item_array[indexPath.row].item_name ?? ""
    cell.priceTextField.text = self.item_array[indexPath.row].item_bill ?? ""
    cell.nameTextField.placeholder = self.etcList[indexPath.row]
    
    if self.enrollType == .modify {
      cell.nameTextField.addBorder(width: 1, color: UIColor(named: self.item_array[indexPath.row].item_name?.count ?? 0 > 0 ? "87B7FF" :"C8CCD5")!)
      cell.priceTextField.addBorder(width: 1, color: UIColor(named: self.item_array[indexPath.row].item_bill?.toInt() ?? 0 > 0 ? "87B7FF" :"C8CCD5")!)
    }
    
    return cell
  }
  
  
}
