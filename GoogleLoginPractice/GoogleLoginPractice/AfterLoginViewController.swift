//
//  AfterLoginViewController.swift
//  GoogleLoginPractice
//
//  Created by SeungYeon Yoo on 2023/02/04.
//
import UIKit

class AfterLoginViewController: UIViewController {

    var username = ""
    var emailAddress = ""
    var imageUrl: URL?
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var emaiilAddressLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idLabel.text = username
        emaiilAddressLabel.text = emailAddress
        profileImg.load(url: imageUrl!)
    }


}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
