//
//  PhotoPopupViewController.swift
//  hollysome
//

import UIKit
import CropViewController
import DKImagePickerController

protocol PhotoUploadDelegate {
  func photoUploadDelegate(imgUrl: String)
}

class PhotoPopupViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var popupWrapView: UIView!
  @IBOutlet weak var cameraWrapView: UIView!
  @IBOutlet weak var albumWrapView: UIView!
  @IBOutlet weak var multiWrapView: UIView!
  @IBOutlet weak var deleteWrapView: UIView!
  @IBOutlet weak var closeView: UIView!
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var delegate: PhotoUploadDelegate?
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.popupWrapView.setCornerRadius(radius: 10)
  }
  
  override func initRequest() {
    super.initRequest()
    /// 카메라 선택
    self.cameraWrapView.addTapGesture { (recognizer) in
      let controller = UIImagePickerController()
      controller.delegate = self
      controller.sourceType = .camera
      self.present(controller, animated: true, completion: nil)
    }
    
    /// 앨범 단일 선택
    self.albumWrapView.addTapGesture { (recognizer) in
      let controller = UIImagePickerController()
      controller.delegate = self
      controller.sourceType = .photoLibrary
      self.present(controller, animated: true, completion: nil)
    }
    
    /// 앨범 다중 선택
    self.multiWrapView.addTapGesture { (recognizer) in
      let pickerController = DKImagePickerController()
      pickerController.showsCancelButton = true
      
      pickerController.didSelectAssets = { (assets: [DKAsset]) in
        var imageList = [Data]()
        for asset in assets {
          asset.fetchImageData { (data, _) in
//            let image = UIImage(data: data ?? Data()) ?? UIImage()
            if let data = data {
              imageList.append(data)
            }
            
//            let imageModel = FeedModel()
//            imageModel.imageData = image.jpegData(compressionQuality: 0.6) ?? Data()
//            self.imageModels.append(imageModel)
//            self.imageData.insert(image.jpegData(compressionQuality: 0.6) ?? Data(), at: self.imageData.count)
          }
        }
        

        self.dismiss(animated: true) {
          self.multiUploadImages(imageDataList: imageList)
        }
      }
      self.present(pickerController, animated: true) {}
    }
    
    self.deleteWrapView.addTapGesture { (recognizer) in
      self.dismiss(animated: true, completion: nil)
      self.delegate?.photoUploadDelegate(imgUrl: "")
    }
    
    self.closeView.addTapGesture { (recognizer) in
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 이미지 업로드
  ///
  /// - Parameter imageData: 업로드할 이미지 데이터
  func uploadImages(imageData : Data) {
//
//    log.debug(Date())
//    APIRouter.shared.api(path: .imageupload, file: imageData) { response in
//
//      if let fileResponse = FileModel(JSON: response) {
//        self.dismiss(animated: true) {
//          self.delegate?.photoUploadDelegate(imgUrl: fileResponse.result?.image_path ?? "")
//        }
//      }
//
//    } 
  }
  
  /// 다중 이미지 업로드
  ///
  /// - Parameter imageData: 업로드할 이미지 데이터
  func multiUploadImages(imageDataList : [Data]) {
//    
//    log.debug(Date())
//    APIRouter.shared.multiApi(path: .imageMultiUpload, fileList: imageDataList) { response in
//      
//      if let fileResponse = FileModel(JSON: response) {
//        if let imageList = fileResponse.result?.imageList {
//          for value in imageList {
//            log.debug(value.image_path ?? "")
//          }
//        }
//      }
//      
//    } 
  }
  
 
  @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
    //사진 저장 한후
    if let error = error {
      // we got back an error!
//      Toast(message: error.localizedDescription).show()
      log.debug(error.localizedDescription)
    } else {
      // save
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//-------------------------------------------------------------------------------------------
extension PhotoPopupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    imagePickerController(picker, pickedImage: image)
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    let cropController = CropViewController(croppingStyle: .default, image: pickedImage!)
    
    cropController.title = ""
    let rectWidth = pickedImage!.size.width
    let rectHeight = pickedImage!.size.width
    
    cropController.imageCropFrame = CGRect(x: 0, y: 0, width: rectWidth, height: rectHeight)
    cropController.rotateButtonsHidden = true
    cropController.rotateClockwiseButtonHidden = true
    cropController.aspectRatioPickerButtonHidden = true
    cropController.hidesNavigationBar = true
    cropController.resetAspectRatioEnabled = false
    cropController.aspectRatioLockEnabled = true
    cropController.aspectRatioLockDimensionSwapEnabled = false
    cropController.resetButtonHidden = true
    
    cropController.doneButtonTitle = "완료"
    cropController.cancelButtonTitle = "취소"
    cropController.cancelButtonColor = .white
    cropController.delegate = self
    
    
    picker.dismiss(animated: true) {
      let data = pickedImage?.jpegData(compressionQuality: 1)
      self.uploadImages(imageData: data ?? Data())
//      cropController.modalPresentationStyle = .fullScreen
//      self.present(cropController, animated: true, completion: nil)
    }
    
//    log.debug(pickedImage!)
//    let resizeImage = pickedImage!.resized(withPercentage: 0.1, isOpaque: true)
//    log.debug(resizeImage!)
//    UIImageWriteToSavedPhotosAlbum(resizeImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

  }
}

//-------------------------------------------------------------------------------------------
// MARK: - CropViewControllerDelegate
//-------------------------------------------------------------------------------------------
extension PhotoPopupViewController: CropViewControllerDelegate {
  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    let data = image.jpegData(compressionQuality: 1)
//    log.debug(image)
//    self.resize(image: image.cgImage!, scale: 0.5) { (image) in
//      log.debug(image)
//    }
    
    self.uploadImages(imageData: data ?? Data())
    cropViewController.dismiss(animated: true, completion: nil)
  }
  
}


