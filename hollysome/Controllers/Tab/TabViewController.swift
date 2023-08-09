//
//  TabViewController.swift
//  hollysome
//
//  Created by rocateer on 2020/01/09.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Parchment

class TabViewController: RocateerViewController {
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
    
    let subTabViewController = SubTabViewController.instantiate(storyboard: "Tab")
    let subTab2ViewController = SubTab2ViewController.instantiate(storyboard: "Tab")
    
    let pagingViewController = PagingViewController(viewControllers: [
      subTabViewController,
      subTab2ViewController
    ])
    
    pagingViewController.menuItemSize = PagingMenuItemSize.fixed(width: self.view.frame.size.width / 2, height: 51)
    pagingViewController.indicatorColor = UIColor(named: "333333")!
    pagingViewController.indicatorOptions = PagingIndicatorOptions.visible(height: 4, zIndex: 0, spacing: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    pagingViewController.borderColor = UIColor(named: "DDDDDD")!
    pagingViewController.borderOptions = PagingBorderOptions.visible(height: 1, zIndex: 0, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    pagingViewController.selectedTextColor = UIColor(named: "333333")!
    pagingViewController.textColor = UIColor(named: "707070")!
    pagingViewController.font = UIFont.systemFont(ofSize: 16)
    pagingViewController.selectedFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    pagingViewController.menuTransition = .scrollAlongside
    
    
    self.addChild(pagingViewController)
    self.view.addSubview(pagingViewController.view)
    self.view.constrainToEdges(pagingViewController.view)
    
    pagingViewController.didMove(toParent: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


