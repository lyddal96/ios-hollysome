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
  @IBOutlet weak var adView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var mateList = [HouseModel]()
  var myScheduleList = [HouseModel]()
  var noteList = [HouseModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.notificationCenter.addObserver(self, selector: #selector(self.joinHouseUpdate), name: Notification.Name("JoinHouseUpdate"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.deeplinkUpdate), name: Notification.Name("DeeplinkUpdate"),  object: nil)
    
    
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
      
//      let destination = TodayScheduleViewController.instantiate(storyboard: "Home")
//      destination.hidesBottomBarWhenPushed = true
//      self.navigationController?.pushViewController(destination, animated: true)
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
  // 딥링크 업데이트
  @objc func deeplinkUpdate() {
    if self.appDelegate.house_code != "" { // 플레이어 상세로 이동
      log.debug("가입 \(self.appDelegate.house_code)")
      
      let houseRequest = HouseModel()
      houseRequest.member_idx = Defaults[.member_idx]
      houseRequest.house_code = self.appDelegate.house_code
      APIRouter.shared.api(path: .house_join_in, method: .post, parameters: houseRequest.toJSON()) { response in
        if let houseResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: houseResponse, alertYn: true) {
          Defaults[.house_code] = houseResponse.house_code
          Defaults[.house_idx] = houseResponse.house_idx
          self.setTitleBar()
        }
      }
    }
    self.appDelegate.house_code = ""
  }
  /// 홈 API
  func homeListAPI() {
    let houseRequest = HouseModel()
    houseRequest.member_idx = Defaults[.member_idx]
    houseRequest.house_idx = Defaults[.house_idx]
    
    APIRouter.shared.api(path: .house_list, method: .post, parameters: houseRequest.toJSON()) { response in
      if let houseResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: houseResponse) {
        self.houseImageView.sd_setImage(with: URL(string: "\(baseURL)\(houseResponse.house_img ?? "")"), placeholderImage: UIImage(named: "default_image"), options: .lowPriority, context: nil)
        self.houseNameLabel.text = houseResponse.house_name ?? ""
        self.scheduleCntLabel.text = "나의 할 일 \(houseResponse.my_schedule_count ?? "0")개"
        if let mate_array = houseResponse.mate_array {
          self.mateList = mate_array
        }
        self.mateCntLabel.text = "눔메이트 \(self.mateList.count)명"
        self.mateCollectionView.reloadData()
        
        if let my_schedule_array = houseResponse.my_schedule_array {
          self.myScheduleList = my_schedule_array
        }
        self.scheduleCollectionView.reloadData()
        if let note_array = houseResponse.note_array {
          self.noteList = note_array
          self.houseNoticeHeight.constant = self.noteList.count == 0 ? 80 : self.noteList.count.toCGFloat * 70
        }
        self.houseNoticeTableView.reloadData()
      }
    }
  }
  
  
  /// 이미지 업로드
  ///
  /// - Parameter imageData: 업로드할 이미지
  func uploadImages(imageData : Data) {
    
    APIRouter.shared.api(path: .fileUpload_action, file: imageData) { response in
      if let fileResponse = FileModel(JSON: response), Tools.shared.isSuccessResponse(response: fileResponse) {
        
        let houseRequest = HouseModel()
        houseRequest.house_img = fileResponse.file_path
        houseRequest.house_code = Defaults[.house_code]
        
        APIRouter.shared.api(path: .house_mod_up, method: .post, parameters: houseRequest.toJSON()) { response in
          if let houseResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: houseResponse) {
            self.houseImageView.sd_setImage(with: URL(string: "\(baseURL)\(fileResponse.file_path ?? "")"), placeholderImage: UIImage(named: "default_image"), options: .lowPriority, context: nil)
          }
        }
      }
    }
  }
  
  
  /// 하우스 유무에 따른 세팅
  func setTitleBar() {
    self.logoView.isHidden = Defaults[.house_code] == nil
    self.alarmBarButtonItem.isEnabled = Defaults[.house_code] != nil
    self.alarmBarButtonItem.image = Defaults[.house_code] == nil ? nil : UIImage(named: "bell")
    
    self.navigationItem.title = Defaults[.house_code] == nil ? "하우스 만들기" : ""
    self.houseView.isHidden = Defaults[.house_code] == nil
    self.noHouseView.isHidden = Defaults[.house_code] != nil
    
    if Defaults[.house_idx] != nil {
      self.homeListAPI()
    }
  }
  
  // 하우스 가입 업데이트
  @objc func joinHouseUpdate() {
    self.setTitleBar()
  }
  
  /// 나의 할일 완료API
  func todayScheduleEndAPI(schedule_idx: String, plan_idx: String) {
    let planRequest = PlanModel()
    planRequest.schedule_idx = schedule_idx
    
    APIRouter.shared.api(path: .today_schedule_end, method: .post, parameters: planRequest.toJSON()) { response in
      if let planResponse = PlanModel(JSON: response), Tools.shared.isSuccessResponse(response: planResponse) {
        self.setTitleBar()
      }
    }
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
    let destination = CardPopupViewController.instantiate(storyboard: "Main")
    destination.cameraIsHidden = false
    destination.albumIsHidden = false
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.tabBarController?.present(destination, animated: true)
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == self.mateCollectionView {
      if indexPath.row != 0 {
        let destination = MatePokeViewController.instantiate(storyboard: "Home")
        destination.member = self.mateList[indexPath.row]
        destination.modalPresentationStyle = .overCurrentContext
        destination.modalTransitionStyle = .crossDissolve
        self.tabBarController?.present(destination, animated: true, completion:  nil)
      }
    } else if collectionView == self.scheduleCollectionView {
      if !(self.myScheduleList.count == 0 || self.myScheduleList.count <= indexPath.row) {
        let plan = self.myScheduleList[indexPath.row]
        AJAlertController.initialization().showAlert(astrTitle: "\(plan.plan_name ?? "") 을(를) 완료하셨나요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "완료") { position, title in
          if position == 1 {
            // 완료
            self.todayScheduleEndAPI(schedule_idx: plan.schedule_idx ?? "", plan_idx: plan.plan_idx ?? "")
          }
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == self.mateCollectionView {
      return CGSize(width: 52, height: 74)
    } else {
      if self.myScheduleList.count == 0 {
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
      return self.mateList.count
    } else {
      return self.myScheduleList.count == 0 ? 1 : 4
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == self.mateCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
      let mate = self.mateList[indexPath.row]
      cell.nameLabel.text = mate.member_nickname ?? ""
      cell.avatarView.addBorder(width: 2, color: UIColor(named: mate.member_idx == Defaults[.member_idx] ? "accent" : "FFFFFF")!)
      cell.shapeImageView.image = UIImage(named: "\(Constants.SHAPE_LIST[mate.member_role1?.toInt() ?? 0])71")
      cell.faceImageView.image = UIImage(named: "face\(mate.member_role2?.toInt() ?? 0)")
      cell.colorView.backgroundColor = UIColor(named: "profile\(mate.member_role3?.toInt() ?? 0)")
      
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScheduleCell", for: indexPath) as! HomeScheduleCell
      let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeEmptyScheduleCell", for: indexPath) as! HomeEmptyScheduleCell
      
      if self.myScheduleList.count == 0 || self.myScheduleList.count <= indexPath.row {
        return emptyCell
      } else {
        let plan = self.myScheduleList[indexPath.row]
        cell.titleLabel.text = plan.plan_name ?? ""
        cell.timeLabel.text = plan.alarm_hour.isNil ? "미정" : "\(plan.alarm_hour ?? "")시"
        cell.stateButton.isEnabled = plan.schedule_yn != "Y"
        
        /// 할일 완료
        cell.stateButton.addTapGesture { recognizer in
          AJAlertController.initialization().showAlert(astrTitle: "\(plan.plan_name ?? "") 을(를) 완료하셨나요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "완료") { position, title in
            if position == 1 {
              // 완료
              self.todayScheduleEndAPI(schedule_idx: plan.schedule_idx ?? "", plan_idx: plan.plan_idx ?? "")
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
    return self.noteList.count == 0 ? 1 : self.noteList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNoticeCell", for: indexPath) as! HomeNoticeCell
    let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableCell", for: indexPath) as! EmptyTableCell
    
    if self.noteList.count == 0 {
      return emptyCell
    }
    let note = self.noteList[indexPath.row]
    cell.setNotice(note: note)
    
    return cell
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - CardPopupSelectDelegate
//-------------------------------------------------------------------------------------------
extension HomeViewController: CardPopupSelectDelegate {
  func albumTouched() {
    let controller = UIImagePickerController()
    controller.delegate = self
    controller.sourceType = .photoLibrary
    self.present(controller, animated: true, completion: nil)
  }
  
  func cameraTouched() {
    let controller = UIImagePickerController()
    controller.delegate = self
    controller.sourceType = .camera
    self.present(controller, animated: true, completion: nil)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//-------------------------------------------------------------------------------------------
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      imagePickerController(picker, pickedImage: image)
    }
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    picker.dismiss(animated: false) {
      let resizeImage = pickedImage!.resized(toWidth: 1000, isOpaque: true)
      let data = resizeImage?.jpegData(compressionQuality: 0.6) ?? Data()
      
      self.uploadImages(imageData: data)
    }
  }
}
