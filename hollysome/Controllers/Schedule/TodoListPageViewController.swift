//
//  TodoListPageViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit
import DZNEmptyDataSet

class TodoListPageViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var todoTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var parentsViewController: ScheduleViewController? = nil
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.todoTableView.registerCell(type: ScheduleCell.self)
    self.todoTableView.delegate = self
    self.todoTableView.dataSource = self
    self.todoTableView.emptyDataSetSource = self
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
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension TodoListPageViewController: UITableViewDelegate {
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension TodoListPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
    
    cell.titleLabel.text = "할일 \(indexPath.row)"
    
    return cell
  }
  
  
}


//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension TodoListPageViewController: DZNEmptyDataSetSource {
//  func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//    return -100
//  }
  
  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -100
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "등록된 할 일이 없어요."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
      NSAttributedString.Key.foregroundColor : UIColor(named: "C8CCD5")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

