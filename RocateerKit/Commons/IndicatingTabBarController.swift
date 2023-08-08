//
//  IndicatingTabBarController.swift
//  RocateerKit
//
//  Created by 이승아 on 2023/05/26.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit

class IndicatingTabBarController: UITabBarController, UITabBarControllerDelegate {
  
  // MARK: - Properties -
  private let indicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  // Set attributes as you need here
  private lazy var indicatorWidth: Double = tabBar.bounds.width / CGFloat(tabBar.items?.count ?? 1)
  private var indicatorColor: UIColor = .black
  
  // MARK: - Life cycle -
  override func viewDidLoad() {
    super.viewDidLoad()
    // Add the line indicator as a subview of the tab bar
    tabBar.addSubview(indicatorView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // Position the line indicator at the bottom of the selected tab item
    moveIndicator()
  }
  
  // MARK: - Methods -
  func moveIndicator(at index: Int=0) {
    let itemWidth = (tabBar.bounds.width / CGFloat(tabBar.items?.count ?? 1))
    let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0
    let xPosition = (CGFloat(index) * itemWidth) + ((itemWidth / 2) - (indicatorWidth / 2))
    let yPosition = 0.toDouble
    
    UIView.animate(withDuration: 0.3) { [self] in
      self.indicatorView.frame = CGRect(x: xPosition,
                                        y: yPosition,
                                        width: self.indicatorWidth,
                                        height: 2)
      self.indicatorView.backgroundColor = self.indicatorColor
    }
  }
  
  // MARK: - UITabBarControllerDelegate -
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let items = tabBar.items else { return }
    moveIndicator(at: items.firstIndex(of: item) ?? 0)
  }
}
