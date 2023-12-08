//
//  MultiSelectCalendarViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/06/05.
//
//

import UIKit
import FSCalendar

class MultiSelectCalendarViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var todayButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var selectButton: UIButton!
  @IBOutlet weak var calendarWrapView: UIView!
  @IBOutlet weak var fromLabel: UILabel!
  @IBOutlet weak var toLabel: UILabel!
  @IBOutlet weak var datesView: UIView!
  @IBOutlet weak var selectedView:UIView!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var viewLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var fromView: UIView!
  @IBOutlet weak var toView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var startDate: Date?
  var endDate: Date?
  var calendarView = FSCalendar()
  
  var selectType = 0
  
  var popupHeight: CGFloat = 0
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0
  
  var delegate: DateSelectDelegate?
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.datesView.setCornerRadius(radius: 10)
    self.selectedView.setCornerRadius(radius: 5)
    
    self.popupHeight = 370
    
    self.addCalendar()
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.fromView.addTapGesture { recognizer in
      self.selectType = 0
      if !self.endDate.isNil {
        UIView.animate(withDuration: 0.3) {
          self.viewLeftConstraint.constant = 5
          self.view.layoutIfNeeded()
        }
      }
    }
    
    self.toView.addTapGesture { recognizer in
      self.selectType = 1
      if !self.endDate.isNil {
        UIView.animate(withDuration: 0.3) {
          self.viewLeftConstraint.constant = self.datesView.frame.size.width / 2
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showCard()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  /// 카드 보이기
  private func showCard() {
    self.view.layoutIfNeeded()
    
    self.cardViewTopConstraint.constant = self.view.frame.size.height - (self.popupHeight + bottomPadding + self.statusHeight)
    
    let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })
    
    showCard.addAnimations({
      self.dimmerView.alpha = 0.7
    })
    
    showCard.startAnimation()
    
  }
  
  /// 카드 숨기면서 화면 닫기
  private func hideCardAndGoBack(type: Int?) {
    self.view.layoutIfNeeded()
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding
    
    let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })
    
    hideCard.addAnimations {
      self.dimmerView.alpha = 0.0
    }
    
    hideCard.addCompletion({ position in
      if position == .end {
        if(self.presentingViewController != nil) {
          self.dismiss(animated: false) {
            if type != nil {
              self.delegate?.multiSelectDelegate(startDate: self.startDate!, endDate: self.endDate!)
            }
          }
        }
      }
    })
    
    hideCard.startAnimation()
  }
  
  
  
  func addCalendar() {
    self.calendarView = FSCalendar(frame: CGRect(x: 0, y: 0, w: self.calendarWrapView.frame.width, h: self.calendarWrapView.frame.height))
    
    self.calendarView.collectionView.registerCell(type: FSDayCell.self)
    self.calendarView.delegate = self
    self.calendarView.dataSource = self
    self.monthLabel.text = "\(self.calendarView.currentPage.year)년 \(self.calendarView.currentPage.month)월"
    self.calendarView.locale = Locale(identifier: "ko")
    self.calendarView.scrollDirection = .vertical
    
    self.calendarView.allowsMultipleSelection = true
    
    self.calendarWrapView.addSubview(self.calendarView)
    
    self.calendarView.calendarHeaderView = FSCalendarHeaderView()
    self.calendarView.headerHeight = 0
    self.calendarView.weekdayHeight = 20 //(self.view.frame.size.width - 20) / 7
    log.debug(self.calendarView.calendarWeekdayView.weekdayLabels)
    self.calendarView.rowHeight = 0
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
      
//      log.debug("self.calendarView.selectedDates \(self.calendarView.selectedDates)")
//      log.debug("Date : \(date)")
      if self.calendarView.selectedDates.contains(date) {
        dayCell.titleLabel.textColor = .white
        dayCell.circleView.isHidden = false
        if date == self.startDate && self.endDate == nil {
          dayCell.circleView.isHidden = false
        } else if date == self.startDate {
          dayCell.circleView.isHidden = false
          dayCell.rightView.isHidden = false
        } else if date == self.endDate {
          dayCell.circleView.isHidden = false
          dayCell.leftView.isHidden = false
        } else {
          dayCell.leftView.isHidden = false
          dayCell.rightView.isHidden = false
        }
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
    guard let _ = self.startDate, let _ = self.endDate else {
      Tools.shared.showToastWithImage(message: "선택된 날짜가 없습니다.", image: UIImage(named: "ios_app_icon")!)
      return
    }
    self.hideCardAndGoBack(type: 0)
  }
  
  /// 취소
  /// - Parameter sender: 버튼
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.hideCardAndGoBack(type: nil)
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
extension MultiSelectCalendarViewController: FSCalendarDelegate {
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    self.monthLabel.text = "\(self.calendarView.currentPage.year)년 \(self.calendarView.currentPage.month)월"
  }
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    
    if self.startDate == nil {
      self.startDate = date
      self.endDate = nil
      self.fromLabel.text = dateFormatter.string(from: date)
      
      UIView.animate(withDuration: 0.3) {
        self.selectType = 1
        self.viewLeftConstraint.constant = self.datesView.frame.size.width / 2
        self.view.layoutIfNeeded()
      }
      return true
    } else if self.startDate != nil && self.endDate == nil {
      if date > self.startDate! {
        self.endDate = date
        self.toLabel.text = dateFormatter.string(from: date)
        selectDatesBetween(self.startDate!, and: self.endDate!, select: true)
        return true
      } else {
        self.endDate = self.startDate
        self.startDate = date
        self.fromLabel.text = dateFormatter.string(from: date)
        self.toLabel.text = dateFormatter.string(from: self.endDate!)
        selectDatesBetween(self.startDate!, and: self.endDate!, select: true)
        return true
      }
    } else if self.startDate != nil && self.endDate != nil {
      if self.endDate! < date && self.selectType == 1 {
        self.toLabel.text = dateFormatter.string(from: date)
        self.endDate = date
        self.selectDatesBetween(self.startDate!, and: self.endDate!, select: true)
      } else if selectType == 0 && self.endDate! > date {
        self.fromLabel.text = dateFormatter.string(from: date)
        self.startDate = date
        self.selectDatesBetween(self.startDate!, and: self.endDate!, select: true)
        UIView.animate(withDuration: 0.3) {
          self.selectType = 1
          self.viewLeftConstraint.constant = self.datesView.frame.size.width / 2
          self.view.layoutIfNeeded()
        }
      } else {
        self.selectDatesBetween(self.startDate!, and: self.endDate!, select: false)
        self.startDate = date
        self.fromLabel.text = dateFormatter.string(from: date)
        self.toLabel.text = ""
        self.endDate = nil
        
        return true
      }
      return true
    }
    return false
  }
  
  func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    if self.startDate != nil && self.endDate == nil {
      if date == self.startDate {
        self.startDate = nil
        return true
      }
    } else if calendar.selectedDates.contains(date) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy/MM/dd"
      self.selectDatesBetween(self.startDate!, and: self.endDate!, select: false)
      self.calendarView.select(date)
      self.startDate = date
      self.fromLabel.text = dateFormatter.string(from: date)
      self.toLabel.text = ""
      self.endDate = nil
      self.calendarView.reloadData()
    }
    return false
  }
  
  func selectDatesBetween(_ startDate: Date, and endDate: Date, select: Bool) {
    let calendar = Calendar.current
    var currentDate = startDate
    if select == false {
      self.calendarView.deselect(startDate)
    }
    while currentDate <= endDate {
      calendar.enumerateDates(startingAfter: currentDate, matching: .init(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) { (date, _, stop) in
        if let date = date, date <= endDate {
          if select == true {
            self.calendarView.select(date)
          } else {
            self.calendarView.deselect(date)
          }
          
        } else {
          stop = true
        }
      }
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
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
extension MultiSelectCalendarViewController: FSCalendarDataSource {
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
