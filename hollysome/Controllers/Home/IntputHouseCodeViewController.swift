//
//  IntputHouseCodeViewController.swift
//  hollysome
//
//  Created by 이승아 on 10/27/23.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit

class IntputHouseCodeViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var codeTextField: UITextField!
  @IBOutlet weak var finishButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var retryLabel: UILabel!
  @IBOutlet weak var redDotImageView: UIImageView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
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
//    self.cardView.layer.cornerRadius = 10.0
    self.cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    self.dimmerView.alpha = 0.0
    
    self.cardView.roundCorners(cornerRadius: 12, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    self.codeTextField.setCornerRadius(radius: 4)
    self.finishButton.setCornerRadius(radius: 12)
    self.cancelButton.setCornerRadius(radius: 12)
    self.codeTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.codeTextField.setTextPadding(15)
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
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    
    self.cardViewTopConstraint.constant = self.view.frame.size.height - (355 + bottomPadding + self.statusHeight)
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
  /// 입력 완료
  /// - Parameter sender: 버튼
  @IBAction func finishButtonTouched(sender: UIButton) {
    self.hideCardAndGoBack()
  }
  
  
  /// 취소
  /// - Parameter sender: 버튼
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.hideCardAndGoBack()
  }
}
