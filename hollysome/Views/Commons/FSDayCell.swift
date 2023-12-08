//
//  FSDayCell.swift
//  hollysome
//
//  Created by 이승아 on 2023/06/02.
//

import Foundation
import FSCalendar
import UIKit


class FSDayCell: FSCalendarCell {
 
  @IBOutlet weak var leftView: UIView!
  @IBOutlet weak var rightView: UIView!
  @IBOutlet weak var circleView: UIView!
  
  var cellWidth: CGFloat = 0
  var currentDate = Date()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // 선택 영역 세팅
  func setConfigureCell() {
//    let height = self.cellWidth // Cell 가로길이 계산
//    self.circleView.setCornerRadius(radius: 10)

  }
  
  // 선택영역 전부 삭제
  func removeSelectionView() {
//    self.circleView.isHidden = true
//    self.bottomView.isHidden = true
  }
  
}
