//
//  MainViewController.swift
//  AppleLoginPractice
//
//  Created by SeungYeon Yoo on 2023/02/12.
//
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pop 안되게
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
