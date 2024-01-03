//
//  CalendarPageViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit
import FSCalendar
import DZNEmptyDataSet
import Defaults

class CalendarPageViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var scheduleTableView: UITableView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var calendarWrapView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var parentsViewController: ScheduleViewController? = nil
  
  var calendarView = FSCalendar()
  var currentPage = Date()
  
  var selectedDate = Date()
  var calendarList = [PlanModel]()
  var planList = [PlanModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.scheduleTableView.registerCell(type: ScheduleCell.self)
    self.scheduleTableView.delegate = self
    self.scheduleTableView.dataSource = self
    self.scheduleTableView.emptyDataSetSource = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM.dd (E)"
    self.dateLabel.text = dateFormatter.string(from: Date())
    self.addCalendar()
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
  func addCalendar() {
    self.calendarView = FSCalendar(frame: CGRect(x: 10, y: 0, w: self.calendarWrapView.frame.width - 20, h: self.calendarWrapView.frame.height - 40))
    
    self.calendarView.collectionView.registerCell(type: FSDayCell.self)
    self.calendarView.delegate = self
    self.calendarView.dataSource = self
    
    self.calendarView.scrollDirection = .horizontal
    
    self.calendarView.allowsMultipleSelection = false
    self.calendarWrapView.addSubview(self.calendarView)
    self.calendarView.locale = Locale(identifier: "en")
    self.calendarView.calendarHeaderView = FSCalendarHeaderView()
    self.calendarView.headerHeight = 0
    self.calendarView.weekdayHeight = 20
    self.calendarView.rowHeight = 0
    self.calendarView.firstWeekday = 2
    self.monthLabel.text = "\(self.calendarView.currentPage.year)년 \(self.calendarView.currentPage.month)월"
    
    self.calendarView.today = nil
    self.calendarView.scope = .month
    self.calendarView.swipeToChooseGesture.isEnabled = true
    self.calendarView.placeholderType = .none

    
    self.calendarView.appearance.titleOffset = CGPoint(x: 0, y: 3)
    self.calendarView.appearance.weekdayTextColor = UIColor(named: "A3A7B6")
    self.calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    self.calendarView.appearance.borderDefaultColor = .clear
    self.calendarView.appearance.titlePlaceholderColor = .clear
    self.calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 14)
    self.calendarView.appearance.titleSelectionColor = .clear // 선택시 텍스트 컬러
    self.calendarView.appearance.selectionColor = UIColor.clear
    self.calendarView.select(Date())
    self.scheduleDateListAPI()
    self.scheduleDateMemberListAPI()
    self.calendarView.reloadData()
//    self.calendarView.scrollEnabled = false
  }
  
  
  private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    let dayCell = (cell as! FSDayCell)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월"
    let month = dateFormatter.string(from: date)
    dayCell.removeSelectionView()
    dayCell.circleView.isHidden = true
    dayCell.newView.isHidden = true
    if self.calendarList.filter({ $0.month == month }).count > 0 {
      if let data_array = self.calendarList.filter({ $0.month == month })[0].data_array {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dayCell.newView.isHidden = data_array.filter({ $0.schedule_date == dateFormatter.string(from: date)}).count == 0
      }
    }
    dayCell.circleView.setCornerRadius(radius: (8))
    dayCell.titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
    dayCell.titleLabel.textColor = UIColor(named: "222B45")
        
    if position == .current { // 현재달
      if self.calendarView.selectedDates.contains(date) {
        dayCell.circleView.isHidden = false
        dayCell.titleLabel.textColor = .white
      }
    } else {
      dayCell.titleLabel.textColor = UIColor(named: "A3A7B6")!
    }
    
    dayCell.setConfigureCell()
  }
  
  private func configureVisibleCells() {
    self.calendarView.visibleCells().forEach { (cell) in
      let date = self.calendarView.date(for: cell)
      let position = self.calendarView.monthPosition(for: cell)
      self.configure(cell: cell, for: date!, at: position)
    }
  }
  
  /// 달력리스트
  func scheduleDateListAPI() {
    let planRequest = PlanModel()
    planRequest.house_idx = Defaults[.house_idx]
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    planRequest.s_date = dateFormatter.string(from: self.calendarView.currentPage.startDateOfMonth)
    planRequest.e_date = dateFormatter.string(from: self.calendarView.currentPage.endDateOfMonth)
    
    log.debug("dates :::::::\(planRequest.s_date ?? "") ::::\(planRequest.e_date ?? "")")
    
    APIRouter.shared.api(path: .schedule_date_list, method: .post, parameters: planRequest.toJSON()) { response in
      if let planResponse = PlanModel(JSON: response), Tools.shared.isSuccessResponse(response: planResponse) {
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "yyyy년 MM월"
        let monthData = planResponse
        monthData.month = monthDateFormatter.string(from: self.calendarView.currentPage)
        self.calendarList.append(monthData)
        self.calendarView.reloadData()
      }
    }
  }
  
  /// 날짜별 일정 리스트
  func scheduleDateMemberListAPI() {
    let planRequest = PlanModel()
    planRequest.house_idx = Defaults[.house_idx]
    planRequest.member_idx = Defaults[.member_idx]
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    planRequest.today = dateFormatter.string(from: self.selectedDate)
    
    APIRouter.shared.api(path: .schedule_date_member_list, method: .post, parameters: planRequest.toJSON()) { response in
      if let planResponse = PlanModel(JSON: response), Tools.shared.isSuccessResponse(response: planResponse) {
        if let data_array = planResponse.data_array {
          self.planList = data_array
        } else {
          self.planList.removeAll()
        }
        
        self.scheduleTableView.reloadData()
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 이전 달
  /// - Parameter sender: 버튼
  @IBAction func prevButtonTouched(sender: UIButton) {
    self.currentPage = Calendar.current.date(byAdding: .month, value: -1, to: self.calendarView.currentPage)!
    self.calendarView.setCurrentPage(self.currentPage, animated: true)
    
  }
  
  /// 다음 달
  /// - Parameter sender: 버튼
  @IBAction func nextButtonTouched(sender: UIButton) {
    if !self.calendarView.currentPage.isThisMonth {
      self.currentPage = Calendar.current.date(byAdding: .month, value: 1, to: self.calendarView.currentPage)!
      self.calendarView.setCurrentPage(self.currentPage, animated: true)
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - FSCalendarDelegate
//-------------------------------------------------------------------------------------------
extension CalendarPageViewController: FSCalendarDelegate {
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    self.monthLabel.text = "\(self.calendarView.currentPage.year)년 \(self.calendarView.currentPage.month)월"
    self.currentPage = self.calendarView.currentPage
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월"
    let month = dateFormatter.string(from: self.calendarView.currentPage)
    if self.calendarList.filter({ $0.month == month}).count == 0 {
      self.scheduleDateListAPI()
    }
    
  }
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM.dd (E)"

    self.dateLabel.text = dateFormatter.string(from: date)
    self.selectedDate = date
    self.scheduleDateMemberListAPI()

    return true
  }
  
  func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    self.dateLabel.text = ""
    return true
  }
  
  
  func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    self.configureVisibleCells()
  }
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    self.configureVisibleCells()
  }
  
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - FSCalendarDataSource
//-------------------------------------------------------------------------------------------
extension CalendarPageViewController: FSCalendarDataSource {
  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    let cell = calendar.dequeueReusableCell(withIdentifier: "FSDayCell", for: date, at: position) as! FSDayCell
    cell.cellWidth = self.calendarView.frame.size.width / 7
    cell.setConfigureCell()
    return cell
  }
  func maximumDate(for calendar: FSCalendar) -> Date {
    return Date()
  }

  
  func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    self.configure(cell: cell, for: date, at: position)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension CalendarPageViewController: UITableViewDelegate {
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension CalendarPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.planList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
    let plan = self.planList[indexPath.row]
    cell.setPlan(plan: plan, isCalendar: true)
    
    
    return cell
  }
  
  
}


//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension CalendarPageViewController: DZNEmptyDataSetSource {
//  func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//    return -100
//  }
  
  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return 250
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "해당 날짜에 할 일이 없어요"
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
      NSAttributedString.Key.foregroundColor : UIColor(named: "C8CCD5")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

