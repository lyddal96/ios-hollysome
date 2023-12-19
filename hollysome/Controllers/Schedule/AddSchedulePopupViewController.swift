//
//  AddSchedulePopupViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/18/23.
//

import UIKit

protocol ScheduleAddDelegate {
  func scheduleAddDelegate()
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
  
  var selectedMate = [Int]()
  var selectedWeek = [Int]()
  var weekList = ["월", "화", "수", "목", "금", "토", "일"]
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
                self.delegate?.scheduleAddDelegate()
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
  @IBAction func addButtnTouched(sender: UIButton) {
    self.hideCardAndGoBack(type: 0)
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
      if self.selectedMate.contains(indexPath.row) {
        self.selectedMate.removeAll(indexPath.row)
      } else {
        self.selectedMate.append(indexPath.row)
      }
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
      return 3
    } else {
      return 7
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == mateCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
      cell.setMate(index: indexPath)
      cell.nameLabel.text = "메이트\(indexPath.row)"
      
      cell.selectImageView.isHidden = !self.selectedMate.contains(indexPath.row)
      
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
