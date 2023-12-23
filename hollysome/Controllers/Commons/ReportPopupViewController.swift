//
//  ReportPopupViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit
import RSKGrowingTextView
import DropDown
import Defaults

protocol ReportDelegate {
  func reportDelegate(note_idx: String)
}

class ReportPopupViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var categoryView: UIView!
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var cateImageView: UIImageView!
  @IBOutlet weak var reasonTextView: RSKGrowingTextView!
  @IBOutlet weak var reasonView: UIView!
  @IBOutlet weak var reasonCntLabel: UILabel!
  @IBOutlet weak var reportButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var delegate: ReportDelegate?
  var popupHeight: CGFloat = 0
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0
  
  let dropDown = DropDown()
  var type: Int? = nil
  var note_idx = ""
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding
    
    self.reasonTextView.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.cardView.setCornerRadius(radius: 12)
    
    self.cardView.clipsToBounds = false
    self.cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    self.dimmerView.alpha = 0.0
    self.dimmerView.isOpaque = false
    
    self.categoryView.setCornerRadius(radius: 12)
    self.reasonView.setCornerRadius(radius: 12)
    self.categoryView.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.reasonView.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.reportButton.setCornerRadius(radius: 12)
    self.cancelButton.setCornerRadius(radius: 12)
    
    self.popupHeight = self.cancelButton.frame.maxY + 30
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.customizeDropDown(self)
    self.categoryView.addTapGesture { recognizer in
      self.dropDown.show()
      UIView.animate(withDuration: (0.3)) {
        self.cateImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi))
        self.categoryView.addBorder(width: 1, color: UIColor(named: "87B7FF")!)
      }
    }
    
    self.dimmerView.addTapGesture { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }
    
    self.dimmerView.addSwipeGesture(direction: UISwipeGestureRecognizer.Direction.down) { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }
    
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showCard()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
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
    
    
    self.dropDown.anchorView = self.categoryView
    self.dropDown.width = self.categoryView.frame.size.width
    self.dropDown.dataSource = Constants.REPORT_TYPE

    self.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
      guard let cell = cell as? CommonDropDownCell else { return }
      cell.titleLabel.text = item
      cell.optionLabel.isHidden = true
    }
    
    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.categoryTextField.text = Constants.REPORT_TYPE[index]
      self.type = index
      UIView.animate(withDuration: (0.3)) {
        self.cateImageView.transform = CGAffineTransform(rotationAngle: (0))
        self.categoryView.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
      }
    }
    
    self.dropDown.cancelAction = {
      UIView.animate(withDuration: (0.3)) {
        self.cateImageView.transform = CGAffineTransform(rotationAngle: (0))
        self.categoryView.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
      }
    }
  }
  
  
  /// 카드 보이기
  private func showCard() {
    self.view.layoutIfNeeded()
    
    self.cardViewTopConstraint.constant = self.view.frame.size.height - (self.popupHeight + bottomPadding + self.statusHeight)
    
    let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })
    
    showCard.addAnimations({
      self.dimmerView.alpha = 0.7
    })
    
    showCard.startAnimation()
    
  }
  
  /// 카드 숨기면서 화면 닫기
  private func hideCardAndGoBack(type: Int?) {
    self.view.layoutIfNeeded()
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding
    
    let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })
    
    hideCard.addAnimations {
      self.dimmerView.alpha = 0.0
    }
    
    hideCard.addCompletion({ position in
      if position == .end {
        if(self.presentingViewController != nil) {
          self.dismiss(animated: false) {
            if type != nil {
              if type == 0 {
                self.delegate?.reportDelegate(note_idx: self.note_idx)
              }
            }
          }
        }
      }
    })
    
    hideCard.startAnimation()
  }

  /// 알림장 신고하기 API
  func reportRegAPI() {
    let noteRequest = HouseModel()
    noteRequest.note_idx = self.note_idx
    noteRequest.member_idx = Defaults[.member_idx]
    noteRequest.report_contents = self.reasonTextView.text
    if let type = self.type {
      noteRequest.report_type = "\(type)"
    }

    APIRouter.shared.api(path: .report_reg_in, method: .post, parameters: noteRequest.toJSON()) { response in
      if let noteResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: noteResponse, alertYn: true) {
        self.hideCardAndGoBack(type: 0)
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 신고하기
  /// - Parameter sender: 버튼
  @IBAction func reportButtonTouched(sender: UIButton) {
    self.reportRegAPI()
  }
  
  /// 취소
  /// - Parameter sender: 버튼
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.hideCardAndGoBack(type: nil)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - RSKGrowingTextViewDelegate
//-------------------------------------------------------------------------------------------
extension ReportPopupViewController: RSKGrowingTextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    self.reasonView.addBorder(width: 1, color: UIColor(named: "87B7FF")!)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    self.reasonView.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    self.reasonCntLabel.text = "\(textView.text.count) / 100"
    
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if textView.text.count >= 100 {
      return false
    } else {
      return true
    }
  }
}
