//
//  HomeScheduleCollectionCell.swift
//  hollysome
//
//  Created by 이승아 on 2/27/24.
//


import UIKit
class HomeScheduleCollectionCell: UICollectionViewCell {
  @IBOutlet weak var scheduleCollectionView: UICollectionView!
  
  var parentsViewController: HomeViewController?
  var scheduleList = [HouseModel]()
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.scheduleCollectionView.registerCell(type: HomeScheduleCell.self)
    self.scheduleCollectionView.registerCell(type: HomeEmptyScheduleCell.self)
    self.scheduleCollectionView.delegate = self
    self.scheduleCollectionView.dataSource = self
  }
  
    func setScheduleList(scheduleList: [HouseModel]) {
      self.scheduleList = scheduleList
      self.scheduleCollectionView.reloadData()
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension HomeScheduleCollectionCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row < self.scheduleList.count {
      let plan = self.scheduleList[indexPath.row]
      if plan.schedule_yn != "Y" {
        AJAlertController.initialization().showAlert(astrTitle: "\(plan.plan_name ?? "") 을(를) 완료하셨나요?", aStrMessage: "", aCancelBtnTitle: "취소", aOtherBtnTitle: "완료") { position, title in
          if position == 1 {
            // 완료
            self.parentsViewController?.todayScheduleEndAPI(schedule_idx: plan.schedule_idx ?? "", plan_idx: plan.plan_idx ?? "")
          }
        }
      } else {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "이미 수행하였어요.\n아직 완료하지 않은 일을 수행해 볼까요?", aStrMessage: "", alertViewHiddenCheck: false) { position, title in
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension HomeScheduleCollectionCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: ((self.parentsViewController?.view.frame.size.width ?? 0) - 47) / 2, height: 130)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension HomeScheduleCollectionCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScheduleCell", for: indexPath) as! HomeScheduleCell
    let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeEmptyScheduleCell", for: indexPath) as! HomeEmptyScheduleCell
    
    if indexPath.row > self.scheduleList.count - 1 {
      emptyCell.leftConstant.constant = 0
      return emptyCell
    } else {
      let schedule = self.scheduleList[indexPath.row]
      cell.setSchedule(schedule: schedule)
      return cell
    }
  }
  
  
}
