//
//  ViewController.swift
//  NaverLogin
//
//  Created by SeungYeon Yoo on 2023/02/08.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire

class ViewController: UIViewController {
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    //네이버 로그인 성공시 처리
        var success: ((_ loginData: NaverLogin) -> Void)? = { loginData in
            //doSomething
        }
        //네이버 로그인 실패시 처리
        var failure: ((_ error: AFError) -> Void)? = { error in
            print(error.localizedDescription)
            //doSomething
        }
    
    //네이버 사용자 정보를 받아올 구조체
    struct NaverLogin: Decodable {
        var resultCode: String
        var response: Response
        var message: String
        
        struct Response: Decodable {
            var email: String
            var id: String
            var name: String
        }
        
        enum CodingKeys: String, CodingKey {
            case resultCode = "resultcode"
            case response
            case message
        }
    }
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        loginInstance?.requestDeleteToken()
    }
    
    private func getNaverInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseDecodable(of: NaverLogin.self) { [self] response in
            print(response)
            print(response.result)
            
            switch response.result {
            case .success(let loginData):
                print(loginData.resultCode)
                print(loginData.message)
                print(loginData.response)
                
                if let success = self.success {
                    success(loginData)
//                    self.nicknameLabel.text = "\(NaverLogin.Response.name)"
//                    self.emailLabel.text = "\(NaverLogin.Response.email)"
                }
                
                break
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                
                if let failure = self.failure {
                    failure(error)
                }
                
                break
            }
        }
    }
}


extension ViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        //     let naverSignInVC = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        //     naverSignInVC.parentOrientation = UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue)!
        //     present(naverSignInVC, animated: false, completion: nil)
    }
    
    // 로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        getNaverInfo()
    }
    
    // 접근 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
    }
    
    // 로그아웃 할 경우 호출(토큰 삭제)
    func oauth20ConnectionDidFinishDeleteToken() {
        loginInstance?.requestDeleteToken()
    }
    
    // 모든 Error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
}
