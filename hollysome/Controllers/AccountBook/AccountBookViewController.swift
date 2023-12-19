//
//  AccountBookViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/08/09.
//
//

import UIKit
import ExpyTableView

class AccountBookViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var enrollBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var accountBookTableView: ExpyTableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var currentList = 0
  var lastList = 0
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.accountBookTableView.registerCell(type: AccountBookCell.self)
    self.accountBookTableView.registerCell(type: AccountBookEmptyCell.self)
    self.accountBookTableView.registerCell(type: AccountBookTitleCell.self)
    self.accountBookTableView.registerCell(type: LastAccountBookCell.self)
    self.accountBookTableView.registerCell(type: LastAccountBookDetailCell.self)
    self.accountBookTableView.delegate = self
    self.accountBookTableView.dataSource = self

    self.accountBookTableView.indicatorStyle = .white
    self.accountBookTableView.showsVerticalScrollIndicator = false
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
  /// - Parameter sender: 버튼
  @IBAction func enrollBarButtonItemTouched(sender: UIButton) {
    let destination = RegAccountBookViewController.instantiate(storyboard: "AccountBook")
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDataSource
//-------------------------------------------------------------------------------------------
extension AccountBookViewController: ExpyTableViewDataSource {
  func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
    if section == 0 && self.currentList > 0 {
      return false
    }
    return true
  }
  
  func canExpand(section: Int, inTableView tableView: ExpyTableView) -> Bool {
    return false
  }
  
  // 상위데이터
  func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
    let emptyCell = tableView.dequeueReusableCell(withIdentifier: "AccountBookEmptyCell") as! AccountBookEmptyCell
    let titleCell = tableView.dequeueReusableCell(withIdentifier: "AccountBookTitleCell") as! AccountBookTitleCell
    if section == 0 {
      if self.currentList == 0 {
        emptyCell.emptyLabel.text = "이번 달 가계부 내역이 없습니다.\n지금 바로 작성해보세요!"
        emptyCell.addTapGesture { recognizer in
          self.currentList = 4

          self.accountBookTableView.reloadData()
          self.accountBookTableView.expand(0)
          log.debug("expaned : \(self.accountBookTableView.expandedSections)")
        }
        return emptyCell
      } else {
        titleCell.backgroundColor = UIColor(named: "FFFFFF")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleCell.titleLabel.text = dateFormatter.string(from: Date())
        return titleCell
      }
    } else if section == 1 {
      titleCell.backgroundColor = UIColor(named: "FAFAFC")
      titleCell.titleLabel.text = "전체 가계부"
      return titleCell
    } else {
      if self.lastList == 0 {
        emptyCell.emptyLabel.text = "작성 된 가계부가\n없습니다."
        emptyCell.addTapGesture { recognizer in
          self.lastList = 4
          self.accountBookTableView.reloadData()
        }
        return emptyCell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LastAccountBookCell") as! LastAccountBookCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
      }
    }
//    else if section <= self.currentList {
//      let cell = tableView.dequeueReusableCell(withIdentifier: "AccountBookCell") as! AccountBookCell
//      
//      cell.layoutMargins = UIEdgeInsets.zero
//      return cell
//    } else if section == self.currentList + 1 {
//      titleCell.titleLabel.text = "전체 가계부"
//      return titleCell
//    } else {
//      if self.lastList == 0 {
//        emptyCell.emptyLabel.text = "작성 된 가계부가\n없습니다."
//        return emptyCell
//      } else {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LastAccountBookCell") as! LastAccountBookCell
//        
//        cell.layoutMargins = UIEdgeInsets.zero
//        return cell
//      }
//      
//    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
//    var sectionCnt = 1
//    if self.currentList == 0 {
//      sectionCnt += 1
//    } else {
//      sectionCnt += self.currentList + 1
//    }
//    if self.lastList == 0 {
//      sectionCnt += 1
//    } else {
//      sectionCnt += self.lastList
//    }
    if self.lastList == 0 {
      return 3
    } else {
      return 1 + self.lastList
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      if self.currentList == 0 {
        return 1
      } else {
        return self.currentList + 1
      }
      
    } else if section == 1 {
      return 1
    } else {
      if self.lastList == 0 {
        return 1
      } else {
        return section + 1
      }
    }
    //    }
  }
  
  
  
  // 하위 데이터
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        let titleCell = tableView.dequeueReusableCell(withIdentifier: "AccountBookTitleCell") as! AccountBookTitleCell
        titleCell.backgroundColor = UIColor(named: "FFFFFF")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleCell.titleLabel.text = dateFormatter.string(from: Date())
        return titleCell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountBookCell", for: indexPath) as! AccountBookCell
    //    cell.parentsViewController = self
        cell.totalView.isHidden = indexPath.row != self.currentList
        
        return cell
      }
      
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LastAccountBookDetailCell", for: indexPath) as! LastAccountBookDetailCell
  //    cell.parentsViewController = self
      
      
      return cell
    }
    
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDelegate
//-------------------------------------------------------------------------------------------
extension AccountBookViewController: ExpyTableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
    
    switch state {
    case .willExpand:
      break
    case .willCollapse:
      break
    case .didExpand:
      break
    case .didCollapse:
      break
    }
  }
}


