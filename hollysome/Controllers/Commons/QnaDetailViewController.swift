//
//  QnaDetailViewController.swift
//  hollysome
//
import UIKit

class QnaDetailViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var categoryView: UIView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var answerView: UIView!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var answerDateLabel: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var qnaScrollView: UIScrollView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var qa_idx = ""
  var qnaRequest = QnaModel()
  var qnaResponse = QnaModel()
  var id: Int? = nil
  
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
    self.categoryView.setCornerRadius(radius: 12)
    self.deleteButton.addShadow(cornerRadius: 12)
  }
  
  override func initRequest() {
    super.initRequest()
    self.qnaDetailAPI()
  }

  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// QnA 상세
  private func qnaDetailAPI() {
//    self.qnaRequest.setNextPage()
    self.qnaRequest.qa_idx = self.qa_idx
    
    APIRouter.shared.api(path: .qa_detail, method: .get, parameters: self.qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        self.titleLabel.text = qnaResponse.qa_title ?? ""
        self.dateLabel.text = qnaResponse.ins_date ?? ""
        self.answerDateLabel.text = qnaResponse.reply_date ?? ""
        self.contentLabel.text = qnaResponse.qa_contents
        self.answerLabel.text = qnaResponse.reply_content ?? ""
        self.categoryLabel.text = Constants.qna_category(item: qnaResponse.qa_type ?? "")
        
        self.answerView.isHidden = qnaResponse.reply_yn != "Y"
        self.qnaResponse = qnaResponse
        
      }
    }
  }
  
  
  /// QnA 삭제
  private func qnaDelAPI() {
    self.qnaRequest.id = self.id
    
    APIRouter.shared.api(path: .qa_del, method: .post, parameters: self.qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response),Tools.shared.isSuccessResponse(response: qnaResponse) {
        
        self.notificationCenter.post(name: Notification.Name("QnaListUpdate"), object: nil)
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "문의가 삭제 되었습니다.", aStrMessage: "", alertViewHiddenCheck: false, img: "check_circle") { position, title in
          self.navigationController?.popViewController(animated: true)
        }
      }
    }
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// Qna 삭제 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func deleteButtonTouched(sender: UIButton) {
    AJAlertController.initialization().showAlert(astrTitle: "해당 문의글을 삭제하시겠습니까?\n삭제 하시면 해당 글은 다시 복구 할 수 없습니다.", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
      if position == 1 {
        self.qnaDelAPI()
      }
    }
  }
  
}

