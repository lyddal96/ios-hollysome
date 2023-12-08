//
//  CustomPagingView.swift
//  hollysome
//

import UIKit
import Parchment



class CustomPagingView: PagingView {
  
//  var HeaderHeight: CGFloat = 403
  var parentsViewController: HeaderTabViewController?
  
  var headerHeightConstraint: NSLayoutConstraint?
  
  
//  var headerView: UIView!
  
  lazy var headerView: UIView = {
    let view = HeaderView(frame: CGRect(x: 0, y: 0, w: self.frame.size.width, h: headerHeightConstraint?.constant ?? 0))
    return view
  }()
  
  
  override func setupConstraints() {
    addSubview(headerView)
    
    pageView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    headerView.translatesAutoresizingMaskIntoConstraints = false

    headerHeightConstraint = headerView.heightAnchor.constraint(
      equalToConstant: headerHeightConstraint?.constant ?? 0
    )
    headerHeightConstraint?.isActive = true

    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.heightAnchor.constraint(equalToConstant: options.menuHeight),
      collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),

      headerView.topAnchor.constraint(equalTo: topAnchor),
      headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: trailingAnchor),

      pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      pageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      pageView.topAnchor.constraint(equalTo: topAnchor)
    ])
  }

}
