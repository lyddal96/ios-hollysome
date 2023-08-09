//
//  HeaderTabViewController.swift
//  hollysome
//
//  Created by rocateer on 2020/01/10.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Parchment

class HeaderTabViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  private let pagingViewController = CustomPagingViewController()
  private let pagingTitleCell = PagingTitleCell()
  
  var currentIndex = 0 // 선택된 현재 카테고리 Index
  
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
    self.initTab()
  }
  
  override func initRequest() {
    super.initRequest()
  }

  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 탭 세팅
  private func initTab() {
    
    //    pagingViewController.menuInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
    //    pagingViewController.menuItemSize = PagingMenuItemSize.sizeToFit(minWidth: 26, height: 26)
    pagingViewController.menuItemSpacing = 10
    pagingViewController.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: 0, spacing: UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    pagingViewController.indicatorColor = UIColor(named: "333333")!
    pagingViewController.borderOptions = PagingBorderOptions.visible(height: 1, zIndex: 0, insets: UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12))
    pagingViewController.borderColor = UIColor(named: "DDDDDD")!
    pagingViewController.selectedBackgroundColor = .clear
    pagingViewController.selectedTextColor = UIColor(named: "333333")!
    pagingViewController.textColor = UIColor(named: "707070")!
    pagingViewController.font = UIFont.systemFont(ofSize: 13)
    pagingViewController.selectedFont = UIFont.systemFont(ofSize: 13)
    
    
    self.addChild(pagingViewController)
    self.view.addSubview(pagingViewController.view)
    self.view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
    
    pagingViewController.dataSource = self
    pagingViewController.delegate = self
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


//-------------------------------------------------------------------------------------------
// MARK: - PagingViewControllerDataSource
//-------------------------------------------------------------------------------------------
extension HeaderTabViewController: PagingViewControllerDataSource {
  
  func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    let viewController = TabTableViewController()
    
    // Inset the table view with the height of the menu height.
    var height = pagingViewController.options.menuHeight
    height += 312
    
    let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
    viewController.tableView.contentInset = insets
    viewController.tableView.scrollIndicatorInsets = insets
    viewController.tableView.delegate = self
    viewController.index = index
    //    viewController.categoryList = self.categoryList
    
    
    if let pagingView = pagingViewController.view as? CustomPagingView {
      let headerView = pagingView.headerView as? HeaderView
      
    }
    
    return viewController
   }
  
  
  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    /// Tab Title
      return PagingIndexItem(index: index, title: "카테고리 \(index)")
  }
  
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
      return 10
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - PagingViewControllerDelegate
//-------------------------------------------------------------------------------------------
extension HeaderTabViewController: PagingViewControllerDelegate {

  func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
    guard let startingViewController = startingViewController as? TabTableViewController else { return }
    guard let destinationViewController = destinationViewController as? TabTableViewController else { return }
    
    // Set the delegate on the currently selected view so that we can
    // listen to the scroll view delegate.
    if transitionSuccessful {
      startingViewController.tableView.delegate = nil
      destinationViewController.tableView.delegate = self
    }
    
    guard let indexItem = pagingViewController.state.currentPagingItem as? PagingIndexItem else {
      return
    }
    self.currentIndex = indexItem.index
  }

  func pagingViewController(_ pagingViewController: PagingViewController, willScrollToItem pagingItem: PagingItem, startingViewController: UIViewController, destinationViewController: UIViewController) {
    guard let destinationViewController = destinationViewController as? TabTableViewController else { return }
    
    // Update the content offset based on the height of the header view.
    if let pagingView = pagingViewController.view as? CustomPagingView {
      if let headerHeight = pagingView.headerHeightConstraint?.constant {
        let offset = headerHeight + pagingViewController.options.menuHeight
        destinationViewController.tableView.contentOffset = CGPoint(x: 0, y: -offset)
      }
    }
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - PagingViewControllerSizeDelegate
//-------------------------------------------------------------------------------------------
extension HeaderTabViewController: PagingViewControllerSizeDelegate {
  func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
    guard let item = pagingItem as? PagingIndexItem else { return 0 }

    let insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 26)
    let attributes = [NSAttributedString.Key.font: pagingViewController.font]

    let rect = item.title.boundingRect(with: size,
                                       options: .usesLineFragmentOrigin,
                                       attributes: attributes,
                                       context: nil)

    let width = ceil(rect.width) + insets.left + insets.right
    return width
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension HeaderTabViewController: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Header 스크롤
    if scrollView.contentOffset.y < 0 {
      if let menuView = pagingViewController.view as? CustomPagingView {
        let height = max(0, abs(scrollView.contentOffset.y) - pagingViewController.options.menuHeight)
        menuView.headerHeightConstraint?.constant = height
      }
    }
    
    // Paging
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    
    if maximumOffset - currentOffset <= 10.0 {
      
//      let list = self.categoryList[self.index]
//      if ((list.current_page ?? 0) < (list.last_page ?? 0)) && self.isLoadingList {
//        self.isLoadingList = false
//        
//      }
      
    }
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
}
