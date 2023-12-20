//
//  AddScheduleViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit
import DZNEmptyDataSet

class AddScheduleViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var timeTextField: UITextField!
  @IBOutlet weak var noTimeButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var enrollButton: UIButton!
  @IBOutlet weak var scheduleTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var enrollType = EnrollType.enroll
  
  var timePickerView = UIPickerView()
  var timeList = ["0시", "1시", "2시", "3시", "4시", "5시", "6시", "7시", "8시", "9시", "10시", "11시", "12시", "13시", "14시", "15시", "16시", "17시", "18시", "19시", "20시", "21시", "22시", "23시"]
  var scheduleList = [HouseModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.timeTextField.setInputViewPicker(picker: self.timePickerView, target: self, selector: #selector(tapPickerDone))
    self.timePickerView.delegate = self
    
    self.scheduleTableView.registerCell(type: AddScheduleCell.self)
    self.scheduleTableView.dataSource = self
    self.scheduleTableView.delegate = self
    self.scheduleTableView.emptyDataSetSource = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    switch(self.enrollType) {
    case .enroll:
      self.navigationItem.title = "할 일 추가"
      self.addButton.setTitle("추가", for: .normal)
    case .modify:
      self.navigationItem.title = "할 일 수정"
      self.addButton.setTitle("수정", for: .normal)
    }
    
    self.titleTextField.setCornerRadius(radius: 4)
    self.timeTextField.setCornerRadius(radius: 4)
    self.enrollButton.setCornerRadius(radius: 12)
    self.addButton.setCornerRadius(radius: 15.5)
    
    self.titleTextField.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
    self.timeTextField.addBorder(width: 1, color: UIColor(named: "E4E6EB")!)
    self.titleTextField.setTextPadding(16)
    self.timeTextField.setTextPadding(16)
    
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
  
  // Picker Done
  @objc func tapPickerDone(sender: UIBarButtonItem) {
    if let picker = self.timeTextField.inputView as? UIPickerView, self.timeTextField.isEditing {
//      self.gameRequest.game_match_time = "\(picker.selectedRow(inComponent: 0) + 1)"
      self.timeTextField.text = "\(self.timeList[picker.selectedRow(inComponent: 0)])"
    }
    
    self.view.endEditing(true)
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 등록
  /// - Parameter sender: 버튼
  @IBAction func enrollButtonTouched(sender: UIButton) {
    self.dismiss(animated: true)
  }
  
  /// 추가하기
  /// - Parameter sender: 버튼
  @IBAction func addButtonTouched(sender: UIButton) {
    let destination = AddSchedulePopupViewController.instantiate(storyboard: "Schedule")
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
  
  /// 지정하지 않을래요.
  /// - Parameter sender: 버튼
  @IBAction func noTimeButtonTouched(sender: UIButton) {
    self.noTimeButton.isSelected = !self.noTimeButton.isSelected
    self.timeTextField.isEnabled = !self.noTimeButton.isSelected
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIPickerViewDelegate
//-------------------------------------------------------------------------------------------
extension AddScheduleViewController: UIPickerViewDelegate {
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UIPickerViewDataSource
//-------------------------------------------------------------------------------------------
extension AddScheduleViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.timeList.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.timeList[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension AddScheduleViewController: UITableViewDelegate {
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension AddScheduleViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.scheduleList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddScheduleCell", for: indexPath) as! AddScheduleCell
    cell.indexPath = indexPath
    
    cell.deleteButton.addTapGesture { recognizer in
      self.scheduleList.remove(at: indexPath.row)
      self.scheduleTableView.reloadData()
    }
    
    return cell
  }
  
  
}



//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension AddScheduleViewController: DZNEmptyDataSetSource {
//  func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//    return -100
//  }
  
  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return 50
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "일정을 추가해주세요."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor : UIColor(named: "C8CCD5")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - ScheduleAddDelegate
//-------------------------------------------------------------------------------------------
extension AddScheduleViewController: ScheduleAddDelegate {
  func scheduleAddDelegate() {
    self.scheduleList.append(HouseModel())
    self.scheduleTableView.reloadData()
  }
}