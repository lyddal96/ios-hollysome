//
//  EventDetailViewController.swift
//  RocateerKit
//
//  Created by rocateer on 2020/01/17.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class EventDetailViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var eventDetailTableView: UITableView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var eventResponse = EventModel()
  var event_idx = ""
  
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
    self.eventDetailTableView.registerCell(type: EventDetailCell.self)
    self.eventDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
    self.eventDetailTableView.delegate = self
    self.eventDetailTableView.dataSource = self
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


//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension EventDetailViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailCell", for: indexPath)
    self.eventDetailCell(cell: cell, indexPath: indexPath)
    return cell
  }
  
  /// 이벤트 상세
  ///
  /// - Parameters:
  ///   - cell: 테이블 뷰 셀
  ///   - indexPath: indexPath
  private func eventDetailCell(cell: UITableViewCell, indexPath: IndexPath) {
    let cell = cell as! EventDetailCell
    cell.eventTitleLabel.text = self.eventResponse.title ?? "이벤트 타이틀"
    cell.eventDateLabel.text = self.eventResponse.ins_date ?? "이벤트 날짜"
    cell.eventContentsLabel.text = self.eventResponse.contents ?? "이벤트 내용"
    
    if let img_path = self.eventResponse.img_path {
      cell.eventImageView.sd_setImage(with: URL(string: img_path), completed: nil)
      cell.imageHeight.constant = (CGFloat(self.eventResponse.img_height ?? 0) * self.view.frame.size.width) / CGFloat(self.eventResponse.img_width ?? 0)
    } else {
      cell.imageHeight.constant = 0
    }
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension EventDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
