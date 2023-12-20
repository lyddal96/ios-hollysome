//
//  RegAccountBookViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/20/23.
//

import UIKit

class RegAccountBookViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var gasTextField: UITextField!
  @IBOutlet weak var waterTextField: UITextField!
  @IBOutlet weak var elecTextField: UITextField!
  @IBOutlet weak var etc1TextField: UITextField!
  @IBOutlet weak var etc1PriceTextField: UITextField!
  @IBOutlet weak var etc2TextField: UITextField!
  @IBOutlet weak var etc2PriceTextField: UITextField!
  @IBOutlet weak var etc3TextField: UITextField!
  @IBOutlet weak var etc3PriceTextField: UITextField!
  @IBOutlet weak var finishButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var modifyButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var enrollType = EnrollType.enroll
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
    
    self.gasTextField.setCornerRadius(radius: 4)
    self.gasTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.gasTextField.setTextPadding(15)
    self.waterTextField.setCornerRadius(radius: 4)
    self.waterTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.waterTextField.setTextPadding(15)
    self.elecTextField.setCornerRadius(radius: 4)
    self.elecTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.elecTextField.setTextPadding(15)
    self.etc1TextField.setCornerRadius(radius: 4)
    self.etc1TextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.etc1TextField.setTextPadding(15)
    self.etc1PriceTextField.setCornerRadius(radius: 4)
    self.etc1PriceTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.etc1PriceTextField.setTextPadding(15)
    self.etc2TextField.setCornerRadius(radius: 4)
    self.etc2TextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.etc2TextField.setTextPadding(15)
    self.etc2PriceTextField.setCornerRadius(radius: 4)
    self.etc2PriceTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.etc2PriceTextField.setTextPadding(15)
    self.etc3TextField.setCornerRadius(radius: 4)
    self.etc3TextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.etc3TextField.setTextPadding(15)
    self.etc3PriceTextField.setCornerRadius(radius: 4)
    self.etc3PriceTextField.addBorder(width: 1, color: UIColor(named: "C8CCD5")!)
    self.etc3PriceTextField.setTextPadding(15)
    self.finishButton.setCornerRadius(radius: 12)
    self.cancelButton.setCornerRadius(radius: 12)
    self.modifyButton.setCornerRadius(radius: 12)
    self.modifyButton.addBorder(width: 1, color: UIColor(named: "accent")!)
    
    self.finishButton.isHidden = self.enrollType == .modify
    self.modifyButton.isHidden = self.enrollType == .enroll
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY년 MM월"
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
  /// 작성완료
  /// - Parameter sender: 버튼
  @IBAction func finishButtonTouched(sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  /// 취소하기
  /// - Parameter sender: 버튼
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  /// 수정
  /// - Parameter sender: 버튼
  @IBAction func modifyButtonTouched(sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}
