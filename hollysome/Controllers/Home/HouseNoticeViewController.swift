//
//  HouseNoticeViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/16/23.
//

import UIKit
import DZNEmptyDataSet
import Defaults

class HouseNoticeViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var noticeTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var noteList = [HouseModel]()
  var noteRequest = HouseModel()
  var refresh = UIRefreshControl()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.notificationCenter.addObserver(self, selector: #selector(self.houseNoteUpdate), name: Notification.Name("HouseNoteUpdate"), object: nil)
    
    self.noticeTableView.registerCell(type: HouseNoticeCell.self)
    self.noticeTableView.delegate = self
    self.noticeTableView.dataSource = self
    
    self.refresh.addTarget(self, action: #selector(self.houseNoteUpdate), for: .valueChanged)
    self.noticeTableView.refreshControl = self.refresh
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.noteListAPI()
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 알림장 리스트 API
  func noteListAPI() {
    self.noteRequest.member_idx = Defaults[.member_idx]
    self.noteRequest.house_code = Defaults[.house_code]
    self.noteRequest.setNextPage()
    
    APIRouter.shared.api(path: .note_list, method: .post, parameters: noteRequest.toJSON()) { response in
      if let noteResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: noteResponse) {
        self.noteRequest.total_page = noteResponse.total_page
        self.isLoadingList = true
        if let data_array = noteResponse.data_array, data_array.count > 0 {
          self.noteList += data_array
        }
        self.refresh.endRefreshing()
        self.noticeTableView.emptyDataSetSource = self
        self.noticeTableView.reloadData()
      }
    }
  }


  /// 알림장 차단 API
  func noteBlockAPI(note_idx: String) {
    let noteRequest = HouseModel()
    noteRequest.note_idx = note_idx
    noteRequest.member_idx = Defaults[.member_idx]

    APIRouter.shared.api(path: .block_mod_up, method: .post, parameters: noteRequest.toJSON()) { response in
      if let noteResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: noteResponse) {
        if let index = self.noteList.firstIndex(where: { $0.note_idx == note_idx }) {
          self.noteList[index].block_yn = self.noteList[index].block_yn == "Y" ? "N" : "Y"
        }
        self.noticeTableView.reloadData()
      }
    }
  }

  /// 알림장 삭제 API
  func noteDelAPI(note_idx: String) {
    let noteRequest = HouseModel()
    noteRequest.note_idx = note_idx

    APIRouter.shared.api(path: .note_del, method: .post, parameters: noteRequest.toJSON()) { response in
      if let noteResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: noteResponse) {
        self.houseNoteUpdate()
      }
    }
  }
  /// 새로고침
  @objc func houseNoteUpdate() {
    self.noteRequest.resetPage()
    self.noteList.removeAll()
    self.noteListAPI()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 작성
  /// - Parameter sender: 바버튼
  @IBAction func writeBarButtonItemTouched(sender: UIBarButtonItem) {
    let destination = NoticeRegViewController.instantiate(storyboard: "Home").coverNavigationController()
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension HouseNoticeViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.noticeTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.noteRequest.isMore() {
          self.isLoadingList = false
          self.noteListAPI()
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension HouseNoticeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.noteList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HouseNoticeCell", for: indexPath) as! HouseNoticeCell
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
    
    cell.blockView.isHidden = true
    cell.blockLabel.isHidden = true
    cell.deleteButton.isHidden = true
    cell.modifyButton.isHidden = true
    cell.contentLabel.isHidden = false
    cell.roundView.backgroundColor = .white
    cell.contentLabel.text = ""
    cell.moreButton.isHidden = true
    
    
    let note = self.noteList[indexPath.row]
    
    
    cell.timeLabel.text = note.ins_date ?? ""
    cell.nameLabel.text = note.member_nickname ?? ""
    cell.shapeImageView.image = UIImage(named: "\(shapeList[note.member_role1?.toInt() ?? 0])71")
    cell.faceImageView.image = UIImage(named: "face\(note.member_role2?.toInt() ?? 0)")
    cell.colorView.backgroundColor = UIColor(named: "profile\(note.member_role3?.toInt() ?? 0)")
    
    cell.avatarView.isHidden = false
    cell.nameLabel.isHidden = false
    if note.report_yn == "Y" {
      cell.avatarView.isHidden = true
      cell.nameLabel.isHidden = true
      cell.roundView.backgroundColor = UIColor(named: "E4E6EB")
      cell.blockLabel.text = "신고한 알림장이예요."
      cell.blockLabel.isHidden = false
      cell.contentLabel.isHidden = true
    } else if note.block_yn == "Y" {
      cell.roundView.backgroundColor = UIColor(named: "E4E6EB")
      cell.avatarView.isHidden = true
      cell.nameLabel.isHidden = true
      cell.blockView.isHidden = false
      cell.blockLabel.text = "차단한 알림장이예요."
      cell.blockLabel.isHidden = false
      cell.contentLabel.isHidden = true
    } else {
      cell.contentLabel.text = note.contents ?? ""
      cell.deleteButton.isHidden = Defaults[.member_idx] != note.member_idx
      cell.modifyButton.isHidden = Defaults[.member_idx] != note.member_idx
      cell.moreButton.isHidden = Defaults[.member_idx] == note.member_idx
    }
    
    /// 더보기
    cell.moreButton.addTapGesture { recognizer in
      let destination = CardPopupViewController.instantiate(storyboard: "Main")
      destination.note_idx = note.note_idx ?? ""
      destination.blockIsHidden = false
      destination.reportIsHidden = false
      destination.delegate = self
      destination.modalTransitionStyle = .crossDissolve
      destination.modalPresentationStyle = .overCurrentContext
      self.present(destination, animated: false, completion: nil)
    }
    
    /// 차단해제
    cell.cancelBlockButton.addTapGesture { recognizer in
      AJAlertController.initialization().showAlert(astrTitle: "차단을 해제할까요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "차단 해제하기") { position, title in
        if position == 1 {
          // 차단 해제
          self.noteBlockAPI(note_idx: note.note_idx ?? "")
        }
      }
    }
    
    /// 삭제
    cell.deleteButton.addTapGesture { recognizer in
      AJAlertController.initialization().showAlert(astrTitle: "작성한 알림장을 삭제할까요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "삭제할래요.") { position, title in
        if position == 1 {
          self.noteDelAPI(note_idx: note.note_idx ?? "")
        }
      }
    }
    
    /// 수정
    cell.modifyButton.addTapGesture { recognizer in
      let viewController = NoticeRegViewController.instantiate(storyboard: "Home")
      viewController.enrollType = .modify
      viewController.note_idx = note.note_idx ?? ""
      let destination = viewController.coverNavigationController()
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true)
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


//-------------------------------------------------------------------------------------------
// MARK: - CardPopupSelectDelegate
//-------------------------------------------------------------------------------------------
extension HouseNoticeViewController: CardPopupSelectDelegate {
  func blockTouched(note_idx: String) {
    AJAlertController.initialization().showAlert(astrTitle: "해당 글을 차단할까요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "차단하기") { position, title in
      if position == 1 {
        // 차단하기
        self.noteBlockAPI(note_idx: note_idx)
      }
    }
  }
  
  func reportTouched(note_idx: String) {
    let destination = ReportPopupViewController.instantiate(storyboard: "Commons")
    destination.delegate = self
    destination.note_idx = note_idx
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - ReportDelegate
//-------------------------------------------------------------------------------------------
extension HouseNoticeViewController: ReportDelegate {
  func reportDelegate(note_idx: String) {
    if let index = self.noteList.firstIndex(where: { $0.note_idx == note_idx }) {
      self.noteList[index].report_yn = "Y"
    }
    self.noticeTableView.reloadData()
  }
}
