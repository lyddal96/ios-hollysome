//
//  DonateViewController.swift
//  hollysome
//
//  Created by 이승아 on 1/2/24.
//

import UIKit
import StoreKit

protocol DonateDelegate {
  func donateDelegate(priceNum: Int)
}


class DonateViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var donate1Button: UIButton!
  @IBOutlet weak var donate2Button: UIButton!
  @IBOutlet weak var donate3Button: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var payButton: UIButton!
  @IBOutlet weak var donate1PriceLabel: UILabel!
  @IBOutlet weak var donate2PriceLabel: UILabel!
  @IBOutlet weak var donate3PriceLabel: UILabel!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var delegate: DonateDelegate?
  var popupHeight: CGFloat = 0
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0
  
  let productIdentifiers: Set<String> = ["sseung.noommate.removead"]
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
    
    self.popupHeight = 359
    
    self.donate1Button.setCornerRadius(radius: 8)
    self.donate2Button.setCornerRadius(radius: 8)
    self.donate3Button.setCornerRadius(radius: 8)
    self.cancelButton.setCornerRadius(radius: 12)
    self.payButton.setCornerRadius(radius: 12)
    
    self.payButton.setBackgroundColor(UIColor(named: "C8CCD5")!, forState: .disabled)
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
                self.delegate?.donateDelegate(priceNum: type!)
              }
            }
          }
        }
      }
    })
    
    hideCard.startAnimation()
  }
  
  var productsRequest: SKProductsRequest!

  func requestProducts() {
      productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
      productsRequest.delegate = self
      productsRequest.start()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 금액선택
  /// - Parameter sender: 버튼
  @IBAction func priceButtonTouched(sender: UIButton) {
    self.payButton.isEnabled = true
    self.donate1Button.isSelected = false
    self.donate2Button.isSelected = false
    self.donate3Button.isSelected = false
    sender.isSelected = true
  }
  
  /// 닫기
  /// - Parameter sender: 버튼
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.hideCardAndGoBack(type: nil)
  }
  
  /// 선택 완료
  /// - Parameter sender: 버튼
  @IBAction func payButtonTouched(sender: UIButton) {
    
    self.requestProducts()
    
    
//    self.hideCardAndGoBack(type: self.donate1Button.isSelected ? 0 : self.donate2Button.isSelected ? 1 : 2)
  }
  
  
  
}
extension DonateViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        // 상품 목록 처리
      log.debug(products.count)
      
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                // 구매 성공 처리
                break
            case .failed:
                // 구매 실패 처리
                break
            default:
                break
            }
        }
    }
}
