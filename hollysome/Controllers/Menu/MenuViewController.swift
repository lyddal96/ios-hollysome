//
//  MenuViewController.swift
//  hollysome
//

import UIKit
import SideMenu

class MenuViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var menuTableView: UITableView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let sectionList = [
    "Commons"
  ]
  
  
  var menuList: [[(title: String, desc: String)]] = [
    [ // CS
      (title: "공지사항", "공지사항 리스트와 공지사항 상세"),
      (title: "Event", "이벤트 리스트, 이벤트 상세보기"),
      (title: "FAQ", "FAQ Expandable 리스트"),
      (title: "FAQ", "FAQ 카테고리 리스트"),
      (title: "QNA", "QNA 리스트, QNA 등록, QNA 상세보기")
    ]
  ]
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.menuTableView.registerCell(type: MenuCell.self)
    self.menuTableView.delegate = self
    self.menuTableView.dataSource = self
    self.menuTableView.tableFooterView = UIView(frame: .zero)
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
extension MenuViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.menuList.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.menuList[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
    let menu = self.menuList[indexPath.section][indexPath.row]
    cell.titleLabel.text = menu.title
    cell.descLabel.text = menu.desc
    
    // 섹션 별 Left
    //    if indexPath.section == 0 || indexPath.section == 5 {
    //      cell.titleLeft.constant = 16
    //      cell.backgroundColor = UIColor.white
    //    } else {
    //      cell.titleLeft.constant = 30
    //      cell.backgroundColor = UIColor(named: "F6F6F6")
    //    }
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 24
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let menuSection = MenuSection(frame: CGRect(x: 0, y: 0, w: self.view.frame.size.width, h: 24))
    menuSection.titleLabel.text = self.sectionList[section]
    return menuSection
//    if section == 1 || section == 2 || section == 3 {
//      let menuSection = MenuSection(frame: CGRect(x: 0, y: 0, w: self.view.frame.size.width, h: 24))
//      menuSection.titleLabel.text = sectionList[section - 1]
//      return menuSection
//    } else {
//      return nil
//    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension MenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    DispatchQueue.main.async {
      if indexPath.section == 0 {
        if indexPath.row == 0 {
          let destination = NoticeViewController.instantiate(storyboard: "Commons")
          self.navigationController?.pushViewController(destination, animated: true)
        } else if indexPath.row == 1 {
          let destination = EventViewController.instantiate(storyboard: "Commons")
          self.navigationController?.pushViewController(destination, animated: true)
        } else if indexPath.row == 2 {
          let destination = FaqViewController.instantiate(storyboard: "Commons")
          self.navigationController?.pushViewController(destination, animated: true)
        } else if indexPath.row == 3 {
          let destination = FaqCategoryViewController.instantiate(storyboard: "Commons")
          self.navigationController?.pushViewController(destination, animated: true)
        } else if indexPath.row == 4 {
          let destination = QnaViewController.instantiate(storyboard: "Commons")
          self.navigationController?.pushViewController(destination, animated: true)
        }
      }
    }
  }
}
