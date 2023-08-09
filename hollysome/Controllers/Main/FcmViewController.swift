//
//  ViewController.swift
//  hollysome
//
//  Created by rocateer on 08/01/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import UIKit
import Defaults

class FcmViewController: UIViewController {

  @IBOutlet weak var fcmKeyTextView: UITextView!
  
  var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.fcmKeyTextView.text = self.appDelegate.fcmKey != "" ? self.appDelegate.fcmKey : "fcm 키 발급 안되었습니다. 다시 실행해주세요."
  }
  
  @IBAction func restoreTouched(sender: UIButton) {
    self.fcmKeyTextView.text = self.appDelegate.fcmKey != "" ? self.appDelegate.fcmKey : "fcm 키 발급 안되었습니다. 다시 실행해주세요."
  }
}

