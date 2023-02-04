//
//  ViewController.swift
//  GoogleLoginPractice
//
//  Created by SeungYeon Yoo on 2023/02/04.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func googleLoginBtnClicked(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
//            signInResult.user.refreshTokensIfNeeded { user, error in
//                guard error == nil else { return }
//                guard let user = user else { return }
//
//                let userIdToken = user.idToken
//                tokenSignInExample(idToken: userIdToken!) //서버로 id토큰 보내기 (HTTPS POST 사용)
//            }
            
            let userInfo = signInResult.user
            
//            let emailAddress = user.profile?.email
//            let fullName = user.profile?.name
//            let givenName = user.profile?.givenName
//            let familyName = user.profile?.familyName
//            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            print("로그인 성공")
            
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AfterLoginViewController") as? AfterLoginViewController else { return }
            nextVC.username = (userInfo.profile?.name)!
            nextVC.emailAddress = (userInfo.profile?.email)!
            nextVC.imageUrl = userInfo.profile?.imageURL(withDimension: 320)
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
            
        }
    }
    
//    func tokenSignInExample(idToken: String) {
//        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
//            return
//        }
//        let url = URL(string: "https://yourbackend.example.com/tokensignin")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
//            // Handle response from your backend.
//        }
//        task.resume()
//    }

}

