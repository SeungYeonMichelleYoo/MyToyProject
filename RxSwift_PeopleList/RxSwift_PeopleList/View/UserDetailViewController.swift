//
//  UserDetailViewController.swift
//  RxSwift_PeopleList
//
//  Created by SeungYeon Yoo on 2023/02/18.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailViewController: UIViewController {

    @IBOutlet weak var idNo: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    private let disposeBag = DisposeBag()
    var userDetail = BehaviorRelay<UserDetailModel>(value: UserDetailModel())
    var userDetailObserver: Observable<UserDetailModel> {
        return userDetail.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //즐겨찾기 버튼 - 바인딩(현재 상태를 가져오고, 반대 값으로 업데이트)
        favoriteBtn.rx.tap.bind {
            let favValue = self.userDetail.value.isFavorite
            favValue.accept(!favValue.value)
        }.disposed(by: disposeBag)

        
        userDetailObserver.subscribe(onNext: { (userValue) in
            self.title = "\(userValue.userData.first_name ?? "")'s Details"
            self.idNo.text = "\(userValue.userData.id ?? 0)"
            self.fullName.text = "\(userValue.userData.first_name ?? "") \(userValue.userData.last_name ?? "")"
            self.email.text = "\(userValue.userData.email ?? "")"
            self.setupFavoriteButtonImage(userValue: userValue)
            userValue.isFavObservable.subscribe(onNext: { (value) in
                self.setupFavoriteButtonImage(userValue: userValue)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    

    func setupFavoriteButtonImage(userValue: UserDetailModel) {
        if userValue.isFavorite.value {
            favoriteBtn.setImage(UIImage(systemName: "star.fill")?.withTintColor(UserCell.starTintColor), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(systemName: "star")?.withTintColor(UserCell.starTintColor), for: .normal)
        }
    }
}
