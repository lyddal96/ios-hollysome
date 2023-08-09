//
//  TermsDetailViewController.swift
//  hollysome
//
//  Created by rocateer on 2020/01/09.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class TermsDetailViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var terms0WrapView: UIView!
  @IBOutlet weak var terms1WrapView: UIView!
  @IBOutlet weak var terms2WrapView: UIView!
  @IBOutlet weak var terms3WrapView: UIView!
  @IBOutlet weak var terms4WrapView: UIView!
  
  
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
  }
  
  override func initRequest() {
    super.initRequest()
    
    let views = [self.terms0WrapView, self.terms1WrapView, self.terms2WrapView, self.terms3WrapView, self.terms4WrapView]
    
    for value in views {
      value?.addTapGesture(action: { (recognizer) in
        let destination = WebViewController.instantiate(storyboard: "Commons")
        switch value {
        case self.terms0WrapView:
          destination.webType = .terms0
          break
        case self.terms1WrapView:
          destination.webType = .terms1
          break
        case self.terms2WrapView:
          destination.webType = .terms2
          break
        case self.terms3WrapView:
          destination.webType = .terms3
          break
        case self.terms4WrapView:
          destination.webType = .terms3
          break
        default:
          break
        }
        self.navigationController?.pushViewController(destination, animated: true)
      })
    }
    
//    let destination = WebViewController.instantiate(storyboard: "Commons")
//      destination.webType = .Terms0
//      destination.webTitle = self.mainList[indexPath.section][indexPath.row].desc
//      self.navigationController?.pushViewController(destination, animated: true)
//    } else if indexPath.row == 3 {
//      let destination = WebViewController.instantiate(storyboard: "Commons")
//      destination.webType = .Terms1
//      destination.webTitle = self.mainList[indexPath.section][indexPath.row].desc
//      self.navigationController?.pushViewController(destination, animated: true)
//    } else if indexPath.row == 4 {
//      let destination = WebViewController.instantiate(storyboard: "Commons")
//      destination.webType = .Terms2
//      destination.webTitle = self.mainList[indexPath.section][indexPath.row].desc
//      self.navigationController?.pushViewController(destination, animated: true)
//    } else if indexPath.row == 5 {
//      let destination = WebViewController.instantiate(storyboard: "Commons")
//      destination.webType = .Terms3
//      destination.webTitle = self.mainList[indexPath.section][indexPath.row].desc
//      self.navigationController?.pushViewController(destination, animated: true)
//    } else if indexPath.row == 6 {
//      let destination = WebViewController.instantiate(storyboard: "Commons")
//      destination.webType = .Terms4
//      destination.webTitle = self.mainList[indexPath.section][indexPath.row].desc
//      self.navigationController?.pushViewController(destination, animated: true)
//    } else if indexPath.row == 7 {
//      let destination = WebViewController.instantiate(storyboard: "Commons")
//      destination.webType = .Kmc
//      self.navigationController?.pushViewController(destination, animated: true)
//    }
  }

  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


