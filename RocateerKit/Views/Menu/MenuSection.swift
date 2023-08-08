//
//  MenuSection.swift
//  RocateerKit
//
//  Created by rocateer on 2020/01/09.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class MenuSection: UIView {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var titleLabel: UILabel!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var view: UIView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - initialize
  //-------------------------------------------------------------------------------------------
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  func initView() {
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    addSubview(view)
  }
  
  func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "MenuSection", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
}

