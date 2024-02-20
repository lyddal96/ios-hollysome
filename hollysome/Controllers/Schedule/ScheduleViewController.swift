//
//  ScheduleViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/05/26.
//
//

import UIKit
import Parchment

class ScheduleViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var scheduleView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var pagingViewController = PagingViewController()
  var schedulePageViewController = SchedulePageViewController.instantiate(storyboard: "Schedule")
  var calendarPageViewController = CalendarPageViewController.instantiate(storyboard: "Schedule")
  var todoListPageViewController = TodoListPageViewController.instantiate(storyboard: "Schedule")
  
  var currentIndex = 0
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.pagingViewController = PagingViewController(viewControllers: [
      self.schedulePageViewController,
      self.calendarPageViewController,
      self.todoListPageViewController
    ])
    
    self.schedulePageViewController.parentsViewController = self
    self.calendarPageViewController.parentsViewController = self
    self.todoListPageViewController.parentsViewController = self
    //    let lengthCheckLabel = UILabel()
    //    lengthCheckLabel.font = UIFont(name: "Campton-BoldDEMO", size: 22)!
    self.pagingViewController.delegate = self
    self.pagingViewController.menuItemSize = .fixed(width: self.view.frame.size.width / 3, height: 50)
    self.pagingViewController.menuItemLabelSpacing = 0
    self.pagingViewController.indicatorColor = UIColor(named: "accent")!
    self.pagingViewController.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: 0, spacing: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    self.pagingViewController.menuInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    self.pagingViewController.borderColor = UIColor(named: "FFFFFF")!
    self.pagingViewController.borderOptions = PagingBorderOptions.visible(height: 1, zIndex: 0, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    self.pagingViewController.font = UIFont.systemFont(ofSize: 14)
    self.pagingViewController.textColor = UIColor(named: "C8CCD5")!
    self.pagingViewController.selectedFont = UIFont.boldSystemFont(ofSize: 14)
    self.pagingViewController.selectedTextColor = UIColor(named: "3A3A3C")!
    self.pagingViewController.collectionView.isScrollEnabled = false
    
    
    self.addChild(self.pagingViewController)
    self.scheduleView.addSubview(self.pagingViewController.view)
    self.scheduleView.constrainToEdges(self.pagingViewController.view)
    
    self.pagingViewController.didMove(toParent: self)
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
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}

//-------------------------------------------------------------------------------------------
// MARK: - PagingViewControllerDelegate
//-------------------------------------------------------------------------------------------
extension ScheduleViewController : PagingViewControllerDelegate {
  func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
    if transitionSuccessful {
      if self.pagingViewController.visibleItems.indexPath(for: pagingItem)?.row == 0 {
//        self.state = "feed"
      } else {
//        self.state = "follow"
      }
      
      guard let indexItem = pagingViewController.state.currentPagingItem as? PagingIndexItem else {
        return
      }
      self.currentIndex = indexItem.index
    }
  }
}
