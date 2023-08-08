//
//  TabTableViewController.swift
//  RocateerKit
//
//  Created by rocateer on 2020/01/10.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class TabTableViewController: UITableViewController {
  
  private static let CellIdentifier = "CellIdentifier"
  var index = 0
//  var categoryList = [ProductModel]()
  let parentsViewController = UIApplication.topViewController() as? HeaderTabViewController
  

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerCell(type: HeaderTableCell.self)
    tableView.showsVerticalScrollIndicator = false
    tableView.separatorStyle = .none
    
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
    
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableCell", for: indexPath) as! HeaderTableCell
    cell.contentsLabel.text = "indexPath.row : \(indexPath.row)"
    return cell
  }

}
