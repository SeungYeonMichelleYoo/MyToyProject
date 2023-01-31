//
//  ViewController.swift
//  SocialLoginPractice
//
//  Created by SeungYeon Yoo on 2023/01/31.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    var nickname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onKakaoLoginBtnTapped(_ sender: UIButton) {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    // 어세스토큰
                    let accessToken = oauthToken?.accessToken
                    
                    //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                    self.setUserInfo()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let homeVC = segue.destination as? HomeViewController else { return }
        DispatchQueue.main.async {
            homeVC.infoLabel.text = self.nickname
        }
    }
    
    func setUserInfo() {
            UserApi.shared.me() {(user, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("me() success.")
                    //do something
                    _ = user
                    
                    // 닉네임 다음 VC에 값 전달
                    self.nickname = (user?.kakaoAccount?.profile?.nickname)!
                    self.performSegue(withIdentifier: "presentToHomeVC", sender: nil)
                }
            }
        }
}

