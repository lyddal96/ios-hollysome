//
//  CardPopupViewController.swift
//  hollysome
//

import UIKit

@objc protocol CardPopupSelectDelegate {
  @objc optional func albumTouched()
  @objc optional func cameraTouched()
  @objc optional func blockTouched(note_idx: String)
  @objc optional func reportTouched(note_idx: String)
}

class CardPopupViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var albumButton: UIButton!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var blockButton: UIButton!
  @IBOutlet weak var reportButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var delegate: CardPopupSelectDelegate?
  var popupHeight: CGFloat = 0
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0
  
  var albumIsHidden = true
  var cameraIsHidden = true
  var reportIsHidden = true
  var blockIsHidden = true

  var note_idx = ""
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding
    
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
    
    
    self.albumButton.isHidden = self.albumIsHidden
    self.cameraButton.isHidden = self.cameraIsHidden
    self.blockButton.isHidden = self.blockIsHidden
    self.reportButton.isHidden = self.reportIsHidden
        
    //    self.closeButton.addBorderTop(size: 1, color: UIColor(named: "F9F9F9")!)
    
    var buttons = [UIButton]()
    buttons.append(self.albumButton)
    buttons.append(self.cameraButton)
    buttons.append(self.blockButton)
    buttons.append(self.reportButton)
    
    var buttonCnt = 0
    
    self.cancelButton.setCornerRadius(radius: 12)
    for value in buttons {
      value.setCornerRadius(radius: 12)
      value.addBorder(width: 1, color: UIColor(named: "accent")!)
      if !value.isHidden {
        buttonCnt += 1
      }
    }
    
    self.popupHeight = CGFloat(66 * buttonCnt) + 100
    
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.dimmerView.addTapGesture { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }
    
    self.dimmerView.addSwipeGesture(direction: UISwipeGestureRecognizer.Direction.down) { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showCard()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
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
                self.delegate?.albumTouched?()
              } else if type == 1 {
                self.delegate?.cameraTouched?()
              } else if type == 2 {
                self.delegate?.blockTouched?(note_idx: self.note_idx)
              } else if type == 3 {
                self.delegate?.reportTouched?(note_idx: self.note_idx)
              }
            }
          }
        }
      }
    })
    
    hideCard.startAnimation()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 하단 팝업 버튼 터치 이벤트
  /// - Parameter sender: 버튼
  @IBAction func buttonTouched(sender: UIButton) {
    self.hideCardAndGoBack(type: sender.tag)
  }
  
  /// 취소
  /// - Parameter sender: 버튼
  @IBAction func closeButtonTouched(sender: UIButton) {
    self.hideCardAndGoBack(type: nil)
  }
}


