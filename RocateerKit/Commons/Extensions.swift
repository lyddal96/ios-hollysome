//
//  Extensions.swift
//  RocateerKit
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import UIKit
//-------------------------------------------------------------------------------------------
// MARK: - UITextField
//-------------------------------------------------------------------------------------------
extension UITextField {
  
  /// 플레이스 홀더 색상
  @IBInspectable var placeHolderColor: UIColor? {
    get {
      return self.placeHolderColor
    }
    set {
      self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
    }
  }
  
  
  func setTextPadding(_ amount:CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
    
    self.rightView = paddingView
    self.rightViewMode = .always
  }
  
  func setInputViewDatePicker(target: Any, selector: Selector, minimumDate: Date?, maximumDate: Date?) {
    self.tintColor = .clear
    // Create a UIDatePicker object and assign to inputView
    let screenWidth = UIScreen.main.bounds.width
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    if let minimumDate = minimumDate {
      datePicker.minimumDate = minimumDate
    }
    
    if let maximumDate = maximumDate {
      datePicker.maximumDate = maximumDate
    }
    datePicker.datePickerMode = .date
    if #available(iOS 14, *) {// Added condition for iOS 14
      datePicker.preferredDatePickerStyle = .wheels
      datePicker.sizeToFit()
    }
    self.inputView = datePicker
    
    // Create a toolbar and assign it to inputAccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancel = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(tapCancel))
    let barButton = UIBarButtonItem(title: "완료", style: .plain, target: target, action: selector)
    toolBar.setItems([cancel, flexible, barButton], animated: false)
    self.inputAccessoryView = toolBar
  }
  
  func setInputViewPicker(picker: UIPickerView, target: Any, selector: Selector) {
    self.tintColor = .clear
    // Create a UIDatePicker object and assign to inputView
    let screenWidth = UIScreen.main.bounds.width
//    let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    picker.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 216)
    self.inputView = picker
    
    // Create a toolbar and assign it to inputAccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancel = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(tapCancel))
    let barButton = UIBarButtonItem(title: "완료", style: .plain, target: target, action: selector)
    toolBar.setItems([cancel, flexible, barButton], animated: false)
    self.inputAccessoryView = toolBar
  }
  
  @objc func tapCancel() {
    self.resignFirstResponder()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UILabel
//-------------------------------------------------------------------------------------------
extension UILabel {
  func setTextSpacingBy(value: Double) {
    if let textString = self.text {
      let attributedString = NSMutableAttributedString(string: textString)
      attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
  
  func setLinespace(spacing: CGFloat) {
    if let text = self.text {
      let attributeString = NSMutableAttributedString(string: text)
      let style = NSMutableParagraphStyle()
      style.lineSpacing = spacing
      style.alignment = .center
      attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
      self.attributedText = attributeString
    }
  }

}

//-------------------------------------------------------------------------------------------
// MARK: - UITableView
//-------------------------------------------------------------------------------------------
extension UITableView {
  
  /// 테이블뷰 Cell 을 등록
  ///
  /// - Parameters:
  ///   - type: Cell 타입
  ///   - className: class 이름
  public func registerCell<T: UITableViewCell>(type: T.Type) {
    let className = String(describing: type)
    let nib = UINib(nibName: className, bundle: nil)
    register(nib, forCellReuseIdentifier: className)
  }
  
  
  /// 테이블뷰에 Cell을 여러개 등록
  ///
  /// - Parameter types: Cell 타입
  public func registerCells<T: UITableViewCell>(types: [T.Type]) {
    types.forEach {
      registerCell(type: $0)
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionView
//-------------------------------------------------------------------------------------------
extension UICollectionView {
  
  /// 컬렉션뷰에 Cell 을 등록
  ///
  /// - Parameter type: 타입
  public func registerCell<T: UICollectionViewCell>(type: T.Type) {
    let className = String(describing: type)
    let nib = UINib(nibName: className, bundle: nil)
    register(nib, forCellWithReuseIdentifier: className)
  }
  
  /// 컬렉션뷰에 Cell을 여러개 등록
  ///
  /// - Parameter types: 타입 배열
  public func registerCells<T: UICollectionViewCell>(types: [T.Type]) {
    types.forEach {
      registerCell(type: $0)
    }
  }
  
  
  /// 컬렉션뷰에 ReusableView 를 등록
  ///
  /// - Parameters:
  ///   - type: 타입
  ///   - kind: 기본 UICollectionView.elementKindSectionHeader
  public func registerReusableView<T: UICollectionReusableView>(type: T.Type, kind: String = UICollectionView.elementKindSectionHeader) {
    let className = String(describing: type)
    let nib = UINib(nibName: className, bundle: nil)
    register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
  }
  
  
  /// 컬렉션뷰에 ReusableView 를 여러개 등록
  ///
  /// - Parameters:
  ///   - types: 타입 배열
  ///   - kind: 기본 UICollectionView.elementKindSectionHeader
  public func registerReusableViews<T: UICollectionReusableView>(types: [T.Type], kind: String = UICollectionView.elementKindSectionHeader) {
    types.forEach {
      registerReusableView(type: $0, kind: kind)
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UINavigationBar
//-------------------------------------------------------------------------------------------
extension UINavigationBar {
  
  /// 네비게이션 바를 투명하게
  func transparentNavigationBar() {
    self.setBackgroundImage(UIImage(), for: .default)
    self.shadowImage = UIImage()
    self.isTranslucent = true
  }
  
  /// 네비게이션 타이틀 수정
  /// - Parameter title: 타이틀
  func setNavigationTitle(title: String) {
    self.topItem?.title = title
    self.topItem?.standardAppearance = UINavigationBar.appearance().standardAppearance
    self.topItem?.compactAppearance = UINavigationBar.appearance().compactAppearance
    self.topItem?.scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
    
    if #available(iOS 15, *) {
      self.topItem?.compactScrollEdgeAppearance = UINavigationBar.appearance().compactScrollEdgeAppearance
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UINavigationController
//-------------------------------------------------------------------------------------------
extension UINavigationController {
  
  /// 투명한 네비게이션 바를 만들어준다.
  public func presentTransparentNavigationBar() {
    navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
    navigationBar.isTranslucent = true
    navigationBar.shadowImage = UIImage()
    setNavigationBarHidden(false, animated:true)
  }
  
  
  /// 네비게이션 바를 사라지게 한다.
  public func hideTransparentNavigationBar() {
    setNavigationBarHidden(true, animated:false)
    navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
    navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
    navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - UIAlertController
//-------------------------------------------------------------------------------------------
extension UIAlertController {
  func show() {
    // TOP VIEW CONTROLLER
//    UIApplication.topViewController()?.present(self, animated: true, completion: nil)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIPageControl
//-------------------------------------------------------------------------------------------
extension UIPageControl {
  
  /// 페이지 컨트롤 모양
  ///
  /// - Parameters:
  ///   - dotFillColor: Dot 컬러
  ///   - dotBorderColor: Dot Border 컬러
  ///   - dotBorderWidth: Dot 보더 너비
  func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
    for (pageIndex, dotView) in self.subviews.enumerated() {
      if self.currentPage == pageIndex {
        dotView.backgroundColor = dotFillColor
        dotView.layer.cornerRadius = dotView.frame.size.height / 2
      }else{
        dotView.backgroundColor = .clear
        dotView.layer.cornerRadius = dotView.frame.size.height / 2
        dotView.layer.borderColor = dotBorderColor.cgColor
        dotView.layer.borderWidth = dotBorderWidth
      }
    }
  }
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UIImage
//-------------------------------------------------------------------------------------------
extension UIImage {
  class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    
    context.setStrokeColor(color.cgColor)
    context.setLineWidth(lineWidth)
    let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
    context.addEllipse(in: rect)
    context.strokePath()
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }
  func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIApplication
//-------------------------------------------------------------------------------------------
extension UIApplication {
  
  /// URL 외부 브라우저로 열기
  ///
  /// - Parameter url: 공통
  func openURL(url: String) {
    if let url = URL(string: url) {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      }
    }
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UIView
//-------------------------------------------------------------------------------------------
extension UIView {
  func constrainToEdges(_ subview: UIView) {
    
    subview.translatesAutoresizingMaskIntoConstraints = false
    
    let topContraint = NSLayoutConstraint(
      item: subview,
      attribute: .top,
      relatedBy: .equal,
      toItem: self,
      attribute: .top,
      multiplier: 1.0,
      constant: 0)
    
    let bottomConstraint = NSLayoutConstraint(
      item: subview,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: self,
      attribute: .bottom,
      multiplier: 1.0,
      constant: 0)
    
    let leadingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .leading,
      relatedBy: .equal,
      toItem: self,
      attribute: .leading,
      multiplier: 1.0,
      constant: 0)
    
    let trailingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: self,
      attribute: .trailing,
      multiplier: 1.0,
      constant: 0)
    
    addConstraints([
      topContraint,
      bottomConstraint,
      leadingContraint,
      trailingContraint])
  }
  // 지정 코너만 둥글게
  func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
    layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
  }
  
  
  func addShadow(cornerRadius: CGFloat) {
    layer.masksToBounds = false
    layer.cornerRadius = cornerRadius
    layer.shadowColor = UIColor(named: "000000")?.cgColor
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    layer.shadowOpacity = 0.2
    layer.shadowRadius = 3.0
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - CAShapeLayer
//-------------------------------------------------------------------------------------------
extension CAShapeLayer {
  func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
    fillColor = filled ? color.cgColor : UIColor.white.cgColor
    strokeColor = color.cgColor
    let origin = CGPoint(x: location.x - radius, y: location.y - radius)
    path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIBarButtonItem
//-------------------------------------------------------------------------------------------
private var handle: UInt8 = 0;
extension UIBarButtonItem {
  private var badgeLayer: CAShapeLayer? {
    if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
      return b as? CAShapeLayer
    } else {
      return nil
    }
  }
  
  func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = .red, andFilled filled: Bool = true) {
    guard let view = self.value(forKey: "view") as? UIView else { return }
    
    badgeLayer?.removeFromSuperlayer()
    
    var badgeWidth = 8
    var numberOffset = 4
    
    if number > 9 {
      badgeWidth = 12
      numberOffset = 6
    }
    
    // Initialize Badge
    let badge = CAShapeLayer()
    let radius = CGFloat(6)
    let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
//    let location = CGPoint(x: view.frame.width - (6 + offset.x), y: (radius + offset.y + 10))
    badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
    view.layer.addSublayer(badge)
    
    // Initialiaze Badge's label
    let label = CATextLayer()
    label.string = "\(number)"
    label.alignmentMode = CATextLayerAlignmentMode.center
    label.fontSize = 10
    label.frame = CGRect(origin: CGPoint(x: location.x - CGFloat(numberOffset), y: offset.y), size: CGSize(width: badgeWidth, height: 16))
    label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
    label.backgroundColor = UIColor.clear.cgColor
    label.contentsScale = UIScreen.main.scale
    badge.addSublayer(label)
    
    // Save Badge as UIBarButtonItem property
    objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
  
  func updateBadge(number: Int) {
    if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
      text.string = "\(number)"
    }
  }
  
  func removeBadge() {
    badgeLayer?.removeFromSuperlayer()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIScrollView
//-------------------------------------------------------------------------------------------
extension UIScrollView {
  func addTopBounceAreaView(color: UIColor = .white) {
    var frame = UIScreen.main.bounds
    frame.origin.y = -frame.size.height
    
    let view = UIView(frame: frame)
    view.backgroundColor = color
    
    self.addSubview(view)
  }
  
  func addBottomBounceAreaView(color: UIColor = .white) {
    var frame = UIScreen.main.bounds
    
    frame.origin.y += contentSize.height
    
    
    let view = UIView(frame: frame)
    view.backgroundColor = color
    
    self.addSubview(view)
  }
}
extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
