//
//  MainTabBarViewCntroller.swift
//  RocateerKit
//
//  Created by 이승아 on 2023/05/26.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit

class MainTabBarViewController: IndicatingTabBarController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
    
    
//    self.tabBar.addBorderTop(size: 1, color: UIColor(named: "282828")!)
//
//    if #available(iOS 15.0, *) {
//      // set tabbar opacity
//      self.tabBar.scrollEdgeAppearance = tabBar.standardAppearance
//    }
    
    self.setupTabBarUI()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    moveIndicator(at: self.selectedIndex)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let items = tabBar.items else { return }
    moveIndicator(at: items.firstIndex(of: item) ?? 0)
  }
  
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
      /// 탭바 아이템 인덱스 선택 액션줄때
      log.debug("tabBarIndex = \(index)")
    }
    return true
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  private func setupTabBarUI() {
    // Setup your colors and corner radius
    self.tabBar.backgroundColor = UIColor.white
    self.tabBar.unselectedItemTintColor = UIColor.white
    self.tabBar.isTranslucent = true
    self.tabBar.tintColor = UIColor(named: "accent")
    self.tabBar.barTintColor = .clear
    
    self.tabBar.layer.masksToBounds = false
    self.tabBar.layer.shadowColor = UIColor.black.cgColor
    self.tabBar.layer.shadowOpacity = 0.1
    self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.tabBar.layer.shadowRadius = 5
    
    
    // Remove the line
    if #available(iOS 13.0, *) {
      let appearance = self.tabBar.standardAppearance
      appearance.shadowImage = nil
      appearance.shadowColor = nil
      appearance.backgroundImage = nil
      appearance.backgroundEffect = nil
      self.tabBar.standardAppearance = appearance
    } else {
      self.tabBar.shadowImage = UIImage()
      self.tabBar.backgroundImage = UIImage()
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UITabBarControllerDelegate
//-------------------------------------------------------------------------------------------
//extension MainTabBarViewController: UITabBarControllerDelegate {
//  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//    if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
//      /// 탭바 아이템 인덱스 선택 액션줄때
//    }
//    return true
//  }
//
//}
