//
//  PreviewImageViewController.swift
//  RocateerKit
//
//  Created by rocateer on 2023/03/27.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit

class PreviewImageViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var previewImageView: UIImageView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var imageUrl = ""

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
    log.debug("http://192.168.50.81/image/\(self.imageUrl)")
    self.previewImageView.sd_setImage(with: URL(string: "http://192.168.50.81/storage/image/\(self.imageUrl)")!)
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
  
}
