//
//  QnaDetailViewController.swift
//  hollysome
//
//  Created by rocateer on 28/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//
import UIKit

class QnaDetailViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var stateView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
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
    self.stateView.setCornerRadius(radius: 15)
    self.deleteButton.addShadow(cornerRadius: 25)
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
//    self.qnaRequest.qa_idx = self.qa_idx
//
    self.qnaRequest.id = self.id
    
    APIRouter.shared.api(path: .qa_detail, method: .get, parameters: self.qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        if let result = qnaResponse.result {
          self.titleLabel.text = result.title ?? ""
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let date = dateFormatter.date(from: result.created_at ?? "") ?? Date()
          let replyDate = dateFormatter.date(from: result.reply_date ?? "") ?? Date()
          dateFormatter.dateFormat = "yyyy.MM.dd"
          self.dateLabel.text = dateFormatter.string(from: date)
          self.contentLabel.text = result.content
          
          self.answerView.isHidden = result.reply_yn != 1
          self.answerLabel.text = result.reply_content ?? ""
          self.answerDateLabel.text = dateFormatter.string(from: replyDate)
          
          if result.reply_yn == 1 {
            self.stateLabel.text = "답변완료"
            self.stateLabel.textColor = UIColor(named: "4CAF50")
            self.stateView.backgroundColor = UIColor(named: "E8F5E9")
            self.qnaScrollView.backgroundColor = UIColor(named: "E1F5FE")
          } else {
            self.stateLabel.text = "미답변"
            self.stateLabel.textColor = UIColor(named: "F44336")
            self.stateView.backgroundColor = UIColor(named: "FFEBEE")
          }
          
        }
        self.qnaResponse = qnaResponse
        
      }
    }
  }
  
  
  /// QnA 삭제
  private func qnaDelAPI() {
    self.qnaRequest.id = self.id
    
    APIRouter.shared.api(path: .qa_del, method: .post, parameters: self.qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response),Tools.shared.isSuccessResponse(response: qnaResponse) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("QnaListUpdate"), object: nil)
        self.navigationController?.popViewController(animated: true)
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
    AJAlertController.initialization().showAlert(astrTitle: "Rocateer", aStrMessage: "삭제하시겠습니까?", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { (position, title) in
      if position == 1 {
        self.qnaDelAPI()
      }
    }
    
  }
  
}

