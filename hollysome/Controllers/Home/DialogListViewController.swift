//
//  DialogListViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/05/30.
//  Copyright © 2023 rocateer. All rights reserved.
//

import UIKit
import DKImagePickerController
import CropViewController

class DialogListViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var toastButton: UIButton!
  @IBOutlet weak var confirmDialogButton: UIButton!
  @IBOutlet weak var twoButtonDialogButton: UIButton!
  @IBOutlet weak var bottomConfirmDialogButton: UIButton!
  @IBOutlet weak var bottomTwoButtonDialogButton: UIButton!
  @IBOutlet weak var oneDayButton: UIButton!
  @IBOutlet weak var periodButton: UIButton!
  @IBOutlet weak var multiImageButton: UIButton!
  @IBOutlet weak var oneImageButton: UIButton!
  @IBOutlet weak var photoCollectionView: UICollectionView!
  @IBOutlet weak var lastImageView: UIImageView!
  @IBOutlet weak var imagePageControl: UIPageControl!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  
  var imageModel = [String]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.photoCollectionView.registerCell(type: BannerImageCell.self)
    self.photoCollectionView.delegate = self
    self.photoCollectionView.dataSource = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.toastButton.addShadow(cornerRadius: 25)
    self.confirmDialogButton.addShadow(cornerRadius: 25)
    self.twoButtonDialogButton.addShadow(cornerRadius: 25)
    self.bottomConfirmDialogButton.addShadow(cornerRadius: 25)
    self.bottomTwoButtonDialogButton.addShadow(cornerRadius: 25)
    self.oneDayButton.addShadow(cornerRadius: 25)
    self.periodButton.addShadow(cornerRadius: 25)
    self.multiImageButton.addShadow(cornerRadius: 25)
    self.oneImageButton.addShadow(cornerRadius: 25)
    
    
    self.photoCollectionView.isHidden = true
    self.imagePageControl.isHidden = true
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
  /// 이미지 업로드
  ///
  /// - Parameter imageData: 업로드할 이미지
  func uploadImages(imageData : Data) {
    
    APIRouter.shared.api(path: .imageupload, file: imageData) { response in
      if let imageResponse = ImageModel(JSON: response), Tools.shared.isSuccessResponse(response: imageResponse) {

        if let result = imageResponse.result {
          self.imageModel.append(result.path ?? "")
        }
        self.photoCollectionView.reloadData()
        self.photoCollectionView.isHidden = false
        self.imagePageControl.isHidden = false
        self.imagePageControl.numberOfPages = self.imageModel.count
      }
    }
  }
  
  /// 다중 이미지 업로드 동기식
  /// - Parameter imageData: 이미지 배열
  func multiImageUpload(imageData: [Data]) {
    
    APIRouter.shared.multiApi(path: .imageMultiUpload, fileList: imageData) { response in
      
      if let imageResponse = ImageModel(JSON: response), Tools.shared.isSuccessResponse(response: imageResponse) {
        
        if let data = imageResponse.result?.data {
          for value in data {
            self.imageModel.append(value.path ?? "")
          }
        }
        self.photoCollectionView.reloadData()
        self.photoCollectionView.isHidden = false
        self.imagePageControl.isHidden = false
        self.imagePageControl.numberOfPages = self.imageModel.count
      }
      
    }
  }
  
  /// 이미지 크롭
  func cropImageAction(image: UIImage) {
    let cropController = CropViewController(croppingStyle: .default, image: image)
    
    cropController.title = ""

    cropController.rotateButtonsHidden = true
    cropController.rotateClockwiseButtonHidden = true
    cropController.aspectRatioPickerButtonHidden = true
    cropController.hidesNavigationBar = true
    cropController.resetAspectRatioEnabled = false
    cropController.aspectRatioLockEnabled = false
    cropController.aspectRatioLockDimensionSwapEnabled = false
    cropController.resetButtonHidden = true
    
    cropController.doneButtonTitle = "완료"
    cropController.cancelButtonTitle = "취소"
    cropController.cancelButtonColor = .white
    cropController.delegate = self
    
    cropController.modalPresentationStyle = .fullScreen
    self.present(cropController, animated: true, completion: nil)
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 토스트 보기
  /// - Parameter sender: 버튼
  @IBAction func toastButtonTouched(sender: UIButton) {
//    Tools.shared.showToast(message: "토스트 예시입니다.")
    Tools.shared.showToastWithImage(message: "토스트 예시입니다.", image: UIImage(named: "ios_app_icon")!)
  }
  /// 확인 다이얼로그 보기
  /// - Parameter sender: 버튼
  @IBAction func confirmDialogButtonTouched(sender: UIButton) {
    AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "확인 알림 예시입니다.", alertViewHiddenCheck: false) { position, title in
      if position == 0 {
        Tools.shared.showToast(message: "확인을 눌렀습니다.")
      }
    }
  }
  /// 확인/취소 다이얼로그 보기
  /// - Parameter sender: 버튼
  @IBAction func twoButtonDialogButtonTouched(sender: UIButton) {
    AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "확인/취소 알림 예시입니다.", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
      if position == 1 {
        Tools.shared.showToast(message: "확인을 눌렀습니다.")
      }
    }
  }
  /// 바텀 확인 다이얼로그 보기
  /// - Parameter sender: 버튼
  @IBAction func bottomConfirmDialogButtonTouched(sender: UIButton) {
    BottomAJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "바텀 확인 알림 예시입니다.", alertViewHiddenCheck: false) { position, title in
      if position == 0 {
        Tools.shared.showToast(message: "확인을 눌렀습니다.")
      }
    }
  }
  /// 바텀 확인/취소 다이얼로그 보기
  /// - Parameter sender: 버튼
  @IBAction func bottomTwoButtonDialogButtonTouched(sender: UIButton) {
    BottomAJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "바텀 확인/취소 알림 예시입니다.", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
      if position == 1 {
        Tools.shared.showToast(message: "확인을 눌렀습니다.")
      }
    }
  }
  /// 날짜 단일 선택 보기
  /// - Parameter sender: 버튼
  @IBAction func oneDayButtonTouched(sender: UIButton) {
    let destination = CalendarViewController.instantiate(storyboard: "Home")
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
    
//    let detination = CalandarTestViewController.instantiate(storyboard: "Home")
//    self.present(detination, animated: true)
  }
  /// 날짜 범위 선택 보기
  /// - Parameter sender: 버튼
  @IBAction func periodButtonTouched(sender: UIButton) {
    let destination = MultiSelectCalendarViewController.instantiate(storyboard: "Home")
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
  /// 이미지 다중 선택 보기
  /// - Parameter sender: 버튼
  @IBAction func multiImageButtonTouched(sender: UIButton) {
    let pickerController = DKImagePickerController()
    pickerController.navigationBar.backgroundColor = .white
    pickerController.assetType = .allPhotos
    pickerController.showsCancelButton = true
    pickerController.allowSwipeToSelect = true
//      pickerController.maxSelectableCount = 5 - self.imageModel.count
    pickerController.maxSelectableCount = 10
    
    pickerController.didSelectAssets = { (assets: [DKAsset]) in
      var imageList = [Data]()
      for asset in assets {
        asset.fetchImageData { (data, _) in
          
          if let data = data {
            let image = UIImage(data: data) ?? UIImage()
            let imageData = image.jpegData(compressionQuality: 0.1)
            imageList.append(imageData ?? Data())
            if assets.count == 1 {
              self.cropImageAction(image: image)
            } else {
              if assets.count == imageList.count {
                self.multiImageUpload(imageData: imageList)
              }
            }
            
          }
        }
      }
      
    }
    self.present(pickerController, animated: true) {}
  }
  /// 이미지 단일 선택 보기
  /// - Parameter sender: 버튼
  @IBAction func oneImageButtonTouched(sender: UIButton) {

    let pickerController = DKImagePickerController()
    pickerController.navigationBar.backgroundColor = .white
    pickerController.assetType = .allPhotos
    pickerController.showsCancelButton = true
    pickerController.allowSwipeToSelect = true
    pickerController.sourceType = .both
    pickerController.singleSelect = true
    
    pickerController.didSelectAssets = { (assets: [DKAsset]) in
      for asset in assets {
        asset.fetchImageData { (data, _) in
          
          if let data = data {
            let image = UIImage(data: data) ?? UIImage()
            let imageData = image.jpegData(compressionQuality: 0.1)
            self.cropImageAction(image: image)
          }
        }
      }
      
    }
    self.present(pickerController, animated: true) {}
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension DialogListViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageWidth = self.photoCollectionView.frame.width
    let currentPage = Int(self.photoCollectionView.contentOffset.x / pageWidth)
    self.imagePageControl.currentPage = currentPage
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension DialogListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.imageModel.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCell", for: indexPath) as! BannerImageCell
    cell.bannerImageView.contentMode = .scaleAspectFit
    cell.bannerImageView.sd_setImage(with: URL(string: Tools.shared.imageUrl(path: self.imageModel[indexPath.row])))
    
    return cell
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension DialogListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.size.width - 40, height: 300)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - CropViewControllerDelegate
//-------------------------------------------------------------------------------------------
extension DialogListViewController: CropViewControllerDelegate {
  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    let resizeImage = image.resized(toWidth: 1000, isOpaque: true)
    let data = resizeImage?.jpegData(compressionQuality: 0.6) ?? Data()
    self.uploadImages(imageData: data)
    
    cropViewController.dismiss(animated: true, completion: nil)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - DateSelectDelegate
//-------------------------------------------------------------------------------------------
extension DialogListViewController: DateSelectDelegate {
  func singleSelectDelegate(date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    Tools.shared.showToast(message: "\(dateFormatter.string(from: date))")
  }
  
  func multiSelectDelegate(startDate: Date, endDate: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    Tools.shared.showToast(message: "\(dateFormatter.string(from: startDate)) ~ \(dateFormatter.string(from: endDate))")
  }
}
