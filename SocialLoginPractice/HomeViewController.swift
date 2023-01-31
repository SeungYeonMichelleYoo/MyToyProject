//
//  HomeViewController.swift
//  SocialLoginPractice
//
//  Created by SeungYeon Yoo on 2023/01/31.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class HomeViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logoutBtnClicked(_ sender: UIButton) {
        UserApi.shared.logout{(error) in
            if let error = error {
                print(error)
            } else {
                print("kakao logout success")
                self.dismiss(animated: true)
            }
        }
    }
    
}

