//
//  NoticeRegViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/16/23.
//

import UIKit
import RSKGrowingTextView
import Defaults

enum EnrollType {
  case enroll
  case modify
}

class NoticeRegViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var registBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var textCntLabel: UILabel!
  @IBOutlet weak var noticeTextView: RSKGrowingTextView!
  @IBOutlet weak var contentsWrapView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var enrollType = EnrollType.enroll
  
  var note_idx = ""
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.noticeTextView.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.contentsWrapView.setCornerRadius(radius: 12)
    self.contentsWrapView.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
    
    self.registBarButtonItem.image = UIImage(named: self.enrollType == .enroll ? "reg_btn" : "modi_btn")
  }
  
  override func initRequest() {
    super.initRequest()
    
    if self.enrollType == .modify {
      self.noteDetailAPI()
    }
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 알림장 상세 API
  func noteDetailAPI() {
    let noteRequest = HouseModel()
    noteRequest.note_idx = self.note_idx
    
    APIRouter.shared.api(path: .note_detail, method: .post, parameters: noteRequest.toJSON()) { response in
      if let noteResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: noteResponse) {
        self.noticeTextView.text = noteResponse.contents ?? ""
        self.textCntLabel.text = "\(self.noticeTextView.text.count) / 200"
        self.noticeTextView.resizeToFitHeight()
        self.noticeTextView.isUserInteractionEnabled = true
      }
    }
  }
  /// 알림장 등록/수정 API
  func noteRegAPI() {
    let noteRequest = HouseModel()
    noteRequest.member_idx = Defaults[.member_idx]
    noteRequest.house_code = Defaults[.house_code]
    noteRequest.contents = self.noticeTextView.text
    noteRequest.note_idx = self.note_idx
    
    let path = self.enrollType == .enroll ? APIURL.note_reg_in : .note_mod_up
    APIRouter.shared.api(path: path, method: .post, parameters: noteRequest.toJSON()) { response in
      if let noteResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: noteResponse) {
        self.notificationCenter.post(name: Notification.Name("HouseNoteUpdate"), object: nil)
        self.navigationController?.popViewController(animated: true)
      }

    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 등록 / 수정
  /// - Parameter sender: 바버튼
  @IBAction func regBarButtonItemTouched(sender: UIButton) {
    if self.noticeTextView.text.count == 0 {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "작성한 내용이 없습니다.", aStrMessage: "", alertViewHiddenCheck: false, img: "error_circle") { position, title in
      }
    } else {
      AJAlertController.initialization().showAlert(astrTitle: "알림장을 \(self.enrollType == .enroll ? "등록" : "수정")하시겠어요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: self.enrollType == .enroll ? "등록" : "수정") { position, title in
        if position == 1 {
          self.noteRegAPI()
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - RSKGrowingTextViewDelegate
//-------------------------------------------------------------------------------------------
extension NoticeRegViewController: RSKGrowingTextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    self.contentsWrapView.addBorder(width: 1, color: UIColor(named: "87B7FF")!)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    self.contentsWrapView.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    self.textCntLabel.text = "\(textView.text.count) / 200"
    
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text.count >= 200 {
      return false
    } else {
      return true
    }
  }
}
