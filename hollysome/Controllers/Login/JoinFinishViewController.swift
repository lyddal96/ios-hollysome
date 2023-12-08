//
//  JoinFinishViewController.swift
//  hollysome
//

import UIKit

class JoinFinishViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var toLoginButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
//    self.toLoginButton.addBorder(width: 1, color: Colors._EA474F)
//    self.toLoginButton.setCornerRadius(radius: 5)
  }
  
  override func initRequest() {
    super.initRequest()
  }

  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 로그인 화면으로
  /// - Parameter sender: 버튼
  @IBAction func toLoginTouched(sender: UIButton) {
    let destination = MainTabBarViewController.instantiate(storyboard: "Main")
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    window?.rootViewController = destination
  }
  
}
