//
//  TermsListViewController.swift
//  hollysome
//
//  Created by 이승아 on 2/13/24.
//

import UIKit

class TermsListViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var terms1Button: UIButton!
  @IBOutlet weak var terms2Button: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

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
    
    self.terms1Button.setCornerRadius(radius: 8)
    self.terms2Button.setCornerRadius(radius: 8)
    
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
  /// 이용약관 상세
  /// - Parameter sender: 버튼
  @IBAction func termsButtonTouched(sender: UIButton) {
    let destination = WebViewController.instantiate(storyboard: "Commons")
    switch sender.tag {
    case 0:
      destination.webType = .terms0
      break
    case 1:
      destination.webType = .terms1
      break
    case 2:
      destination.webType = .terms2
      break
    case 3:
      destination.webType = .terms3
      break
    default:
      break
    }
    self.navigationController?.pushViewController(destination, animated: true)
  }
}
