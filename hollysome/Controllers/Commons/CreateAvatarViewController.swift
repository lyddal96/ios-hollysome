//
//  CreateAvatarViewController.swift
//  hollysome
//
//  Created by 이승아 on 10/9/23.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit

class CreateAvatarViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var avatarView: UIView!
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
    self.avatarView.setCornerRadius(radius: 12)
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
    self.avatarView.backgroundColor = UIColor(named: "profile\(self.selectedAvatar[2])")
    let shapeList = ["round", "clover", "heart", "square", "cloud", "star"]
//    colorCell.colorView.backgroundColor = UIColor(named: "profile\(indexPath)")
//    colorCell.grayView.addBorder(width: 2, color: UIColor(named: indexPath.row == self.selectedAvatar[2] ? "accent" : "F1F1F4")!)
//    return colorCell
//  } else if collectionView == self.shapeCollectionView {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
//    cell.setCornerRadius(radius: 12)

//    cell.cellImageView.image = UIImage(named: "\(shapeList[indexPath.row])71")
//    cell.addBorder(width: 2, color: UIColor(named: indexPath.row == self.selectedAvatar[0] ? "accent" : "F1F1F4")!)
//    
//
//    return cell
//  } else {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaceCell", for: indexPath) as! FaceCell
//    cell.setCornerRadius(radius: 12)
//    cell.faceImageView.image = UIImage(named: "face\(indexPath.row + 1)")
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension CreateAvatarViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.selectedAvatar[indexPath.section] = indexPath.row
    collectionView.reloadData()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------≈
extension CreateAvatarViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.colorCollectionView {
      return 5
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
      cell.faceImageView.image = UIImage(named: "face\(indexPath.row + 1)")
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