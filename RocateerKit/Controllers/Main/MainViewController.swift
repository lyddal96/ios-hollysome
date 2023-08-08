//
//  MainViewController.swift
//  RocateerKit
//
//  Created by rocket on 11/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//
import UIKit
import DZNEmptyDataSet
import Defaults
import SideMenu

class MainViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var mainTableView: UITableView!
  @IBOutlet weak var bannerCollectionView: UICollectionView!
  @IBOutlet weak var bannerPageControl: UIPageControl!
  @IBOutlet weak var alarmBarButton: UIBarButtonItem!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var sectionTitle = ["LOGIN", "WebView", "ETC", "TAB", "CHART"]
  var mainList: [[(title: String, desc: String)]] = [
    [ // LOGIN
      (title: "회원가입", "회원가입"),
      (title: "로그인", "로그인, SNS로그인, ID찾기, 비밀번호 찾기"),
      (title: "비밀번호 변경", "비밀번호 변경"),
      (title: "회원정보", "조회, 변경"),
      (title: "회원정보", "로그아웃"),
      (title: "회원정보", "탈퇴")
    ],
    [ // WebView
      (title: "주소검색", "다음주소"),
      (title: "약관", "약관리스트"),
      (title: "약관 상세", "약관 상세"),
      (title: "공지사항", "웹뷰"),
      (title: "FAQ", "웹뷰")
    ],
    [ // ETC
      (title: "FCM", "FCM 키를 발급 받음"),
      (title: "팝업", "앱 시작 팝업"),
      (title: "팝업", "사진 팝업"),
      (title: "팝업", "카드 팝업"),
      (title: "튜토리얼", "튜토리얼"),
      (title: "채팅", "채팅")
    ],
    [ // Tab
      (title: "Basic Tab", "날짜 선택"),
      (title: "Header Tab", "헤더가 있는 Paging Controller")
    ],
    [ // Chart
      (title: "Chart", "Line"),
      (title: "Chart", "Bar")
    ]
    
  ]
  
  var timer: Timer?
  var bannerList = [EventModel]()
  var bannerTime = 0
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bannerCollectionView.registerCell(type: BannerImageCell.self)
    self.bannerCollectionView.delegate = self
    self.bannerCollectionView.dataSource = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.mainTableView.registerCell(type: MainCell.self)
    self.mainTableView.tableFooterView = UIView(frame: CGRect.zero)
    self.mainTableView.delegate = self
    self.mainTableView.dataSource = self
    self.initMenu()
    
  }
  
  override func initRequest() {
    super.initRequest()
//    self.bannerListAPI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    if Defaults[.member_idx] != nil {
//      self.newAlarmCountAPI()
//    }
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 배너 타이머
  @objc func bannerTimerAction() {
    if self.bannerTime >= self.bannerList.count - 1 {
      self.bannerTime = 0
    } else {
      self.bannerTime += 1
    }
    
    let indexPath = IndexPath(row: self.bannerTime, section: 0)
    self.bannerCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
  }
  

  
  /// 메뉴 세팅
  private func initMenu() {
    SideMenuManager.default.leftMenuNavigationController = SideMenuNavigationController.instantiate(storyboard: "Menu")
    SideMenuManager.default.leftMenuNavigationController?.settings = self.getMenuSetting()
    SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
    SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
  }
  
  /// 메뉴 세팅 처리
  private func getMenuSetting() -> SideMenuSettings {
    let presentationStyle = SideMenuPresentationStyle.menuSlideIn
    
    presentationStyle.backgroundColor = UIColor(named: "black_90")!
    presentationStyle.menuStartAlpha = 0.9
    presentationStyle.menuScaleFactor = 1
    presentationStyle.onTopShadowOpacity = 0
    presentationStyle.presentingEndAlpha = 0.8
    presentationStyle.presentingScaleFactor = 1
    
    var settings = SideMenuSettings()
    settings.presentationStyle = presentationStyle
    settings.menuWidth = self.view.frame.size.width - 120
    settings.alwaysAnimate = true
    settings.blurEffectStyle = .none
    settings.statusBarEndAlpha = 0
    
    return settings
  }
  
  
  /// 로그아웃
  private func logoutAPI() {
    APIRouter.shared.api(path: APIURL.logout, method: .post, parameters: nil) { data in
      if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse) {
        Defaults[.access_token] = nil
      }
    }

  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 메뉴
  /// - Parameter sender: 바버튼
  @IBAction func menuBarButtonTouched(sender: UIBarButtonItem) {
    let destination = SideMenuManager.default.leftMenuNavigationController!
    self.present(destination, animated: true, completion: nil)
  }
  
  /// 알림
  /// - Parameter sender: 바버튼
  @IBAction func alarmBarButtonTouched(sender: UIBarButtonItem) {
    let destination = AlarmViewController.instantiate(storyboard: "Main")
    self.navigationController?.pushViewController(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension MainViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.mainList.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.mainList[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
    self.mainCell(cell: cell, indexPath: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "\(self.sectionTitle[section])"
  }
  
  /// 메인 Cell
  ///
  /// - Parameters:
  ///   - cell: 테이블뷰 셀
  ///   - indexPath: 인덱스
  func mainCell(cell: UITableViewCell, indexPath: IndexPath) {
    let cell = cell as! MainCell
    let menu = self.mainList[indexPath.section][indexPath.row]
    cell.titleLabel.text = menu.title
    cell.descLabel.text = menu.desc
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        let destination = JoinViewController.instantiate(storyboard: "Login")
        self.navigationController?.pushViewController(destination, animated: true)
      } else if indexPath.row == 1 {
        let destination = LoginViewController.instantiate(storyboard: "Login")
        self.navigationController?.pushViewController(destination, animated: true)
      }  else if indexPath.row == 2 {
        let destination = ChangePwViewController.instantiate(storyboard: "Login")
        self.navigationController?.pushViewController(destination, animated: true)
      } else if indexPath.row == 3 {
        let destination = UserInfoViewController.instantiate(storyboard: "Login")
        self.navigationController?.pushViewController(destination, animated: true)
      } else if indexPath.row == 4 {
        AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "로그아웃 하시겠습니까?", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
          if position == 1 {
            self.logoutAPI()
          }
        }
      } else if indexPath.row == 5 {
        let destination = MemberOutViewController.instantiate(storyboard: "Login")
        self.navigationController?.pushViewController(destination, animated: true)
      }
    } else if indexPath.section == 1 {
      if indexPath.row == 0 {
        let destination = WebViewController.instantiate(storyboard: "Commons")
        destination.webType = .address
        self.navigationController?.pushViewController(destination, animated: true)
      } else if indexPath.row == 1 {
        let destination = WebViewController.instantiate(storyboard: "Commons")
        destination.webType = .terms0
        self.navigationController?.pushViewController(destination, animated: true)
      }
    } else if indexPath.section == 2 {
      if indexPath.row == 0 {
        let destination = FcmViewController.instantiate(storyboard: "Main")
        self.navigationController?.pushViewController(destination, animated: true)
      } else if indexPath.row == 1 {
        let destination = PopupViewController.instantiate(storyboard: "Main")
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .overCurrentContext
        self.present(destination, animated: true, completion: nil)
      } else if indexPath.row == 2 {
        let destination = PhotoPopupViewController.instantiate(storyboard: "Main")
        destination.delegate = self
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .overCurrentContext
        self.present(destination, animated: true, completion: nil)
      } else if indexPath.row == 3 {
        let destination = CardPopupViewController.instantiate(storyboard: "Main")
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .overCurrentContext
        self.present(destination, animated: false, completion: nil)
      } else if indexPath.row == 4 {
        if !(Defaults[.tutorial] ?? false) {
          let destination = TutorialViewController.instantiate(storyboard: "Intro")
          destination.modalPresentationStyle = .fullScreen
          self.present(destination, animated: true, completion: nil)
        } else {
          let alert = UIAlertController(title: "", message: "튜토리얼 닫음", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
          alert.addAction(UIAlertAction(title: "확인 후 초기화", style: .default, handler: { (action) in
            Defaults[.tutorial] = nil
          }))
          self.present(alert, animated: true, completion: nil)
          
        }
      } else if indexPath.row == 5 {
        let destination = ChatViewController.instantiate(storyboard: "Main")
        self.navigationController?.pushViewController(destination, animated: true)
      }
    } else if indexPath.section == 3 {
      if indexPath.row == 0 {
        let destination = TabViewController.instantiate(storyboard: "Tab")
        self.navigationController?.pushViewController(destination, animated: true)
      } else if indexPath.row == 1 {
        let destination = HeaderTabViewController.instantiate(storyboard: "Tab")
        self.navigationController?.pushViewController(destination, animated: true)
      }
    } else if indexPath.section == 4 {
      if indexPath.row == 0 {
        let destination = LineChartViewController.instantiate(storyboard: "Chart")
        self.navigationController?.pushViewController(destination, animated: true)
      } else if indexPath.row == 1 {
        let destination = BarChartViewController.instantiate(storyboard: "Chart")
        self.navigationController?.pushViewController(destination, animated: true)
      }
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension MainViewController: DZNEmptyDataSetSource {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "공지사항이 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
      NSAttributedString.Key.foregroundColor : UIColor(named: "666666")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - WebResultDelegate
//-------------------------------------------------------------------------------------------
extension MainViewController: WebResultDelegate {
  func resultAddress(zonecode: String, address: String, lat: String, lng: String) {
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - PhotoUploadDelegate
//-------------------------------------------------------------------------------------------
extension MainViewController: PhotoUploadDelegate {
  func photoUploadDelegate(imgUrl: String) {
    if imgUrl == "" {
      Tools.shared.showToast(message: "사진 삭제.")
    } else {
      Tools.shared.showToast(message: "\(imgUrl)")
      
      
      let destination = PreviewImageViewController.instantiate(storyboard: "Main")
      destination.imageUrl = imgUrl
      self.present(destination, animated: true)
      
    }
    
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.bannerList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCell", for: indexPath) as! BannerImageCell
    let bannerData = self.bannerList[indexPath.row]
    cell.bannerImageView.sd_setImage(with: URL(string: bannerData.img_path ?? ""), completed: nil)
    return cell
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.bannerCollectionView {
      let pageWidth = self.bannerCollectionView.frame.width
      let currentPage = Int(self.bannerCollectionView.contentOffset.x / pageWidth)
      self.bannerPageControl.currentPage = currentPage
    }
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.bannerCollectionView.frame.size.width, height: 125)
  }
}
