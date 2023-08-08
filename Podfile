# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RocateerKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RocateerKit
  pod 'ObjectMapper'
#  pod 'Alamofire'
  pod 'AlamofireNetworkActivityLogger'
  pod 'Result'
  
  pod 'Hero'
  pod 'SwiftyJSON'
  pod 'SwiftDate'
  pod 'SwiftyBeaver'
  pod 'SDWebImage'
  pod 'EZSwiftExtensions'
  pod 'IQKeyboardManagerSwift'
  pod 'SKPhotoBrowser'
  pod 'DZNEmptyDataSet'
  pod 'CropViewController'
  pod 'NotificationBannerSwift'
  pod 'NVActivityIndicatorView', "= 4.8.0"
  pod 'ExpyTableView'
  pod 'Defaults'
  pod 'StringStylizer', '= 5.0.0'
  pod 'RSKPlaceholderTextView' # TextView PlaceHolder
  
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  
#  pod 'KakaoSDK'
#  pod 'UPCarouselFlowLayout' # Collectionview 가운데 정렬
  
  pod 'MessageKit' # 채팅
  pod 'RSKGrowingTextView' # 늘어나는 TextView
  pod 'SideMenu' # 메뉴
  pod 'Parchment' # 슬라이드 탭
  pod 'DKImagePickerController', :subspecs => ['PhotoGallery', 'Camera', 'InlineCamera'] # 다중 이미지 선택
  pod 'SkeletonView' # 스켈레톤
  pod 'RKTagsView' # 태그
  pod "SearchTextField" # 자동완성
  pod 'Charts' # 차트
  pod 'DropDown' #드롭다운
  pod 'FSCalendar' # 달력
  
  pod 'Bolts' #Facebook
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'naveridlogin-sdk-ios' #네이버 로그인
  pod 'KakaoSDKAuth'
  pod 'KakaoSDKUser'
  pod 'GoogleSignIn'  #구글 로그인
  pod 'Firebase/Auth'

  pods_with_specific_swift_versions = {
    'EZSwiftExtensions' => '4.0',
    'RSKGrowingTextView' => '5.0',
    'RSKPlaceholderTextView' => '5.0',
    'ExpyTableView' => '5.0'
  }

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
      if pods_with_specific_swift_versions.key? target.name
        swift_version = pods_with_specific_swift_versions[target.name]
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = swift_version
        end
      end
    end
  end
  


end
