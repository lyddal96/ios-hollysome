//
//  SchedulePageViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit
import Defaults
import DZNEmptyDataSet

class SchedulePageViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var dayCollectionView: UICollectionView!
  @IBOutlet weak var scheduleCntLabel: UILabel!
  @IBOutlet weak var scheduleTableView: UITableView!
  @IBOutlet weak var addButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var parentsViewController: ScheduleViewController? = nil
  var selectedDate = Date()
  
  var scheduleList = 0
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dayCollectionView.registerCell(type: DailyCell.self)
    self.dayCollectionView.delegate = self
    self.dayCollectionView.dataSource = self
    
    self.scheduleTableView.registerCell(type: ScheduleCell.self)
    self.scheduleTableView.dataSource = self
    self.scheduleTableView.delegate = self
    self.scheduleTableView.emptyDataSetSource = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M월 d일 EEEE"
    self.dateLabel.text = dateFormatter.string(from: self.selectedDate)
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
  /// 일정 추가하기
  /// - Parameter sender: 버튼
  @IBAction func addButtonTouched(sender: UIButton) {
    let destination = AddScheduleViewController.instantiate(storyboard: "Schedule").coverNavigationController()
    destination.modalPresentationStyle = .fullScreen
    destination.hero.isEnabled = true
    destination.heroModalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    self.parentsViewController?.present(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension SchedulePageViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let date = Calendar.current.date(byAdding: .day, value: indexPath.row, to: Date())!
    self.selectedDate = date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M월 d일 EEEE"
    self.dateLabel.text = dateFormatter.string(from: self.selectedDate)
    self.dayCollectionView.reloadData()
    
    self.scheduleList = indexPath.row
    self.scheduleTableView.reloadData()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension SchedulePageViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 48, height: 85)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension SchedulePageViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 7
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath) as! DailyCell
    
    let date = Calendar.current.date(byAdding: .day, value: indexPath.row, to: Date())!
    cell.setDate(date: date, isSelected: Calendar.current.isDate(date, inSameDayAs: self.selectedDate))
    
    return cell
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension SchedulePageViewController: UITableViewDelegate {
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension SchedulePageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.scheduleList
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
extension SchedulePageViewController: DZNEmptyDataSetSource {
//  func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//    return -100
//  }
  
  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return 100
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

