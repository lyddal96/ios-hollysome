//
//  CardPopupViewController.swift
//  hollysome
//

import UIKit

class CardPopupViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  
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
    self.cardView.clipsToBounds = true
    self.cardView.layer.cornerRadius = 10.0
    self.cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    self.dimmerView.alpha = 0.0
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.dimmerView.addTapGesture { (recognizer) in
      self.hideCardAndGoBack()
    }
    
    self.dimmerView.addSwipeGesture(direction: UISwipeGestureRecognizer.Direction.down) { (recognizer) in
      self.hideCardAndGoBack()
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
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    
    // 카드 반만 펼치기
    self.cardViewTopConstraint.constant = (self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding) / 2.0
    // 카드 완전히 펼치기
    //      self.cardViewTopConstraint.constant = 30
    
    
    let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })
    
    showCard.addAnimations({
      self.dimmerView.alpha = 0.7
    })
    
    showCard.startAnimation()
    
  }
  
  /// 카드 숨기면서 화면 닫기
  private func hideCardAndGoBack() {
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
          self.dismiss(animated: false, completion: nil)
        }
      }
    })
    
    hideCard.startAnimation()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


