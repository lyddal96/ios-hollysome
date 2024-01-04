//
//  TodayScheduleViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
import ExpyTableView
import Defaults
import DZNEmptyDataSet

class TodayScheduleViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var scheduleTableView: ExpyTableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var planList = [PlanModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.scheduleTableView.registerCell(type: ScheduleTitleCell.self)
    self.scheduleTableView.registerCell(type: ScheduleExpandCell.self)
    self.scheduleTableView.dataSource = self
    self.scheduleTableView.delegate = self
    self.scheduleTableView.emptyDataSetSource = self
    self.scheduleTableView.rowHeight = UITableView.automaticDimension
    self.scheduleTableView.expandingAnimation = .fade
    self.scheduleTableView.collapsingAnimation = .fade
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM월 dd일 (E)"
    self.navigationItem.title = dateFormatter.string(from: Date())
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.todayScheduleListAPI()
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 오늘 할일 리스트 API
  func todayScheduleListAPI() {
    let planRequest = PlanModel()
    planRequest.member_idx = Defaults[.member_idx]
    planRequest.house_idx = Defaults[.house_idx]
    
    APIRouter.shared.api(path: .today_schedule_list, method: .post, parameters: planRequest.toJSON()) { response in
      if let planResponse = PlanModel(JSON: response), Tools.shared.isSuccessResponse(response: planResponse) {
        if let data_array = planResponse.data_array, data_array.count > 0 {
          self.planList = data_array
        }
        self.scheduleTableView.reloadData()
      }
    }
  }
  
  /// 나의 할일 완료API
  func todayScheduleEndAPI(schedule_idx: String, plan_idx: String) {
    let planRequest = PlanModel()
    planRequest.schedule_idx = schedule_idx
    
    APIRouter.shared.api(path: .today_schedule_end, method: .post, parameters: planRequest.toJSON()) { response in
      if let planResponse = PlanModel(JSON: response), Tools.shared.isSuccessResponse(response: planResponse) {
        if let index = self.planList.firstIndex(where: { $0.plan_idx == plan_idx }) {
          if let scheduleIndex = self.planList[index].schedule_item_member_list?.firstIndex(where: { $0.schedule_idx == schedule_idx }) {
            self.planList[index].schedule_item_member_list?[scheduleIndex].schedule_yn = "Y"
          }
        }
        
        self.scheduleTableView.reloadData()
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}

//-------------------------------------------------------------------------------------------
  // MARK: - ExpyTableViewDataSource
  //-------------------------------------------------------------------------------------------
extension TodayScheduleViewController: ExpyTableViewDataSource {
  func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
    return true
  }
  
  func canExpand(section: Int, inTableView tableView: ExpyTableView) -> Bool {
    return false
  }
  
  // 상위데이터
  func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTitleCell") as! ScheduleTitleCell
    let plan = self.planList[section]
    cell.titleLabel.text = plan.plan_name ?? ""
    cell.layoutMargins = UIEdgeInsets.zero
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.planList.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    if section == 0 || section == 4 || section == 5 || section == 6 {
//      return 1
//    } else {
//      return 2
//    }
    let plan = self.planList[section]
    
    return (plan.schedule_item_member_list?.count ?? 0) + 1
  }
  
 
  
  // 하위 데이터
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleExpandCell", for: indexPath) as! ScheduleExpandCell
    let plan = self.planList[indexPath.section]
    let mate = plan.schedule_item_member_list?[indexPath.row - 1] ?? PlanModel()
    cell.parentsViewController = self
    cell.shapeImageView.image = UIImage(named: "\(Constants.SHAPE_LIST[mate.member_role1?.toInt() ?? 0])71")
    cell.faceImageView.image = UIImage(named: "face\(mate.member_role2?.toInt() ?? 0)")
    cell.colorView.backgroundColor = UIColor(named: "profile\(mate.member_role3?.toInt() ?? 0)")
    cell.nameLabel.text = mate.member_nickname ?? ""
    cell.doneButton.isHidden = mate.member_idx != Defaults[.member_idx]
    cell.pokeButton.isHidden = mate.member_idx == Defaults[.member_idx]
    cell.doneButton.isEnabled = mate.schedule_yn != "Y"
    cell.pokeButton.isEnabled = mate.schedule_yn != "Y"
    cell.avatarView.addBorder(width: 1, color: UIColor(named: "\(mate.member_idx == Defaults[.member_idx] ? "accent" : "FFFFFF")")!)
    cell.checkImageView.isHidden = mate.schedule_yn != "Y"
    if indexPath.row == plan.schedule_item_member_list?.count ?? 0 {
      cell.roundView.roundCorners(cornerRadius: 12, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    } else {
      cell.roundView.roundCorners(cornerRadius: 0, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    
    // 완료
    cell.doneButton.addTapGesture { recognizer in
      AJAlertController.initialization().showAlert(astrTitle: "\(plan.plan_name ?? "") 을(를) 완료하셨나요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "완료") { position, title in
        if position == 1 {
          // 완료
          self.todayScheduleEndAPI(schedule_idx: mate.schedule_idx ?? "", plan_idx: plan.plan_idx ?? "")
        }
      }
    }
    
    // 콕찌르기
    cell.pokeButton.addTapGesture { recognizer in
      let destination = PokeViewController.instantiate(storyboard: "Home")
      destination.member = mate
      destination.schedule_name = plan.plan_name ?? ""
      destination.modalPresentationStyle = .overCurrentContext
      destination.modalTransitionStyle = .crossDissolve
      self.present(destination, animated: true, completion:  nil)
    }
    
    return cell
  }

}

//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDelegate
//-------------------------------------------------------------------------------------------
extension TodayScheduleViewController: ExpyTableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
//
//    if indexPath.section != self.expanted {
//      if let expanted = expanted {
//        self.weightTableView.collapse(expanted)
//      }
//    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
    
    switch state {
    case .willExpand:
      break
    case .willCollapse:
      break
    case .didExpand:
//      self.expanted = section
      break
    case .didCollapse:
      break
    }
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension TodayScheduleViewController: DZNEmptyDataSetSource {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "오늘은 하우스 일정이 없어요."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor : UIColor(named: "C8CCD5")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

