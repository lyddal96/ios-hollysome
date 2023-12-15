//
//  MakeHouseViewController.swift
//  hollysome
//
//  Created by 이승아 on 12/14/23.
//

import UIKit
import Defaults

class MakeHouseViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var houseImageView: UIImageView!
  @IBOutlet weak var imageButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var image_path: String? = nil
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
    
    self.nextButton.setCornerRadius(radius: 12)
    self.nameTextField.setCornerRadius(radius: 4)
    self.nameTextField.setTextPadding(10)
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
  /// 하우스 만들기 API
  func houseRegAPI() {
    let houseRequest = HouseModel()
    houseRequest.member_idx = Defaults[.member_idx]
    houseRequest.house_name = self.nameTextField.text
    houseRequest.house_img = ""
    
    APIRouter.shared.api(path: .house_reg_in, method: .post, parameters: houseRequest.toJSON()) { response in
      if let houseResponse = HouseModel(JSON: response), Tools.shared.isSuccessResponse(response: houseResponse, alertYn: true) {
        Defaults[.house_code] = houseResponse.house_code
        let destination = MakeFinishViewController.instantiate(storyboard: "Home")
        destination.house_code = houseResponse.house_code ?? ""
        destination.hidesBottomBarWhenPushed = true
        if var viewControllers = self.navigationController?.viewControllers {
          viewControllers.removeLast()
          viewControllers.append(destination)
          self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
      }
    }
  }
  
  /// 이미지 업로드
  ///
  /// - Parameter imageData: 업로드할 이미지
  func uploadImages(imageData : Data) {
    
    APIRouter.shared.api(path: .fileUpload_action, file: imageData) { response in
      if let fileResponse = FileModel(JSON: response), Tools.shared.isSuccessResponse(response: fileResponse) {
        
        self.image_path = fileResponse.file_path
        self.houseImageView.sd_setImage(with: URL(string: "\(baseURL)\(self.image_path ?? "")"), placeholderImage: UIImage(named: "default_image"), options: .lowPriority, context: nil)
      }
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 추가하기
  /// - Parameter sender: 버튼
  @IBAction func imageButtonTouched(sender: UIButton) {
    let destination = CardPopupViewController.instantiate(storyboard: "Main")
    destination.cameraIsHidden = false
    destination.albumIsHidden = false
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
  /// 다음
  /// - Parameter sender: 버튼
  @IBAction func nextButtonTouched(sender: UIButton) {
    self.houseRegAPI()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - CardPopupSelectDelegate
//-------------------------------------------------------------------------------------------
extension MakeHouseViewController: CardPopupSelectDelegate {
  func albumTouched() {
    let controller = UIImagePickerController()
    controller.delegate = self
    controller.sourceType = .photoLibrary
    self.present(controller, animated: true, completion: nil)
  }
  
  func cameraTouched() {
    let controller = UIImagePickerController()
    controller.delegate = self
    controller.sourceType = .camera
    self.present(controller, animated: true, completion: nil)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//-------------------------------------------------------------------------------------------
extension MakeHouseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      imagePickerController(picker, pickedImage: image)
    }
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    picker.dismiss(animated: false) {
      let resizeImage = pickedImage!.resized(toWidth: 1000, isOpaque: true)
      let data = resizeImage?.jpegData(compressionQuality: 0.6) ?? Data()
      
      self.uploadImages(imageData: data)
    }
  }
}
