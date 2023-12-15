//
//  PokeViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
import StringStylizer
import Defaults
import GoogleMobileAds

class PokeViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var avatarView: UIView!
  @IBOutlet weak var shapeImageView: UIImageView!
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var pokeButton: UIButton!
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var popupView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var member = MemberModel()
  var schedule = ""
  
  private var rewardedAd: GADRewardedAd?
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.callbackAd()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.closeButton.setCornerRadius(radius: 12)
    self.pokeButton.setCornerRadius(radius: 12)
    self.popupView.setCornerRadius(radius: 12)
    
    self.setMember()
    if Defaults[.poke_cnt] ?? 0 == 0 {
      self.pokeButton.setTitle("광고보고 콕콕!", for: .normal)
    } else {
      self.pokeButton.setTitle("콕찌르기 \(Defaults[.poke_cnt]!)", for: .normal)
    }
    
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
  func setMember() {
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
    
    self.shapeImageView.image = UIImage(named: "\(shapeList[0])71")
    self.faceImageView.image = UIImage(named: "face\(0)")
    self.colorView.backgroundColor = UIColor(named: "profile\(0)")
    
    let name = "아이유(이)가\n".stylize().font(UIFont.systemFont(ofSize: 14, weight: .bold)).color(UIColor(named: "3A3A3C")!).attr
    let content = "아직 분리수거을(를) 완료하지 않았어요.\n메이트를 콕 찔러 알려주세요.".stylize().font(UIFont.systemFont(ofSize: 14, weight: .regular)).color(UIColor(named: "3A3A3C")!).attr
    self.contentLabel.attributedText = name + content
  }

  
  /// 광고 띄우기
//  func showAd() {
//    guard let rewardedInterstitialAd = rewardedInterstitialAd else {
//      return print("Ad wasn't ready.")
//    }
//    
//    rewardedInterstitialAd.present(fromRootViewController: self) {
//      let reward = rewardedInterstitialAd.adReward
//      // TODO: Reward the user!
//      log.debug("reward")
//    }
//  }
  
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
        
        Defaults[.poke_cnt] = 3
        self.pokeButton.setTitle("콕찌르기 \(Defaults[.poke_cnt]!)", for: .normal)
        
//        self.callbackAd()
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
    self.dismiss(animated: false)
  }
  
  /// 콕찌르기
  /// - Parameter sender: 버튼
  @IBAction func pokeButtonTouched(sender: UIButton) {
    if let poke_cnt = Defaults[.poke_cnt], poke_cnt != 0 {
      Defaults[.poke_cnt] = poke_cnt - 1
    } else {
      self.loadRewardedAd()
    }
    if Defaults[.poke_cnt] ?? 0 == 0 {
      self.pokeButton.setTitle("광고보고 콕콕!", for: .normal)
    } else {
      self.pokeButton.setTitle("콕찌르기 \(Defaults[.poke_cnt]!)", for: .normal)
    }
  }
}

extension PokeViewController: GADFullScreenContentDelegate {

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
