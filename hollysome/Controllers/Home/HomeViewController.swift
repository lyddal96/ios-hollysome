//
//  HomeViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/05/26.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit
import Defaults

class HomeViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var noHouseView: UIView!
  @IBOutlet weak var houseView: UIView!
  @IBOutlet weak var alarmBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var logoView: UIView!
  @IBOutlet weak var makeHouseButton: UIButton!
  @IBOutlet weak var inputCodeView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.noHouseView.addTapGesture { recognizer in
      Defaults[.house_code] = Defaults[.house_code] == nil ? "1111" : nil
      
      self.setTitleBar()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
   
    
    self.setTitleBar()
    self.inputCodeView.setCornerRadius(radius: 8)
    self.makeHouseButton.setCornerRadius(radius: 12)
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.inputCodeView.addTapGesture { recognizer in
      // 하우스 코드 입력하기
      let destination = IntputHouseCodeViewController.instantiate(storyboard: "Home")
      destination.modalTransitionStyle = .crossDissolve
      destination.modalPresentationStyle = .overCurrentContext
      destination.hidesBottomBarWhenPushed = true
//      self.present(destination, animated: false, completion: nil)
      self.tabBarController?.present(destination, animated: true)
    }
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  func setTitleBar() {
    self.logoView.isHidden = Defaults[.house_code] == nil
    self.alarmBarButtonItem.isEnabled = Defaults[.house_code] != nil
    self.alarmBarButtonItem.image = Defaults[.house_code] == nil ? nil : UIImage(named: "bell")
    
    self.navigationItem.title = Defaults[.house_code] == nil ? "하우스 만들기" : ""
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 하우스 만들기
  /// - Parameter sender: 버튼
  @IBAction func makeHouseButtonTouched(sender: UIButton) {
    
  }
}
