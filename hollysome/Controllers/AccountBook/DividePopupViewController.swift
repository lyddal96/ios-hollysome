//
//  DividePopupViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/19/23.
//

import UIKit
import Defaults
import GoogleMobileAds

class DividePopupViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var priceView: UIView!
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
  
  var mateList = [MemberModel]()
  var bookData = AccountBookModel()
  private var rewardedAd: GADRewardedAd?
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding
    
    self.mateCollectionView.registerCell(type: MateCell.self)
    self.mateCollectionView.delegate = self
    self.mateCollectionView.dataSource = self
    self.callbackAd()
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
    self.popupHeight = 334
    
    self.priceView.setCornerRadius(radius: 12)
    self.closeButton.setCornerRadius(radius: 12)
    self.divideButton.setCornerRadius(radius: 12)
    
    self.titleLabel.text = self.bookData.item_name ?? ""
    self.priceLabel.text = Tools.shared.numberPlaceValue(self.bookData.item_price)
  }
  
 
  override func initRequest() {
    super.initRequest()
    
    self.dimmerView.addTapGesture { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }
    
    self.dimmerView.addSwipeGesture(direction: UISwipeGestureRecognizer.Direction.down) { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }
    self.mateListAPI()
    
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
  /// 메이트 리스트
  func mateListAPI() {
    let mateRequest = MemberModel()
    mateRequest.member_idx = Defaults[.member_idx]
    mateRequest.house_idx = Defaults[.house_idx]
    mateRequest.house_code = Defaults[.house_code]

    APIRouter.shared.api(path: .mate_list, method: .post, parameters: mateRequest.toJSON()) { response in
      if let mateResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: mateResponse) {
        if let data_array = mateResponse.data_array, data_array.count > 0 {
          self.mateList = data_array
        }
        self.mateCollectionView.reloadData()
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
                
              }
            }
          }
        }
      }
    })
    
    hideCard.startAnimation()
  }
  
  func callbackAd() {
    let request = GADRequest()
    GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
                       request: request,
                       completionHandler: { [self] ad, error in
      if let error = error {
        print("Failed to load rewarded ad with error: \(error.localizedDescription)")
        return
      }
      rewardedAd = ad
      print("Rewarded ad loaded.")
      rewardedAd?.fullScreenContentDelegate = self
      
    }
    )
  }

  func loadRewardedAd() {
    
    if let ad = rewardedAd {
      ad.present(fromRootViewController: self) {
        let reward = ad.adReward
        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
        // TODO: Reward the user.
        
        let bookRequest = AccountBookModel()
//        bookRequest.member_arr = "{\()}"
        bookRequest.mate_cnt = "\(self.mateList.count)"
        var member_arr = self.mateList.filter({ $0.isSelected == true })
        bookRequest.member_arr = member_arr.map({$0.member_idx ?? ""}).joined(separator: ",")
        bookRequest.item_bill = self.bookData.item_price
        bookRequest.item_name = self.bookData.item_name
        
        APIRouter.shared.api(path: .book_alarm, method: .post, parameters: bookRequest.toJSON()) { request in
          if let bookRequest = AccountBookModel(JSON: request), Tools.shared.isSuccessResponse(response: bookRequest) {
            self.hideCardAndGoBack(type: nil)
          }
        }
        GADMobileAds().initializationStatus
      }
    } else {
      print("Ad wasn't ready")
    }
    
    
    
//    self.rewardedAd?.present(fromRootViewController: self, userDidEarnRewardHandler: {
//      let reward = self.rewardedAd?.adReward
//
//      log.debug("reward : \(reward)")
//    })
   }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 닫기
  /// - Parameter sender: 버튼
  @IBAction func closeButtonTouched(sender: UIButton) {
    self.hideCardAndGoBack(type: nil)
  }
  
  /// 광고보고 비용 알리기
  /// - Parameter sender: 버튼
  @IBAction func divideButtonTouched(sender: UIButton) {
    self.loadRewardedAd()
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension DividePopupViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.mateList[indexPath.row].isSelected = !(self.mateList[indexPath.row].isSelected ?? false)
    self.mateCollectionView.reloadData()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension DividePopupViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 52, height: 74)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension DividePopupViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.mateList.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
    
    let mate = self.mateList[indexPath.row]
    cell.setMate(mate: mate)
    cell.selectImageView.isHidden = !(mate.isSelected ?? false)
    return cell
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - GADFullScreenContentDelegate
//-------------------------------------------------------------------------------------------
extension DividePopupViewController: GADFullScreenContentDelegate {

  /// Tells the delegate that the ad failed to present full screen content.
  func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    print("Ad did fail to present full screen content.")
  }

  /// Tells the delegate that the ad will present full screen content.
  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad will present full screen content.")
  }

  /// Tells the delegate that the ad dismissed full screen content.
  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad did dismiss full screen content.")

  }
  
  
}
