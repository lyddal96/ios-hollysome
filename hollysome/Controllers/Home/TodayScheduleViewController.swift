//
//  TodayScheduleViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/15/23.
//

import UIKit
import ExpyTableView

class TodayScheduleViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var scheduleTableView: ExpyTableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.scheduleTableView.registerCell(type: ScheduleTitleCell.self)
    self.scheduleTableView.registerCell(type: ScheduleExpandCell.self)
    self.scheduleTableView.dataSource = self
    self.scheduleTableView.delegate = self
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
    cell.titleLabel.text = "빨래하기"
    cell.layoutMargins = UIEdgeInsets.zero
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    if section == 0 || section == 4 || section == 5 || section == 6 {
//      return 1
//    } else {
//      return 2
//    }
    
    if section == 0 {
      return 2
    } else {
      return 3
    }
  }
  
 
  
  // 하위 데이터
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleExpandCell", for: indexPath) as! ScheduleExpandCell
    cell.parentsViewController = self
    cell.setMate(index: indexPath)
//    cell.setStateBar(indexPath: indexPath,data: self.healthData)
    if (indexPath.row == 1 && indexPath.section == 0) || (indexPath.row == 2 && indexPath.section != 0) {
      cell.roundView.roundCorners(cornerRadius: 12, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    } else {
      cell.roundView.roundCorners(cornerRadius: 0, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    
    // 완료
    cell.doneButton.addTapGesture { recognizer in
      AJAlertController.initialization().showAlert(astrTitle: "빨래하기 을(를) 완료하셨나요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "완료") { position, title in
        if position == 1 {
          // 완료
        }
      }
    }
    
    // 콕찌르기
    cell.pokeButton.addTapGesture { recognizer in
      let destination = PokeViewController.instantiate(storyboard: "Home")
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


