//
//  QnaRegistViewController.swift
//  hollysome
//
//  Created by rocateer on 28/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//
import UIKit
import DropDown

class QnaRegistViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var categoryWrapView: UIView!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var enrollButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var qnaRequest = QnaModel()
  var categoryType: Int? = nil
  let dropDown = DropDown()
  
  let categoryList = ["신고", "건의", "기타"]
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
//    self.titleTextField.addLeftTextPadding(15)
//    self.titleTextField.addBorder(width: 1, color: UIColor(named: "DDDDDD")!)
//    self.contentsWrapView.addBorder(width: 1, color: UIColor(named: "DDDDDD")!)
    
    self.categoryWrapView.setCornerRadius(radius: 3)
    self.categoryWrapView.addBorder(width: 1, color: .darkGray)
    self.enrollButton.setCornerRadius(radius: 3)
    
    self.categoryTextField.isEnabled = false
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.customizeDropDown(self)
    self.categoryWrapView.addTapGesture { recognizer in
      self.dropDown.show()
    }
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// QnA 등록
  private func qaRegInAPI() {
//    self.qnaRequest.member_idx = "1"
    self.qnaRequest.title = self.titleTextField.text
    self.qnaRequest.content = self.contentTextView.text
    if let category = self.categoryType {
      self.qnaRequest.category = category
    }
    
  
    APIRouter.shared.api(path: .qa_create,method: .post , parameters: self.qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("QnaListUpdate"), object: nil)
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  /// 드롭다운 세팅
  /// - Parameter sender: self
  func customizeDropDown(_ sender: AnyObject) {
    
    self.dropDown.bottomOffset = CGPoint(x: 0, y: 42)
    self.dropDown.shadowOpacity = 0.5
    self.dropDown.shadowOffset = CGSize(width: 0, height: 0)
    self.dropDown.cornerRadius = 4
    self.dropDown.direction = .bottom
    self.dropDown.shadowColor = UIColor(named: "282828")!
    self.dropDown.cellHeight = 42
    self.dropDown.backgroundColor = .white
    self.dropDown.cellNib = UINib(nibName: "CommonDropDownCell", bundle: nil)
    
    
    self.dropDown.anchorView = self.categoryWrapView
    self.dropDown.width = self.categoryWrapView.frame.size.width
    self.dropDown.dataSource = self.categoryList
    
    self.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
      guard let cell = cell as? CommonDropDownCell else { return }
      cell.titleLabel.text = item
      cell.optionLabel.isHidden = true
    }
    
    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.categoryTextField.text = self.categoryList[index]
      self.categoryType = index
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 등록 버튼 터치시
  ///
  /// - Parameter sender: 바 버튼
  @IBAction func enrollButtonTouched(sender: UIButton) {
    self.qaRegInAPI()
  }
  
}


