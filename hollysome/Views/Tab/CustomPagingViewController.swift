//
//  CustomPagingViewController.swift
//  hollysome
//
//  Created by rocateer on 2020/01/10.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Parchment

class CustomPagingViewController: PagingViewController {
  var parentsViewController: MainViewController?
  
  override func loadView() {
    view = CustomPagingView(
      options: options,
      collectionView: collectionView,
      pageView: pageViewController.view
    )
  }
}
