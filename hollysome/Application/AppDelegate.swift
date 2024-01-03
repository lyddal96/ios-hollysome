//
//  AppDelegate.swift
//
//

import UIKit
import Firebase
import UserNotifications
import SwiftyBeaver
import IQKeyboardManagerSwift
import SDWebImage
import SKPhotoBrowser
import UserNotifications
import AlamofireNetworkActivityLogger
import NaverThirdPartyLogin
import FirebaseAuth
import KakaoSDKCommon
import GoogleSignIn
import Hero
import Defaults
import GoogleMobileAds
import AppAuth

let log = SwiftyBeaver.self
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  override init() {
    super.init()
    UIFont.overrideInitialize()
  }
  
//  var window: UIWindow?
  var fcmKey: String?
  
  let gcmMessageIDKey = "gcm.message_id"
  var userInfo: [AnyHashable : Any]?
  
  var pushIndex = ""
  
  var currentAuthorizationFlow: OIDExternalUserAgentSession?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self
    
 

    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    if let notification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
      if let index = notification["index"] as? String {
        self.pushIndex = index
        
        log.debug(self.pushIndex)
      }
      
    }
    
    // 구글 지도
    //    GMSServices.provideAPIKey("AIzaSyCIzFyzChgf4syUcJspCKFGKANcc013sAU") // Google API Key(구글맵)
    
    
    // 네이버 로그인
    let naverThirdPartyLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    naverThirdPartyLoginInstance?.isNaverAppOauthEnable = true
    naverThirdPartyLoginInstance?.isInAppOauthEnable = true
    naverThirdPartyLoginInstance?.setOnlyPortraitSupportInIphone(true)
    naverThirdPartyLoginInstance?.appName = (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String) ?? ""
    naverThirdPartyLoginInstance?.serviceUrlScheme = "gocokr" //
    naverThirdPartyLoginInstance?.consumerKey = "H99UZ_ot69w1gIzMLe8Z" //
    naverThirdPartyLoginInstance?.consumerSecret = "MSNEbm9lZw" //
    
    // 카카오 로그인
    KakaoSDK.initSDK(appKey: "75c772ef169467f241b618c3885272d2")
    
    self.applicationSetting()
    GADMobileAds.sharedInstance().start(completionHandler: nil)

    return true
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)
    completionHandler(UIBackgroundFetchResult.newData)
  }
  
  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }
  
  
  public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
    if let authorizationFlow = self.currentAuthorizationFlow, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
      self.currentAuthorizationFlow = nil
      return true
    }
    
    // 구글
    return GIDSignIn.sharedInstance.handle(url)
    
    //    // 페이스북
    //    let appId = SDKSettings.appId
    //    if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" { // facebook
    //      return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    //    }
    //    return false
    //
//    return ApplicationDelegate.shared.application(app, open: url, options: options)
  }
}

extension AppDelegate {
  
  /// 어플리케이션 기본 세팅
  ///  - 로그
  ///  - IQKeyboard
  ///  - SD Web image 세팅
  ///  - SKPhotoBrowser
  func applicationSetting() {
    
    //SwiftyBeaver
    let console = ConsoleDestination()  // log to Xcode Console
    
    
    // add the destinations to SwiftyBeaver
    log.addDestination(console)
    log.verbose("not so important")  // prio 1, VERBOSE in silver
    log.debug("something to debug")  // prio 2, DEBUG in green
    log.info("a nice information")   // prio 3, INFO in blue
    log.warning("oh no, that won’t be good")  // prio 4, WARNING in yellow
    log.error("ouch, an error did occur!")  // prio 5, ERROR in red
    
    // Alamofire
    NetworkActivityLogger.shared.level = .debug
    NetworkActivityLogger.shared.startLogging()
    
    // IQKeyboardManager 세팅
    IQKeyboardManager.shared.enable = true
    //    IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
    IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    
    // SD WEB Image 세팅
    SDImageCache.shared.store(nil, forKey: nil, toDisk: false, completion: nil)
    
    NSSetUncaughtExceptionHandler { (exception) in
      log.error(exception.description)
    }
    
    // SKPhotoBrowser 세팅
    SKPhotoBrowserOptions.displayStatusbar = false
    SKPhotoBrowserOptions.displayCounterLabel = true
    SKPhotoBrowserOptions.displayBackAndForwardButton = true
    SKPhotoBrowserOptions.displayAction = false
    SKPhotoBrowserOptions.displayDeleteButton = false
    SKPhotoBrowserOptions.displayHorizontalScrollIndicator = false
    SKPhotoBrowserOptions.displayVerticalScrollIndicator = false
    SKPhotoBrowserOptions.bounceAnimation = true
    
    
    // UI 세팅
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = UIColor.white
    
    
    // 네비게이션 하단 라인 설정
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.shadowColor = UIColor(named: "FFFFFF")
    navigationBarAppearance.backgroundColor = UIColor(named: "FFFFFF")
    navigationBarAppearance.titleTextAttributes = [
      NSAttributedString.Key.font: UIFont(name: "SpoqaHanSansNeo-Regular", size: 16)!,
      NSAttributedString.Key.foregroundColor: UIColor(named: "text")!
    ]
    
    
    // 네비게이션 하단 라인 커스텀
    //    UINavigationBar.appearance().shadowImage = UIImage(named: "navigation_shadow")
    
    // 네비게이션 하단 라인 삭제
    //    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    //    UINavigationBar.appearance().shadowImage = UIImage()
    
    
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    if #available(iOS 15, *) {
      UINavigationBar.appearance().compactScrollEdgeAppearance = navigationBarAppearance
    }
    

    
    // 탭바 설정
    let tabBarAppearance = UITabBarAppearance()
    let tabBarItemAppearance = UITabBarItemAppearance()
    tabBarAppearance.backgroundColor = .white
    tabBarAppearance.shadowColor = UIColor.clear


    // 탭바 선택시 색깔.
    tabBarItemAppearance.normal.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor(named: "282828")!,
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9)
    ]
    tabBarItemAppearance.selected.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor(named: "accent")!,
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 9)
    ]

    tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
    UITabBar.appearance().standardAppearance = tabBarAppearance
    if #available(iOS 15.0, *) {
      UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    // 볼드체 설정
    UILabel.appearance(whenContainedInInstancesOf: [UIButton.self]).lineBreakMode = .byClipping
    UILabel.appearance(whenContainedInInstancesOf: [UIButton.self]).adjustsFontSizeToFitWidth = true
  
    
    // 테이블뷰 세팅
    if #available(iOS 15.0, *) {
      UITableView.appearance().sectionHeaderTopPadding = 0
    }
    
    Hero.shared.containerColor = .clear
    
  }
  
  /// 제일 상단 컨트롤러
  /// - Returns: controller
  func getTopViewController() -> UIViewController {
    if var topController = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      
      return topController
      // topController should now be your topmost view controller
    }
    return UIViewController()
  }
  
}



@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  
  // Foreground에 있을 경우
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    print("FOREGROUND = \(userInfo)")
    
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    completionHandler(UNNotificationPresentationOptions.alert)
  }
  
  // Foreground 로 돌아 올때
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    let responseUserInfo = response.notification.request.content.userInfo
    log.debug(responseUserInfo)
    
    if let index = responseUserInfo["index"] as? String {
      self.pushIndex = index
    }
    
    log.debug("BACKGROUND = \(userInfo)")
    
    let state = UIApplication.shared.applicationState
    
    if state == .active || state == .inactive {
      let notificationCenter = NotificationCenter.default
      notificationCenter.post(name: Notification.Name("PushNotification"), object: nil)
    }
    
    
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    self.userInfo = userInfo
    
    completionHandler()
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - MessagingDelegate
//-------------------------------------------------------------------------------------------
extension AppDelegate : MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(fcmToken ?? "")")
    //    LocalStore.gcm.value = fcmToken
    self.fcmKey = fcmToken
    Defaults[.fcm_key] = fcmToken
  }

}

