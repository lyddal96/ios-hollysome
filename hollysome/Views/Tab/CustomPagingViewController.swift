//
//  CustomPagingViewController.swift
//  hollysome
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
