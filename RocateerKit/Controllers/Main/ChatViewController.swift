//
//  ReplyViewController.swift
//  RocateerKit
//
//  Created by rocateer on 2020/01/09.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import IQKeyboardManagerSwift
import StringStylizer
import SKPhotoBrowser
import CropViewController

class ChatViewController: MessagesViewController, MessagesDataSource {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var messageList: [MockMessage] = []
  
  let refreshControl = UIRefreshControl()
  
  let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy. MM. dd"
    return formatter
  }()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IQKeyboardManager.shared.enable = false

    self.configureMessageCollectionView()
    self.configureMessageInputBar()
    self.loadFirstMessages()
    
    scrollsToBottomOnKeyboardBeginsEditing = true // default false
    maintainPositionOnKeyboardFrameChanged = true // default false
  }
  
  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    if isTimeLabelVisible(at: indexPath) {
      let date = formatter.string(from: message.sentDate).stylize().font(UIFont.systemFont(ofSize: 14)).color(UIColor(named: "999999")!).attr
      return date
    }
    return nil
  }
  
  func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    let name = "김미나".stylize().font(UIFont.systemFont(ofSize: 14)).color(UIColor(named: "333333")!).attr
    let discription = " 비품 담당".stylize().font(UIFont.systemFont(ofSize: 12)).color(UIColor(named: "666666")!).attr
    
    return name + discription
  }

  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 뷰컨트롤러에 네비게이션 컨트롤러를 추가해 준다.
  ///
  /// - Returns: UINavigationController
  func coverNavigationController() -> UINavigationController {
    let navigationController = UINavigationController(rootViewController: self)
    navigationController.hero.isEnabled = true
    return navigationController
  }
  
  private func makeButton(named: String) -> InputBarButtonItem {
    return InputBarButtonItem()
      .configure {
        $0.image = UIImage(named: named)!
        $0.setSize(CGSize(width: 32, height: 32), animated: false)
        $0.tintColor = UIColor(white: 0.8, alpha: 1)
    }.onSelected {
      $0.tintColor = UIColor(named: "999999")!
    }.onDeselected {
      $0.tintColor = UIColor(white: 0.8, alpha: 1)
    }.onTouchUpInside { _ in
      let actionSheet = UIAlertController(title: "사진 등록", message: nil, preferredStyle: .actionSheet)
      actionSheet.addAction(UIAlertAction(title: "사진 촬영", style: .default, handler: { (action) in
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        self.present(controller, animated: true, completion: nil)
      }))
      actionSheet.addAction(UIAlertAction(title: "앨범에서 선택", style: .default, handler: { (action) in
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        self.present(controller, animated: true, completion: nil)
      }))
      actionSheet.view.tintColor = .black
      actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
      let topViewController = UIApplication.shared.windows.last!.rootViewController!
      topViewController.present(actionSheet, animated: true, completion: nil)

    }
  }

  private func configureMessageCollectionView() {
    self.messagesCollectionView.messagesDataSource = self
    self.messagesCollectionView.messageCellDelegate = self
    
    self.messagesCollectionView.backgroundColor = UIColor(named: "FAFAFA")
    self.messagesCollectionView.addSubview(self.refreshControl)
    self.refreshControl.addTarget(self, action: #selector(self.loadMoreMessages), for: .valueChanged)
    
    let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
    layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
    
    // 받은 메세지
    //   프로필 이미지
    layout?.setMessageIncomingAvatarSize(CGSize(width: 39, height: 39))
    layout?.setMessageIncomingAvatarPosition(.init(vertical: .messageLabelTop))
    //   CellBottomLabel
    layout?.setMessageIncomingCellBottomLabelAlignment(.init(textAlignment: .right, textInsets: .zero))
    //   MessageTopLabel
    layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)))
    //   Message 주변 padding
    layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    
    //   Accessory
    layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 12))
    layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 6, right: 0))
    layout?.setMessageIncomingAccessoryViewPosition(.messageBottom)
    
    // 보낸 메세지
    //   프로필 이미지
    layout?.setMessageOutgoingAvatarSize(.zero)
    //   CellBottomLabel
    layout?.setMessageOutgoingCellBottomLabelAlignment(.init(textAlignment: .right, textInsets: .zero))
    //   MessageTopLabel
    layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)))
    //   Message 주변 padding
    layout?.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

    //   Accessory
    layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 12))
    layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 6))
    layout?.setMessageOutgoingAccessoryViewPosition(.messageBottom)
    

    layout?.textMessageSizeCalculator.messageLabelFont = UIFont.systemFont(ofSize: 16)
    
    self.messagesCollectionView.messagesLayoutDelegate = self
    self.messagesCollectionView.messagesDisplayDelegate = self
  }
  
  func currentSender() -> SenderType {
    return SampleData.shared.currentSender
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messageList[indexPath.section]
  }
  
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messageList.count
  }
  
  private func configureMessageInputBar() {
    messageInputBar.delegate = self
    messageInputBar.isTranslucent = false
    messageInputBar.backgroundView.backgroundColor = .white
    messageInputBar.separatorLine.isHidden = false
    messageInputBar.separatorLine.backgroundColor = UIColor(named: "DDDDDD")!
    messageInputBar.backgroundColor = .white
    messageInputBar.padding = UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)
    messageInputBar.inputTextView.tintColor = UIColor(named: "00AA7D")!
    messageInputBar.inputTextView.placeholderLabel.text = "채팅을 입력해주세요."
    messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: -2, bottom: 8, right: 42)
    messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 42)
    messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 42)
    messageInputBar.inputTextView.font = UIFont.systemFont(ofSize: 16)
    
    messageInputBar.middleContentViewPadding.right = -58
    messageInputBar.middleContentViewPadding.left = 14
    messageInputBar.maxTextViewHeight = 110
    
    // 카메라 이미지는 우측 input창에 맞춰 하단에 빈공간이 포함한 이미지여야함(현재 이미지는 빈공간이 없어 이미지가 밑으로 치우쳐짐)
    let items = [makeButton(named: "btn_photo_blue")]
    messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
    messageInputBar.setStackViewItems(items, forStack: .left, animated: false)
    messageInputBar.leftStackView.setup()
    
    
    configureInputBarItems()
  }
  
  private func configureInputBarItems() {
    messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
    messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
    messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 2, right: 2)
    messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
    messageInputBar.sendButton.image = #imageLiteral(resourceName: "btn_send")
    messageInputBar.sendButton.title = nil
    messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
    messageInputBar.middleContentViewPadding.right = -40
    
    
    // This just adds some more flare
    messageInputBar.sendButton
      .onEnabled { item in
        UIView.animate(withDuration: 0.3, animations: {
          item.imageView?.backgroundColor = UIColor(named: "419A6F")
        })
    }.onDisabled { item in
      UIView.animate(withDuration: 0.3, animations: {
        item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
      })
    }
  }
  
  // MARK: - Helpers
  func insertMessage(_ message: MockMessage) {
    messageList.append(message)
    messageInputBar.inputTextView.text = String()
    // Reload last section to update header/footer labels and insert a new one
    messagesCollectionView.performBatchUpdates({
      messagesCollectionView.insertSections([messageList.count - 1])
      if messageList.count >= 2 {
        messagesCollectionView.reloadSections([messageList.count - 2])
      }
    }, completion: { [weak self] _ in
      if self?.isLastSectionVisible() == true {
        self?.messagesCollectionView.scrollToBottom(animated: true)
      }
    })
  }
  
  
  func isLastSectionVisible() -> Bool {
    
    guard !messageList.isEmpty else { return false }
    
    let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
    
    return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
  }
  
  func loadFirstMessages() {
    DispatchQueue.global(qos: .userInitiated).async {
      let count = UserDefaults.standard.mockMessagesCount()
      SampleData.shared.getMessages(count: count) { messages in
        DispatchQueue.main.async {
          self.messageList = messages
          self.messagesCollectionView.reloadData()
          self.messagesCollectionView.scrollToBottom()
        }
      }
    }
  }
  
  @objc
  func loadMoreMessages() {
    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
      SampleData.shared.getMessages(count: 20) { messages in
        DispatchQueue.main.async {
          self.messageList.insert(contentsOf: messages, at: 0)
          self.messagesCollectionView.reloadDataAndKeepOffset()
          self.refreshControl.endRefreshing()
        }
      }
    }
  }
  
  
  // MARK: - Helpers
  
  func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
    return indexPath.section % 4 == 0 //&& !isPreviousMessageSameSender(at: indexPath)
  }
  
  /// 이미지 업로드
  ///
  /// - Parameter imageData: 업로드할 이미지 데이터
  func uploadImages(imageData : Data) {
//    let param = ["": ""]
//
//    APIRouter.shared.api(path: .fileUpload_action, file: imageData) { response in
//      if let fileResponse = FileModel(JSON: response) {
//        if fileResponse.code == "1000" {
//          let imageView = UIImageView()
//          imageView.sd_setImage(with: URL(string: fileResponse.file_path ?? ""), completed: nil)
//          
//          self.insertMessage(MockMessage.init(image: UIImage(data: imageData)!, user: MockUser(senderId: SampleData.shared.currentSender.senderId, displayName: SampleData.shared.currentSender.displayName), messageId: "", date: Date()))
//          
//        }
//      }
//      
//    } 
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
//-------------------------------------------------------------------------------------------
// MARK: - MessageCellDelegate
//-------------------------------------------------------------------------------------------
extension ChatViewController: MessageCellDelegate {
  
  func didTapAvatar(in cell: MessageCollectionViewCell) {
    print("Avatar tapped")
  }
  
  func didTapMessage(in cell: MessageCollectionViewCell) {
    print("Message tapped")
  }
  
  func didTapImage(in cell: MessageCollectionViewCell) {
    print("Image tapped")
    guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
     return
    }
    
    let message = self.messageList[indexPath.section].self
    
    guard case .photo(let mediaItem) = message.kind else {
        return
    }

    var images = [SKPhoto]()
    let photo = SKPhoto.photoWithImage(mediaItem.image!)// add some UIImage
    images.append(photo)
    
    let browser = SKPhotoBrowser(photos: images)
    browser.initializePageIndex(0)
    present(browser, animated: true, completion: {})
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - InputBarAccessoryViewDelegate
//-------------------------------------------------------------------------------------------
extension ChatViewController: InputBarAccessoryViewDelegate {
  
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    
    // Here we can parse for which substrings were autocompleted
    let attributedText = messageInputBar.inputTextView.attributedText!
    let range = NSRange(location: 0, length: attributedText.length)
    attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
      
      let substring = attributedText.attributedSubstring(from: range)
      let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
      print("Autocompleted: `", substring, "` with context: ", context ?? [])
    }
    
    let components = inputBar.inputTextView.components
//    messageInputBar.inputTextView.text = String()
    messageInputBar.invalidatePlugins()
    
    // Send button activity animation
    messageInputBar.sendButton.startAnimating()
//    messageInputBar.inputTextView.placeholder = "Sending..."
    DispatchQueue.global(qos: .default).async {
      // fake send request task
      sleep(1)
      DispatchQueue.main.async { [weak self] in
        self?.messageInputBar.sendButton.stopAnimating()
        self?.messageInputBar.inputTextView.placeholder = ""
        self?.insertMessages(components)
        self?.messagesCollectionView.scrollToBottom(animated: true)
      }
    }
  }
  
  private func insertMessages(_ data: [Any]) {
    for component in data {
      let user = SampleData.shared.currentSender
      if let str = component as? String {
        let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
        insertMessage(message)
      } else if let img = component as? UIImage {
        let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
        insertMessage(message)
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - MessagesLayoutDelegate
//-------------------------------------------------------------------------------------------
extension ChatViewController: MessagesLayoutDelegate {
  
  func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return (!isTimeLabelVisible(at: indexPath)) ? 0 : 40
  }
  
  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return (isFromCurrentSender(message: message)) ? 0 : 20
  }
  
  func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 0
  }
  
  func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 0
  }
  
}
//-------------------------------------------------------------------------------------------
// MARK: - MessagesDisplayDelegate
//-------------------------------------------------------------------------------------------
extension ChatViewController: MessagesDisplayDelegate {
  
  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return isFromCurrentSender(message: message) ? UIColor(named: "00AA7D")! : UIColor(named: "F6F6F6")!
  }
  
  
  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
  
    let firstName = "김미나"
    let lastName = "비품담당"
    let initials = "\(firstName)\(lastName)"
    avatarView.addBorder(width: 1, color: .white)
    
    
    avatarView.set(avatar: Avatar(image: #imageLiteral(resourceName: "i_profile"), initials: initials))
  }
  
  func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    // Cells are reused, so only add a button here once. For real use you would need to
    // ensure any subviews are removed if not needed
    accessoryView.subviews.forEach { $0.removeFromSuperview() }
    let label = UILabel(x: 0, y: 0, w: 35, h: 12)
    label.font = UIFont.systemFont(ofSize: 11)
    label.text = "08:15"
    accessoryView.addSubview(label)
    
  }
  
  func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//-------------------------------------------------------------------------------------------
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
      cropController.modalPresentationStyle = .fullScreen
      self.present(cropController, animated: true, completion: nil)
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - CropViewControllerDelegate
//-------------------------------------------------------------------------------------------
extension ChatViewController: CropViewControllerDelegate {
  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    let data = image.jpegData(compressionQuality: 0.6)
    
    self.uploadImages(imageData: data ?? Data())
    cropViewController.dismiss(animated: true, completion: nil)
  }
  
}


