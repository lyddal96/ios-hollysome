//
//  QnaRegistViewController.swift
//  hollysome
//
import UIKit
import DropDown
import Defaults

class QnaRegistViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var categoryWrapView: UIView!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var enrollButton: UIButton!
  @IBOutlet weak var cateImageView: UIImageView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var qnaRequest = QnaModel()
  var categoryType: Int? = nil
  let dropDown = DropDown()
  var qa_type = "0"
  let categoryList = ["불편 신고", "제보", "기타"]
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
    
    self.categoryWrapView.setCornerRadius(radius: 8)
    self.categoryWrapView.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
    self.titleTextField.setCornerRadius(radius: 8)
    self.titleTextField.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
    self.contentView.setCornerRadius(radius: 8)
    self.contentView.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
    self.enrollButton.setCornerRadius(radius: 12)
    self.cateImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi))
    self.categoryTextField.isEnabled = false
    self.titleTextField.setTextPadding(16)
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.customizeDropDown(self)
    self.categoryWrapView.addTapGesture { recognizer in
      self.dropDown.show()
      UIView.animate(withDuration: (0.3)) {
        self.cateImageView.transform = CGAffineTransform(rotationAngle: (0))
      }
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
    self.qnaRequest.member_idx = Defaults[.member_idx]
    self.qnaRequest.qa_type = self.qa_type
    self.qnaRequest.qa_title = self.titleTextField.text
    self.qnaRequest.qa_contents = self.contentTextView.text
    if let category = self.categoryType {
      self.qnaRequest.category = category
    }
    
  
    APIRouter.shared.api(path: .qa_reg_in,method: .post , parameters: self.qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        self.notificationCenter.post(name: Notification.Name("QnaListUpdate"), object: nil)
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
      self.qa_type = "\(index)"
      UIView.animate(withDuration: (0.3)) {
        self.cateImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi))
      }
    }
    
    self.dropDown.cancelAction = {
      UIView.animate(withDuration: (0.3)) {
        self.cateImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi))
      }
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


