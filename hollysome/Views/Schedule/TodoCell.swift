//
//  TodoCell.swift
//  hollysome
//
//  Created by 이승아 on 12/27/23.
//

import UIKit

class TodoCell: UITableViewCell {
  @IBOutlet weak var weekCollectionView: UICollectionView!
  @IBOutlet weak var mateCollectionView: UICollectionView!
  
  
  var mateList = [PlanModel]()
  var week_arr = ""
  var weekList = ["일", "월", "화", "수", "목", "금", "토"]
  var plan_idx = ""
  
  var parentsViewController: TodoListPageViewController?
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.mateCollectionView.registerCell(type: MateCell.self)
    self.mateCollectionView.delegate = self
    self.mateCollectionView.dataSource = self
    
    self.weekCollectionView.registerCell(type: WeekCell.self)
    self.weekCollectionView.delegate = self
    self.weekCollectionView.dataSource = self
    
    self.weekCollectionView.addTapGesture { recognizer in
      let viewController = AddScheduleViewController.instantiate(storyboard: "Schedule")
      viewController.enrollType = .modify
      viewController.plan_idx = self.plan_idx
      let destination = viewController.coverNavigationController()
      destination.hero.isEnabled = true
      destination.heroModalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.parentsViewController?.parentsViewController?.tabBarController?.present(destination, animated: true)
    }
    
    if self.mateCollectionView.contentSize.width < (self.parentsViewController?.parentsViewController?.view.frame.size.width ?? 0) - 32 {
      self.mateCollectionView.addTapGesture { recognizer in
        let viewController = AddScheduleViewController.instantiate(storyboard: "Schedule")
        viewController.enrollType = .modify
        viewController.plan_idx = self.plan_idx
        let destination = viewController.coverNavigationController()
        destination.hero.isEnabled = true
        destination.heroModalAnimationType = .autoReverse(presenting: .cover(direction: .left))
        destination.modalPresentationStyle = .fullScreen
        self.parentsViewController?.parentsViewController?.tabBarController?.present(destination, animated: true)
      }
    }
  }
  
  func setTodo(plan: PlanModel) {
    self.week_arr = plan.week_arr ?? ""
    self.mateList = plan.schedule_member_list ?? [PlanModel]()
    
    self.mateCollectionView.reloadData()
    self.weekCollectionView.reloadData()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension TodoCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension TodoCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == self.mateCollectionView {
      return CGSize(width: 52, height: 74)
    } else {
      return CGSize(width: 32, height: 32)
    }

  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension TodoCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.mateCollectionView {
      return self.mateList.count
    } else {
      return 7
    }

  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == mateCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
      let mate = self.mateList[indexPath.row]
      cell.shapeImageView.image = UIImage(named: "\(Constants.SHAPE_LIST[mate.member_role1?.toInt() ?? 0])71")
      cell.faceImageView.image = UIImage(named: "face\(mate.member_role2?.toInt() ?? 0)")
      cell.colorView.backgroundColor = UIColor(named: "profile\(mate.member_role3?.toInt() ?? 0)")
      cell.nameLabel.text = mate.member_nickname ?? ""
//      cell.selectImageView.isHidden = !(mate.isSelected ?? false)

      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCell

      if self.week_arr.contains("\(indexPath.row + 1)") {
        cell.roundView.backgroundColor = UIColor(named: "accent")
        cell.weekLabel.textColor = UIColor(named: "FFFFFF")
      } else {
        cell.roundView.backgroundColor = UIColor(named: "E4E6EB")
        cell.weekLabel.textColor = UIColor(named: "C8CCD5")
      }
      cell.weekLabel.text = self.weekList[indexPath.row]

      return cell
    }
  }
}
