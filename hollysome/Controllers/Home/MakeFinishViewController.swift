//
//  MakeFinishViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/14/23.
//

import UIKit

class MakeFinishViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var houseCodeLabel: UILabel!
  @IBOutlet weak var codeView: UIView!
  @IBOutlet weak var inviteButton: UIButton!
  @IBOutlet weak var laterButton: UIButton!
  @IBOutlet weak var copyButton: UIButton!
  @IBOutlet weak var finishView: UIView!
  @IBOutlet weak var homeButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var house_code: String = ""
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
    
    self.codeView.setCornerRadius(radius: 12)
    self.inviteButton.setCornerRadius(radius: 12)
    self.laterButton.setCornerRadius(radius: 12)
    self.homeButton.setCornerRadius(radius: 12)
    self.laterButton.addBorder(width: 1, color: UIColor(named: "accent")!)
    
    self.houseCodeLabel.text = self.house_code
    self.finishView.isHidden = true
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
  /// 초대하기
  /// - Parameter sender: 버튼
  @IBAction func inviteButtonTouched(sender: UIButton) {
    
  }
  
  /// 다음에 초대하기
  /// - Parameter sender: 버튼
  @IBAction func laterButtonTouched(sender: UIButton) {
    self.finishView.isHidden = false
  }
  
  /// 홈으로
  /// - Parameter sender: 버튼
  @IBAction func homeButtonTouched(sender: UIButton) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  /// 복사
  /// - Parameter sender: 버튼
  @IBAction func copyButtonTouched(sender: UIButton) {
    Tools.shared.copyToClipboard(text: self.house_code)
  }
}
