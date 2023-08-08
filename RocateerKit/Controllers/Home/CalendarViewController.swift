//
//  CalendarViewController.swift
//  RocateerKit
//
//  Created by 이승아 on 2023/05/31.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit
import FSCalendar

protocol DateSelectDelegate {
  func singleSelectDelegate(date: Date)
  func multiSelectDelegate(startDate: Date, endDate: Date)
}

class CalendarViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var calendarWrapView: UIView!
  @IBOutlet weak var selectedView: UIView!
  @IBOutlet weak var selectedLabel: UILabel!
  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var selectButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var goToTodayButton: UIButton!
  @IBOutlet weak var monthLabel: UILabel!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  
  var calendarView = FSCalendar()
  var delegate: DateSelectDelegate?
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
    
    self.popupView.setCornerRadius(radius: 15)
    self.selectedView.setCornerRadius(radius: 10)
  }
  
  override func initRequest() {
    super.initRequest()
//    self.setupCalendarView()
    self.addCalendar()
    
    
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
    
    self.calendarView.scrollDirection = .vertical
    
    self.calendarView.allowsMultipleSelection = false
    
    self.calendarWrapView.addSubview(self.calendarView)
    self.calendarView.locale = Locale(identifier: "ko")
    self.calendarView.calendarHeaderView = FSCalendarHeaderView()
    self.calendarView.headerHeight = 0
    self.calendarView.weekdayHeight = 20
    self.calendarView.rowHeight = 0
    
    self.monthLabel.text = "\(self.calendarView.currentPage.year)년 \(self.calendarView.currentPage.month)월"
    //    self.calendar.appearance.heig
    
    self.calendarView.today = nil
    self.calendarView.scope = .month
    self.calendarView.swipeToChooseGesture.isEnabled = true
    self.calendarView.placeholderType = .none

    
    self.calendarView.appearance.titleOffset = CGPoint(x: 0, y: 3)
    self.calendarView.appearance.weekdayTextColor = UIColor(named: "4F4E60")
    self.calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    self.calendarView.appearance.borderDefaultColor = .clear
    self.calendarView.appearance.titlePlaceholderColor = UIColor(named: "CCCCCC")!
    self.calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 14)
    self.calendarView.appearance.titleSelectionColor = UIColor(named: "9F9EB0") // 선택시 텍스트 컬러
    self.calendarView.appearance.selectionColor = UIColor.clear
    
    self.calendarView.reloadData()
  }
  
  
  private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    let dayCell = (cell as! FSDayCell)
    dayCell.removeSelectionView()
    dayCell.leftView.isHidden = true
    dayCell.rightView.isHidden = true
    dayCell.circleView.isHidden = true
    
    dayCell.circleView.setCornerRadius(radius: ((self.calendarView.frame.size.width / 7) - 20) / 2)
    dayCell.titleLabel.font = UIFont.systemFont(ofSize: 12)
    dayCell.titleLabel.textColor = UIColor(named: "9F9EB0")
    if position == .current { // 현재달
      if self.calendarView.selectedDates.contains(date) {
        dayCell.circleView.isHidden = false
        dayCell.titleLabel.textColor = .white
      }
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM"
      let month = dateFormatter.string(from: date)
      
    } else {
      dayCell.titleLabel.textColor = UIColor.clear
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
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  
  /// 선택
  /// - Parameter sender: 버튼
  @IBAction func selectButtonTouched(sender:UIButton) {
    guard self.calendarView.selectedDates.count == 1 else {
      Tools.shared.showToastWithImage(message: "선택된 날짜가 없습니다.", image: UIImage(named: "ios_app_icon")!)
      return
    }
    self.dismiss(animated: true) {
      self.delegate?.singleSelectDelegate(date: self.calendarView.selectedDates[0])
    }
  }
  
  /// 취소
  /// - Parameter sender: 버튼
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.dismiss(animated: true)
  }
  
  /// 오늘
  /// - Parameter sender: 버튼
  @IBAction func todayButtonTouched(sender: UIButton) {
    
    if self.calendarView.selectedDates.contains(where: { $0.isToday}) {
      self.calendarView.select(Date(), scrollToDate: true)
    } else {
      self.calendarView.select(Date(), scrollToDate: true)
      self.calendarView.deselect(Date())
    }
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - FSCalendarDelegate
//-------------------------------------------------------------------------------------------
extension CalendarViewController: FSCalendarDelegate {
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    self.monthLabel.text = "\(self.calendarView.currentPage.year)년 \(self.calendarView.currentPage.month)월"
  }
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"

    self.selectedLabel.text = dateFormatter.string(from: date)
    return true
  }
  
  func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    self.selectedLabel.text = ""
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
extension CalendarViewController: FSCalendarDataSource {
  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    let cell = calendar.dequeueReusableCell(withIdentifier: "FSDayCell", for: date, at: position) as! FSDayCell
    cell.cellWidth = self.calendarView.frame.size.width / 7
    cell.setConfigureCell()
    return cell
  }
  
  func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    self.configure(cell: cell, for: date, at: position)
  }
}
