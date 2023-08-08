//
//  SubTabViewController.swift
//  RocateerKit
//
//  Created by rocateer on 2020/01/09.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class SubTabViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var searchWrapView: UIView!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var date1Button: UIButton!
  @IBOutlet weak var date2Button: UIButton!
  @IBOutlet weak var date3Button: UIButton!
  @IBOutlet weak var date4Button: UIButton!
  @IBOutlet weak var startWrapView: UIView!
  @IBOutlet weak var startTextField: UITextField!
  @IBOutlet weak var endWrapView: UIView!
  @IBOutlet weak var endTextField: UITextField!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let startDatePickerView:UIDatePicker = UIDatePicker()
  let endDatePickerView:UIDatePicker = UIDatePicker()
  var startDate = ""
  var endDate = ""
  
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
    self.searchWrapView.addBorder(width: 1, color: UIColor(named: "DDDDDD")!)
    self.startWrapView.addBorder(width: 1, color: UIColor(named: "DDDDDD")!)
    self.endWrapView.addBorder(width: 1, color: UIColor(named: "DDDDDD")!)
    self.date1Button.addBorder(width: 1, color: UIColor(named: "333333")!)
    self.date2Button.addBorder(width: 1, color: UIColor(named: "333333")!)
    self.date3Button.addBorder(width: 1, color: UIColor(named: "333333")!)
    self.date4Button.addBorder(width: 1, color: UIColor(named: "333333")!)
    
    self.startTextField.tintColor = UIColor.clear
    self.endTextField.tintColor = UIColor.clear
    
    self.startDatePickerView.datePickerMode = .date
    self.startDatePickerView.addTarget(self, action: #selector(self.startDatePickerValueChanged), for: UIControl.Event.valueChanged)
    self.startTextField.inputView = self.startDatePickerView

    let calendar = Calendar.current
    let start_date = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    self.startDatePickerView.maximumDate = start_date
    
    self.endDatePickerView.datePickerMode = .date
    self.endDatePickerView.addTarget(self, action: #selector(self.endDatePickerValueChanged), for: UIControl.Event.valueChanged)
    self.endTextField.inputView = self.endDatePickerView
    self.endDatePickerView.minimumDate = Date()
    
    self.resetDate()
  }
  
  override func initRequest() {
    super.initRequest()
  }

  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 날짜 리셋
  func resetDate() {
    let calendar = Calendar.current
    let start_date = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    self.startTextField.text = start_date.toString(format: "yyyy.MM.dd")
    self.endTextField.text = Date().toString(format: "yyyy.MM.dd")
    self.startDate = start_date.toString(format: "yyyy-MM-dd")
    self.endDate = Date().toString(format: "yyyy-MM-dd")
  }
  
  /// 시작 날짜
  ///
  /// - Parameter sender: datePicker
  @objc func startDatePickerValueChanged(sender: UIDatePicker) {
    self.startTextField.text = sender.date.toString(format: "yyyy.MM.dd")
    self.startDate = sender.date.toString(format: "yyyy-MM-dd")
    
    let calendar = Calendar.current
    let end_date = calendar.date(byAdding: .day, value: 1, to: sender.date) ?? Date()
    self.endDatePickerView.minimumDate = end_date

  }
  
  
  /// 종료 날짜
  ///
  /// - Parameter sender: datePicker
  @objc func endDatePickerValueChanged(sender: UIDatePicker) {
    self.endTextField.text = sender.date.toString(format: "yyyy.MM.dd")
    self.endDate = sender.date.toString(format: "yyyy-MM-dd")
    
    let calendar = Calendar.current
    let start_date = calendar.date(byAdding: .day, value: -1, to: sender.date) ?? Date()
    self.startDatePickerView.maximumDate = start_date

  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 날짜 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func dateButtonsTouched(sender: UIButton) {
    let calendar = Calendar.current
    
    var value = 0
    switch sender {
    case self.date1Button:
      value = -1
      break
    case self.date2Button:
      value = -7
      break
    case self.date3Button:
      value = -30
      break
    case self.date4Button:
      value = -90
      break
    default:
      break
    }
    let date = calendar.date(byAdding: .day, value: value, to: Date()) ?? Date()
    self.startDate = date.toString(format: "yyyy-MM-dd")
    self.endDate = Date().toString(format: "yyyy-MM-dd")
    self.startTextField.text = date.toString(format: "yyyy.MM.dd")
    self.endTextField.text = Date().toString(format: "yyyy.MM.dd")
    
  }
  
  /// 검색
  /// - Parameter sender: 버튼
  @IBAction func searchButtonTouched(sender: UIButton) {
    
  }
  
}


