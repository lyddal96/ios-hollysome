//
//  BottomAJAlertController.swift
//  bike
//

import UIKit
import Foundation
import EZSwiftExtensions

class BottomAJAlertController: UIViewController {
  
  // MARK:- Private Properties
  private var strAlertTitle = ""
  private var strAlertText = String()
  private var btnCancelTitle:String?
  private var btnOtherTitle:String?
  private var attributedText: NSAttributedString?
//  private let btnOtherColor  = UIColor.white
//  private let btnCancelColor = UIColor.white
  
  // MARK:- Public Properties
  @IBOutlet var viewAlert: UIView!
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var lblAlertText: UILabel?
  @IBOutlet var btnCancel: UIButton!
  @IBOutlet var btnOther: UIButton!
  @IBOutlet var btnOK: UIButton!
  
  /// AlertController Completion handler
  typealias alertCompletionBlock = ((Int, String) -> Void)?
  private var block : alertCompletionBlock?
  var alertViewHidden = false
  // MARK:- BottomAJAlertController Initialization
  
  /**
   Creates a instance for using BottomAJAlertController
   - returns: BottomAJAlertController
   */
  static func initialization() -> BottomAJAlertController {
    let alertController = BottomAJAlertController(nibName: "BottomAJAlertController", bundle: nil)
    return alertController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBottomAJAlertController()
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }
  
  // MARK:- BottomAJAlertController Private Functions
  
  /// Inital View Setup
  private func setupBottomAJAlertController() {
    preferredAlertWidth()
    
    viewAlert.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
    viewAlert.layer.shadowColor   = UIColor(white: 0.0, alpha: 1.0).cgColor
    viewAlert.layer.shadowOpacity = 0.3
    self.viewAlert.setCornerRadius(radius: 22)
    
    lblTitle.text   = strAlertTitle
    lblAlertText?.text   = strAlertText
    if self.attributedText != nil {
      lblAlertText?.attributedText = self.attributedText
    }
    
    
    if let aCancelTitle = btnCancelTitle {
      btnCancel.setCornerRadius(radius: 8)
      btnCancel.setTitle(aCancelTitle, for: .normal)
//      btnCancel.addBorder(width: 1, color: UIColor(named: "accent")!)
      btnOK.setTitle(nil, for: .normal)
      btnOK.setCornerRadius(radius: 8)
    } else {
      btnCancel.isHidden  = true
    }
    
    if self.alertViewHidden {
      //      self.alertImageView.isHidden = true
    }
    
    if let aOtherTitle = btnOtherTitle {
      btnOther.setTitle(aOtherTitle, for: .normal)
      btnOther.setCornerRadius(radius: 8)
      btnOK.setTitle(nil, for: .normal)
      btnOK.setCornerRadius(radius: 8)
      btnOther.setCornerRadius(radius: 8)
    } else {
      btnOther.isHidden  = true
    }
    
    if btnOK.title(for: .normal) != nil {
      btnOK.setCornerRadius(radius: 8)
    } else {
      btnOK.isHidden  = true
    }

    self.viewAlert.clipsToBounds = true
    self.viewAlert.layer.cornerRadius = 22
    self.viewAlert.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
  }
  
  /// Setup different widths for iPad and iPhone
  private func preferredAlertWidth() {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone: break
    case .pad: break
    case .mac : break
    case .unspecified: break
    case .tv: break
    case .carPlay: break
    @unknown default: break
    }
  }
  
  /// Create and Configure Alert Controller
  private func configure(title: String, message:String, btnCancelTitle:String?, btnOtherTitle:String?) {
    self.strAlertTitle    = title
    self.strAlertText     = message
    self.btnCancelTitle   = btnCancelTitle
    self.btnOtherTitle    = btnOtherTitle
  }
  private func configureAttribute(title: String, message:NSAttributedString, btnCancelTitle:String?, btnOtherTitle:String?) {
    self.strAlertTitle    = title
    self.attributedText     = message
    self.btnCancelTitle   = btnCancelTitle
    self.btnOtherTitle    = btnOtherTitle
  }
  
  /// Show Alert Controller
  private func show() {
    let sceneDelegate = UIApplication.shared.connectedScenes .first!.delegate as! SceneDelegate
    if let window = sceneDelegate.window, let rootViewController = window.rootViewController {
      
      var topViewController = rootViewController
      while topViewController.presentedViewController != nil {
        topViewController = topViewController.presentedViewController!
      }
      
      topViewController.addChild(self)
      topViewController.view.addSubview(view)
      viewWillAppear(true)
      didMove(toParent: topViewController)
      view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      view.alpha = 0.0
      view.frame = topViewController.view.bounds
      
      viewAlert.alpha     = 0.0
      UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
        self.view.alpha = 1.0
      }, completion: nil)
      
      viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
      UIView.animate(withDuration: 0.2 , delay: 0.1, options: .curveEaseOut, animations: { () -> Void in
        self.viewAlert.alpha = 1.0
        self.viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.viewAlert.center.y -= self.view.frame.height
      }, completion: nil)
      
    }
  }
  
  /// Hide Alert Controller
//  private func hide() -> Bool {
  private func hide(closure: @escaping () -> ()) {
    self.view.endEditing(true)
    viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    
    UIView.animate(withDuration: 0.25 , delay: 0.1, options: .curveEaseIn, animations: { () -> Void in
//      self.viewAlert.alpha = 0.0
      self.viewAlert.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)

    }) { (completed) -> Void in
      
    }
    
    UIView.animate(withDuration: 0.25, delay: 0.05, options: .curveEaseIn, animations: { () -> Void in
      self.view.alpha = 0.0
    }) { (completed) -> Void in
      self.view.removeFromSuperview()
      self.removeFromParent()
      closure()
    }
    
//    return true
  }
  
  // MARK:- UIButton Clicks
  @IBAction func btnCancelTapped(sender: UIButton) {
//    var _ = hide()
//    block!!(0,btnCancelTitle!)
    self.hide {
      self.block!!(0,self.btnCancelTitle!)
    }
  }
  
  @IBAction func btnOtherTapped(sender: UIButton) {
//    var _ = hide()
//    block!!(1,btnOtherTitle!)
    self.hide {
      self.block!!(1,self.btnOtherTitle!)
    }
  }
  
  @IBAction func btnOkTapped(sender: UIButton){
//    var _ = hide()
    
    self.hide {
      self.block!!(0,"확인")
    }
  }
  
  /// Hide Alert Controller on background tap
  @objc func backgroundViewTapped(sender:AnyObject) {
    // hide()
  }
  
  // MARK:- AJAlert Functions
  /**
   Display an Alert
   
   - parameter aStrMessage:    Message to display in Alert
   - parameter aCancelBtnTitle: Cancel button title
   - parameter aOtherBtnTitle: Other button title
   - parameter otherButtonArr: Array of other button title
   - parameter completion:     Completion block. Other Button Index - 1 and Cancel Button Index - 0
   */
  
  public func showAlert(astrTitle: String, aStrMessage: String, aCancelBtnTitle: String?, aOtherBtnTitle: String?, completion : alertCompletionBlock) {
    configure(title: astrTitle, message: aStrMessage, btnCancelTitle: aCancelBtnTitle, btnOtherTitle: aOtherBtnTitle)
    show()
    block = completion
  }
  
  public func showAlertAttribute(astrTitle: String, aStrMessage: NSAttributedString, aCancelBtnTitle: String?, aOtherBtnTitle: String?, completion : alertCompletionBlock) {
    configureAttribute(title: astrTitle, message: aStrMessage, btnCancelTitle: aCancelBtnTitle, btnOtherTitle: aOtherBtnTitle)
    show()
    block = completion
  }
  
  /**
   Display an Alert With "OK" Button
   
   - parameter aStrMessage: Message to display in Alert
   - parameter completion:  Completion block. OK Button Index - 0
   */
  
  // 2018-03-29 sn
  // astrTitle add
  // aImageViewCheck add
  public func showAlertWithOkButton(astrTitle: String, aStrMessage: String, alertViewHiddenCheck: Bool, completion : alertCompletionBlock){
    alertViewHidden = alertViewHiddenCheck
    configure(title: astrTitle, message: aStrMessage, btnCancelTitle: nil, btnOtherTitle: nil)
    show()
    block = completion
  }
}
