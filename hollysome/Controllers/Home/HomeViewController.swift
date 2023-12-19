//
//  HomeViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/05/26.
//
//

import UIKit
import Defaults

class HomeViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var noHouseView: UIView!
  @IBOutlet weak var houseView: UIView!
  @IBOutlet weak var alarmBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var logoView: UIView!
  @IBOutlet weak var makeHouseButton: UIButton!
  @IBOutlet weak var inputCodeView: UIView!
  
  @IBOutlet weak var topRoundView: UIView!
  @IBOutlet weak var houseNameLabel: UILabel!
  @IBOutlet weak var houseDetailView: UIView!
  @IBOutlet weak var mateCntLabel: UILabel!
  @IBOutlet weak var mateCollectionView: UICollectionView!
  @IBOutlet weak var scheduleCollectionView: UICollectionView!
  @IBOutlet weak var scheduleView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var scheduleCntLabel: UILabel!
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var houseNoticeView: UIView!
  @IBOutlet weak var houseNoticeTableView: UITableView!
  @IBOutlet weak var houseNoticeHeight: NSLayoutConstraint!
  @IBOutlet weak var houseImageView: UIImageView!
  @IBOutlet weak var imageEditButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var schedule = 0
  var noticeList = 0
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.notificationCenter.addObserver(self, selector: #selector(self.joinHouseUpdate), name: Notification.Name("JoinHouseUpdate"), object: nil)
    
    
    self.mateCollectionView.registerCell(type: MateCell.self)
    self.mateCollectionView.delegate = self
    self.mateCollectionView.dataSource = self
    
    self.scheduleCollectionView.registerCell(type: HomeScheduleCell.self)
    self.scheduleCollectionView.registerCell(type: HomeEmptyScheduleCell.self)
    self.scheduleCollectionView.delegate = self
    self.scheduleCollectionView.dataSource = self
    
    self.houseNoticeTableView.registerCell(type: HomeNoticeCell.self)
    self.houseNoticeTableView.registerCell(type: EmptyTableCell.self)
    self.houseNoticeTableView.dataSource = self
    self.houseNoticeTableView.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
   
    self.topRoundView.roundCorners(cornerRadius: 12, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    self.setTitleBar()
    self.inputCodeView.setCornerRadius(radius: 8)
    self.makeHouseButton.setCornerRadius(radius: 12)
    self.moreButton.setCornerRadius(radius: 12)
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.inputCodeView.addTapGesture { recognizer in
      // 하우스 코드 입력하기
      let destination = InputHouseCodeViewController.instantiate(storyboard: "Home")
      destination.modalTransitionStyle = .crossDissolve
      destination.modalPresentationStyle = .overCurrentContext
      destination.hidesBottomBarWhenPushed = true
//      self.present(destination, animated: false, completion: nil)
      self.tabBarController?.present(destination, animated: true)
    }
    
    // 하우스 상세
    self.houseDetailView.addTapGesture { recognizer in
      log.debug("하우스")
    }
    
    // 일정 리스트
    self.scheduleView.addTapGesture { recognizer in
      log.debug("일정")
      
      let destination = TodayScheduleViewController.instantiate(storyboard: "Home")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // 알림장 리스트
    self.houseNoticeView.addTapGesture { recognizer in
      log.debug("알림장")
      
      let destination = HouseNoticeViewController.instantiate(storyboard: "Home")
      destination.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(destination, animated: true)
    }
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setTitleBar()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM월 dd일 (E)"
    self.dateLabel.text = dateFormatter.string(from: Date())
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 하우스 유무에 따른 세팅
  func setTitleBar() {
    self.logoView.isHidden = Defaults[.house_code] == nil
    self.alarmBarButtonItem.isEnabled = Defaults[.house_code] != nil
    self.alarmBarButtonItem.image = Defaults[.house_code] == nil ? nil : UIImage(named: "bell")
    
    self.navigationItem.title = Defaults[.house_code] == nil ? "홈" : ""
    self.houseView.isHidden = Defaults[.house_code] == nil
    self.noHouseView.isHidden = Defaults[.house_code] != nil
  }
  
  // 하우스 가입 업데이트
  @objc func joinHouseUpdate() {
    self.setTitleBar()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 하우스 만들기
  /// - Parameter sender: 버튼
  @IBAction func makeHouseButtonTouched(sender: UIButton) {
    let destination = MakeHouseViewController.instantiate(storyboard: "Home")
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 하우스 이미지 변경
  /// - Parameter sender: 버튼
  @IBAction func imageChangeButtonTouched(sender: UIButton) {
    
  }
  
  /// 더보기
  /// - Parameter sender: 버튼
  @IBAction func moreButtonTouched(sender: UIButton) {
    let destination = TodayScheduleViewController.instantiate(storyboard: "Home")
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 알림
  /// - Parameter sender: 바버튼
  @IBAction func alarmBarButtonItemTouched(sender: UIButton) {
    let destination = AlarmViewController.instantiate(storyboard: "Main")
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension HomeViewController: UICollectionViewDelegate {
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == self.mateCollectionView {
      return CGSize(width: 52, height: 74)
    } else {
      if self.schedule == 0 {
        return CGSize(width: (self.view.frame.size.width - 32), height: 224)
      } else {
        return CGSize(width: (self.view.frame.size.width - 48) / 2, height: 104)
      }
      
    }
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.mateCollectionView {
      return 3
    } else {
      return self.schedule == 0 ? 1 : 4
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == self.mateCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
      cell.setMate(index: indexPath)
      cell.nameLabel.text = "메이트\(indexPath.row)"
      
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScheduleCell", for: indexPath) as! HomeScheduleCell
      let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeEmptyScheduleCell", for: indexPath) as! HomeEmptyScheduleCell
      
      if self.schedule == 0 || self.schedule <= indexPath.row {
        
        /// API작업 후 제거
        emptyCell.roundView.addTapGesture { recognizer in
          self.schedule = 3
          self.scheduleCollectionView.reloadData()
        }
        return emptyCell
      } else {
        cell.titleLabel.text = "나의 할일입니다"
        cell.timeLabel.text = "미정"
        cell.stateButton.isEnabled = indexPath.row == 0
        
        /// 할일 완료
        cell.stateButton.addTapGesture { recognizer in
          AJAlertController.initialization().showAlert(astrTitle: "설거지 을(를) 완료하셨나요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "완료") { position, title in
            if position == 1 {
              // 완료
            }
          }
        }
        return cell
      }
    }
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension HomeViewController: UITableViewDelegate {

}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension HomeViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.noticeList == 0 ? 1 : self.noticeList
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNoticeCell", for: indexPath) as! HomeNoticeCell
    let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableCell", for: indexPath) as! EmptyTableCell
    
    if self.noticeList == 0 {
      /// API작업 후 제거
      emptyCell.roundView.addTapGesture { recognizer in
        self.noticeList = 3
        self.houseNoticeHeight.constant = 3 * 70
        self.houseNoticeTableView.reloadData()
      }
      return emptyCell
    }
    
    cell.setNotice(index: indexPath)
    
    return cell
  }
  
  
}
