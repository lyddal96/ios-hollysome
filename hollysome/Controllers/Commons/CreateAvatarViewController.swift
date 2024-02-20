//
//  CreateAvatarViewController.swift
//  hollysome
//
//  Created by 이승아 on 10/9/23.
//
//

import UIKit

protocol AvatarDelegate {
  func avatarDelegate(selectedAvatar:[Int])
}
class CreateAvatarViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var avatarView: UIView!
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var shapeImageView: UIImageView!
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var shapeCollectionView: UICollectionView!
  @IBOutlet weak var faceCollectionView: UICollectionView!
  @IBOutlet weak var colorCollectionView: UICollectionView!
  @IBOutlet weak var finishButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var selectedAvatar: [Int] = [0,0,0]
  var memberRequest = MemberModel()
  var delegate: AvatarDelegate? = nil
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.shapeCollectionView.delegate = self
    self.shapeCollectionView.dataSource = self
    self.shapeCollectionView.registerCell(type: ImageCollectionCell.self)
    self.faceCollectionView.delegate = self
    self.faceCollectionView.dataSource = self
    self.faceCollectionView.registerCell(type: FaceCell.self)
    self.colorCollectionView.delegate = self
    self.colorCollectionView.dataSource = self
    self.colorCollectionView.registerCell(type: ProfileColorCell.self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.finishButton.setCornerRadius(radius: 12)
    
    self.setAvatarView()
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  func setAvatarView() {
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
    
    self.shapeImageView.image = UIImage(named: "\(shapeList[self.selectedAvatar[0]])119")
    
    self.faceImageView.image = UIImage(named: "face119_\(self.selectedAvatar[1])")
    
    self.colorView.backgroundColor = UIColor(named: "profile\(self.selectedAvatar[2])")
  }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 선택 완료
  /// - Parameter sender: 버튼
  @IBAction func finishButtonTouched(sender: UIButton) {
    self.delegate?.avatarDelegate(selectedAvatar: self.selectedAvatar)
    self.navigationController?.popViewController(animated: true)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension CreateAvatarViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var selected = 0
    if collectionView == self.faceCollectionView {
      selected = 1
    } else if collectionView == self.colorCollectionView {
      selected = 2
    }
    self.selectedAvatar[selected] = indexPath.row
    self.setAvatarView()
    collectionView.reloadData()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------≈
extension CreateAvatarViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.colorCollectionView {
      return 6
    }
    return 6
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == self.colorCollectionView {
      let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileColorCell", for: indexPath) as! ProfileColorCell
      colorCell.colorView.backgroundColor = UIColor(named: "profile\(indexPath.row)")
      colorCell.grayView.addBorder(width: 2, color: UIColor(named: indexPath.row == self.selectedAvatar[2] ? "accent" : "F1F1F4")!)
      return colorCell
    } else if collectionView == self.shapeCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
      cell.setCornerRadius(radius: 12)
      cell.backgroundColor = UIColor(named: "C8CCD5")
      let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
      cell.cellImageView.image = UIImage(named: "\(shapeList[indexPath.row])71")
      cell.addBorder(width: 2, color: UIColor(named: indexPath.row == self.selectedAvatar[0] ? "accent" : "F1F1F4")!)
      

      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaceCell", for: indexPath) as! FaceCell
      cell.setCornerRadius(radius: 12)
      cell.faceImageView.image = UIImage(named: "face\(indexPath.row)")
      cell.addBorder(width: 2, color: UIColor(named: indexPath.row == self.selectedAvatar[1] ? "accent" : "F1F1F4")!)
      
      return cell
    }
    
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension CreateAvatarViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 71, height: 71)
  }
}
