//
//  GCPAuthManager.swift
//  hollysome
//
//  Created by 이승아 on 12/28/23.
//

import Foundation
import OAuthSwift

class GCPAuthManager {
  let oauthswift = OAuth2Swift(
    consumerKey: "201665160506-vu3pbfd4cqf4cm689crvore0h7doggkn.apps.googleusercontent.com",
    consumerSecret: "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",
    authorizeUrl:   "https://accounts.google.com/o/oauth2/auth",  // 인증 URL
    accessTokenUrl: "https://accounts.google.com/o/oauth2/token", // 토큰 URL
    responseType:   "code"
  )
  func getAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
    // OAuthSwift 인증 플로우 시작
    
    oauthswift.authorize(
        withCallbackURL: URL(string: "http://noom.api.hollysome.com/")!,
        scope: "https://www.googleapis.com/auth/cloud-platform",
        state: "state"
    ) { result in
        switch result {
        case .success(let (credential, _, _)):
            // 인증이 성공하면 액세스 토큰을 얻을 수 있습니다.
            let accessToken = credential.oauthToken
            // 여기에서 액세스 토큰을 사용하여 GCP 리소스에 액세스할 수 있습니다.
        case .failure(let error):
            // 인증 실패 시 오류 처리
            print("OAuth Error: \(error.localizedDescription)")
        }
    }
  }
}
