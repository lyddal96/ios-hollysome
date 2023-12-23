//
//  AddSchedulePopupViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit
import Defaults
protocol ScheduleAddDelegate {
  func scheduleAddDelegate(weekList: [Int], mateList: [MemberModel])
}

class AddSchedulePopupViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var weekCollectionView: UICollectionView!
  @IBOutlet weak var mateCollectionView: UICollectionView!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var delegate: ScheduleAddDelegate?

  var popupHeight: CGFloat = 0
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0

//  var selectedMate = [Int]()
  var selectedWeek = [Int]()
  var weekList = ["일", "월", "화", "수", "목", "금", "토"]
  var mateList = [MemberModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()

    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding

    self.weekCollectionView.registerCell(type: WeekCell.self)
    self.weekCollectionView.delegate = self
    self.weekCollectionView.dataSource = self

    self.mateCollectionView.registerCell(type: MateCell.self)
    self.mateCollectionView.delegate = self
    self.mateCollectionView.dataSource = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func initLayout() {
    super.initLayout()

    self.addButton.setCornerRadius(radius: 12)
    self.popupHeight = 548
  }

  override func initRequest() {
    super.initRequest()

    self.mateListAPI()
    self.dimmerView.addTapGesture { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }

    self.dimmerView.addSwipeGesture(direction: UISwipeGestureRecognizer.Direction.down) { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }

  }

  override func initLocalize() {
    super.initLocalize()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showCard()
  }


  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 메이트 리스트
  func mateListAPI() {
    let mateRequest = MemberModel()
    mateRequest.member_idx = Defaults[.member_idx]
    mateRequest.house_idx = Defaults[.house_idx]
    mateRequest.house_code = Defaults[.house_code]

    APIRouter.shared.api(path: .mate_list, method: .post, parameters: mateRequest.toJSON()) { response in
      if let mateResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: mateResponse) {
        if let data_array = mateResponse.data_array, data_array.count > 0 {
          self.mateList = data_array
        }
        self.mateCollectionView.reloadData()
      }
    }
  }
  /// 카드 보이기
  private func showCard() {
    self.view.layoutIfNeeded()

    self.cardViewTopConstraint.constant = self.view.frame.size.height - (self.popupHeight + bottomPadding + self.statusHeight)

    let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })

    showCard.addAnimations({
      self.dimmerView.alpha = 0.7
    })

    showCard.startAnimation()

  }

  /// 카드 숨기면서 화면 닫기
  private func hideCardAndGoBack(type: Int?) {
    self.view.layoutIfNeeded()
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding

    let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })

    hideCard.addAnimations {
      self.dimmerView.alpha = 0.0
    }

    hideCard.addCompletion({ position in
      if position == .end {
        if(self.presentingViewController != nil) {
          self.dismiss(animated: false) {
            if type != nil {
              if type == 0 {
                self.delegate?.scheduleAddDelegate(weekList: self.selectedWeek, mateList: self.mateList.filter({ $0.isSelected == true }))
              }
            }
          }
        }
      }
    })

    hideCard.startAnimation()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 추가하기
  /// - Parameter sender: 버튼
  @IBAction func addButtnTouched(sender: UIButton) {
    if self.selectedWeek.count > 0 && self.mateList.filter({ $0.isSelected == true }).count > 0 {
      self.hideCardAndGoBack(type: 0)
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension AddSchedulePopupViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == self.weekCollectionView {
      if self.selectedWeek.contains(indexPath.row) {
        self.selectedWeek.removeAll(indexPath.row)
      } else {
        self.selectedWeek.append(indexPath.row)
      }

      self.weekCollectionView.reloadData()
    } else {
//      if self.selectedMate.contains(indexPath.row) {
//        self.selectedMate.removeAll(indexPath.row)
//      } else {
//        self.selectedMate.append(indexPath.row)
//      }
      self.mateList[indexPath.row].isSelected = !(self.mateList[indexPath.row].isSelected ?? false)
      self.mateCollectionView.reloadData()
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension AddSchedulePopupViewController: UICollectionViewDelegateFlowLayout {
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
extension AddSchedulePopupViewController: UICollectionViewDataSource {
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
      cell.setMate(mate: mate)
      
      cell.selectImageView.isHidden = !(mate.isSelected ?? false)

      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCell

      if self.selectedWeek.contains(indexPath.row) {
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
