//
//  NoticeRegViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/16/23.
//

import UIKit
import RSKGrowingTextView

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
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 등록 / 수정
  /// - Parameter sender: 바버튼
  @IBAction func regBarButtonItemTouched(sender: UIButton) {
    
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
    if textView.text.count >= 200 {
      return false
    } else {
      return true
    }
  }
}
