//
//  HouseNoticeViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/16/23.
//

import UIKit
import DZNEmptyDataSet

class HouseNoticeViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var noticeTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var noticeList = 0
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.noticeTableView.registerCell(type: HouseNoticeCell.self)
    self.noticeTableView.delegate = self
    self.noticeTableView.dataSource = self
    self.noticeTableView.emptyDataSetSource = self
    self.noticeTableView.emptyDataSetDelegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 작성
  /// - Parameter sender: 바버튼
  @IBAction func writeBarButtonItemTouched(sender: UIBarButtonItem) {
    let destination = NoticeRegViewController.instantiate(storyboard: "Home")
    self.navigationController?.pushViewController(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension HouseNoticeViewController: UITableViewDelegate {
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension HouseNoticeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.noticeList
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HouseNoticeCell", for: indexPath) as! HouseNoticeCell
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
    
    cell.shapeImageView.image = UIImage(named: "\(shapeList[0])71")
    cell.faceImageView.image = UIImage(named: "face\(0)")
    cell.colorView.backgroundColor = UIColor(named: "profile\(0)")
    
    cell.blockView.isHidden = true
    cell.blockLabel.isHidden = true
    cell.buttonsView.isHidden = true
    cell.roundView.backgroundColor = .white
    
    if indexPath.row == 0 {
      cell.contentLabel.text = "보일러 수리기사님 1월 10일 오전에 방문"
      cell.timeLabel.text = "23-01-02 00:00"
      cell.buttonsView.isHidden = false
    } else if indexPath.row == 1 {
      cell.contentLabel.text = "보일러 수리기사님 1월 10일 오전에 방문보일러 수리기사님 1월 10일 오전에 방문보일러 수리기사님 1월 10일 오전에 방문보일러 수리기사님 1월 10일 오전에 방문보일러 수리기사님 1월 10일 오전에 방문보일러 수리기사님 1월 10일 오전에 방문보일러 수리기사님 1월 10일 오전에 방문보일러 수리기사님 1월 10일 오전에 방문보일러 수리기사님 1월 10일 오전에 방문"
      cell.timeLabel.text = "23-01-02 00:00"
    } else if indexPath.row == 2 {
      cell.roundView.backgroundColor = UIColor(named: "E4E6EB")
      cell.blockView.isHidden = false
      cell.blockLabel.text = "차단한 알림장이예요."
    } else if indexPath.row == 3 {
      cell.roundView.backgroundColor = UIColor(named: "E4E6EB")
      cell.blockLabel.text = "신고한 알림장이예요."
    }
    
    return cell
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension HouseNoticeViewController: DZNEmptyDataSetSource {
//  func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//    return -100
//  }
  
  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -250
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "아직 작성된 알림장이 없어요."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor : UIColor(named: "C8CCD5")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

extension HouseNoticeViewController: DZNEmptyDataSetDelegate {
  func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
    self.noticeList = 10
    self.noticeTableView.reloadData()
  }
}
