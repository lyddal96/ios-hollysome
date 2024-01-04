//
//  TodoListPageViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit
import DZNEmptyDataSet
import Defaults

class TodoListPageViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var todoTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var parentsViewController: ScheduleViewController? = nil
  var planRequest = PlanModel()
  var planList = [PlanModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
//    self.notificationCenter.addObserver(self, selector: #selector(self.planUpdate), name: Notification.Name("PlanUpdate"), object: nil)
    self.todoTableView.registerCell(type: TodoCell.self)
    self.todoTableView.delegate = self
    self.todoTableView.dataSource = self
    self.todoTableView.emptyDataSetSource = self
    self.todoTableView.showsVerticalScrollIndicator = false
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.planUpdate()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 할일 리스트 API
  func planListAPI() {
    self.planRequest.house_idx = Defaults[.house_idx]
    self.planRequest.member_idx = Defaults[.member_idx]
    self.planRequest.setNextPage()
    
    APIRouter.shared.api(path: .plan_list, method: .post, parameters: self.planRequest.toJSON()) { response in
      if let planResponse = PlanModel(JSON: response), Tools.shared.isSuccessResponse(response: planResponse) {
        self.planRequest.total_page = planResponse.total_page
        self.isLoadingList = true
        
        if let data_array = planResponse.data_array, data_array.count > 0 {
          self.planList += data_array
        }
        
        self.todoTableView.reloadData()
      }
    }
  }
  
  @objc func planUpdate() {
    self.planRequest.resetPage()
    self.planList.removeAll()
    self.planListAPI()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension TodoListPageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let viewController = AddScheduleViewController.instantiate(storyboard: "Schedule")
    viewController.enrollType = .modify
    viewController.plan_idx = self.planList[indexPath.section].plan_idx ?? ""
    let destination = viewController.coverNavigationController()
    destination.hero.isEnabled = true
    destination.heroModalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.parentsViewController?.tabBarController?.present(destination, animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.todoTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.planRequest.isMore() {
          self.isLoadingList = false
          self.planListAPI()
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension TodoListPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.planList[section].plan_item_list?.count ?? 0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.planList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
    
//    cell.titleLabel.text = "할일 \(indexPath.row)"
    cell.setTodo(plan: self.planList[indexPath.section].plan_item_list?[indexPath.row] ?? PlanModel())
    cell.plan_idx = self.planList[indexPath.section].plan_idx ?? ""
    cell.parentsViewController = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView(x: 0, y: 0, w: self.parentsViewController?.view.frame.size.width ?? 0, h: 57)
    view.backgroundColor = .white
    let titleLabel = UILabel(x: 16, y: 16, w: (self.parentsViewController?.view.frame.size.width ?? 0) - 32, h: 25)
    titleLabel.text = self.planList[section].plan_name ?? ""
    titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    view.addSubview(titleLabel)
    
    let detailImageView = UIImageView(x: view.frame.size.width - 32, y: 20.3, w: 16, h: 16.3, image: UIImage(named: "detail_arrow")!)
    view.addSubview(detailImageView)
    
    view.addTapGesture { recognizer in
      let viewController = AddScheduleViewController.instantiate(storyboard: "Schedule")
      viewController.enrollType = .modify
      viewController.plan_idx = self.planList[section].plan_idx ?? ""
      let destination = viewController.coverNavigationController()
      destination.hero.isEnabled = true
      destination.heroModalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.parentsViewController?.tabBarController?.present(destination, animated: true)
    }
    
    return view
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 57
  }
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView(x: 0, y: 0, w: self.parentsViewController?.view.frame.size.width ?? 0, h: 16)
    view.backgroundColor = UIColor(named: "FAFAFC")
    
    return view
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    16
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

