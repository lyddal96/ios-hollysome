//
//  MainTabBarViewCntroller.swift
//  hollysome
//
//  Created by 이승아 on 2023/05/26.
//
//

import UIKit
import Defaults

class MainTabBarViewController: UITabBarController {
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
    NotificationCenter.default.addObserver(self, selector: #selector(self.goToHome), name: Notification.Name("GoToHome"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.goToTodo), name: Notification.Name("GoToTodo"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.goToBook), name: Notification.Name("GoToBook"), object: nil)
    let appearance = UITabBarAppearance()
    // set tabbar opacity
    appearance.configureWithOpaqueBackground()
    
    // tabbar border line
    appearance.shadowColor = UIColor.clear
    
    // set tabbar background color
    appearance.backgroundColor = .white
    
    self.tabBar.standardAppearance = appearance
    self.tabBar.addBorderTop(size: 1, color: UIColor(named: "FFFFFF")!)
    self.delegate = self
    
    
//    self.tabBar.addBorderTop(size: 1, color: UIColor(named: "282828")!)
//
//    if #available(iOS 15.0, *) {
//      // set tabbar opacity
//      self.tabBar.scrollEdgeAppearance = tabBar.standardAppearance
//    }
    
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    moveIndicator(at: self.selectedIndex)
    self.tabBar.tintColor = UIColor(named: "accent")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
//  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//    guard let items = tabBar.items else { return }
//    moveIndicator(at: items.firstIndex(of: item) ?? 0)
//  }
//
//
//  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//    if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
//      /// 탭바 아이템 인덱스 선택 액션줄때
//      log.debug("tabBarIndex = \(index)")
//    }
//    return true
//  }
//
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  @objc func goToHome() {
    self.selectedIndex = 0
  }
  @objc func goToTodo() {
    self.selectedIndex = 1
  }
  @objc func goToBook() {
    self.selectedIndex = 2
  }
  //
//  private func setupTabBarUI() {
//    // Setup your colors and corner radius
//    self.tabBar.backgroundColor = UIColor.white
//    self.tabBar.unselectedItemTintColor = UIColor.white
//    self.tabBar.isTranslucent = true
//    self.tabBar.tintColor = UIColor(named: "accent")
//    self.tabBar.barTintColor = .clear
//
//    self.tabBar.layer.masksToBounds = false
//    self.tabBar.layer.shadowColor = UIColor.black.cgColor
//    self.tabBar.layer.shadowOpacity = 0.1
//    self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//    self.tabBar.layer.shadowRadius = 5
//
//
//    // Remove the line
//    if #available(iOS 13.0, *) {
//      let appearance = self.tabBar.standardAppearance
//      appearance.shadowImage = nil
//      appearance.shadowColor = nil
//      appearance.backgroundImage = nil
//      appearance.backgroundEffect = nil
//      self.tabBar.standardAppearance = appearance
//    } else {
//      self.tabBar.shadowImage = UIImage()
//      self.tabBar.backgroundImage = UIImage()
//    }
//  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UITabBarControllerDelegate
//-------------------------------------------------------------------------------------------
extension MainTabBarViewController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
      /// 탭바 아이템 인덱스 선택 액션줄때
      ///
      if Defaults[.house_idx] == nil && index != 0 && index != 3 {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "아직 소속된 하우스가 없어요.\n메이트가 되어 더 많은 눔메이트의 서비스를 이용해 보세요!", aStrMessage: "", alertViewHiddenCheck: false, img: "error_circle") { position, title in
        }
        return false
      }
    }
    return true
  }

}
