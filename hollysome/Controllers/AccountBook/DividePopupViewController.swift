//
//  DividePopupViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/19/23.
//

import UIKit

class DividePopupViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var mateCollectionView: UICollectionView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var divideButton: UIButton!
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var popupHeight: CGFloat = 0
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0
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
  
}
