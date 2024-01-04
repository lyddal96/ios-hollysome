//
//  SceneDelegate.swift
//  hollysome
//

import UIKit
import GoogleSignIn
import NaverThirdPartyLogin
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let _ = (scene as? UIWindowScene) else { return }
    
    self.window?.tintColor = UIColor.black
    self.window?.backgroundColor = UIColor.white
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    // Ensure we're trying to launch a link.
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let universalLink = userActivity.webpageURL else {
      return
    }

    if let urlComponents = URLComponents(url: universalLink, resolvingAgainstBaseURL: false) {
      log.debug("urlComponents : \(urlComponents)")


      if let host = urlComponents.host {

        let param = host.description.components(separatedBy: "=")
        if param.count > 0 {
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          if param[0] == "house_code" {
            appDelegate.house_code = param[1]
          }
          NotificationCenter.default.post(name: Notification.Name("DeeplinkUpdate"), object: nil)
        }
      }

    }
   
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else {
      return
    }
    
    // 카카오로그인
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      _ = AuthController.handleOpenUrl(url: url)
    }
    
    
    // 네이버 로그인
    NaverThirdPartyLoginConnection
      .getSharedInstance()?
      .receiveAccessToken(URLContexts.first?.url)
   
    guard let scheme = URLContexts.first?.url.scheme else { return }
    log.debug("scheme::::\(scheme)")
    
    if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
      log.debug("\(urlComponents.host)")
      if let host = urlComponents.host {
        
        let param = host.description.components(separatedBy: "=")
        if param.count > 1 {
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          if param[0] == "house_code" {
            appDelegate.house_code = param[1]
          }
          
          NotificationCenter.default.post(name: Notification.Name("DeeplinkUpdate"), object: nil)
          return
        }
      }
      
    }
  }
}

