//
//  UserViewModel.swift
//  RxSwift_PeopleList
//
//  Created by SeungYeon Yoo on 2023/02/18.
//

import Foundation
import RxSwift
import RxCocoa

//즐겨찾기 여부 속성 추가, 즐겨찾기 상태 변경할 때마다 관찰 및 자동으로 업데이트 될 수 있도록 Observable 만듬
struct UserDetailModel {
    var userData = UserDetail(id: 1, email: "abc@gmail.com", first_name: "abc", last_name: "xyz", avatar: "avatar")
    var isFavorite: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isFavObservable: Observable<Bool> {
        return isFavorite.asObservable()
    }
}

//ViewModel: data에 대한 모든 작업을 화면에 표시할 수 있게. 표시할 준비된 데이터 -> View에 전달
class UserViewModel {
    let request = APIRequest()
    var users: Observable<[UserDetail]>?
    private let userViewModel = BehaviorRelay<[UserDetailModel]>(value: [])
    var userViewModelObserver: Observable<[UserDetailModel]> {
        return userViewModel.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    func fetchUserList() {
        users = request.callAPI()
        users?.subscribe(onNext: { (value) in
            var userViewModelArray = [UserDetailModel]()
            for index in 0..<value.count {
                var user = UserDetailModel()
                user.userData = value[index]
                userViewModelArray.append(user)
            }
            self.userViewModel.accept(userViewModelArray)
        }, onError: { (error) in
            _ = self.userViewModel.catch { (error) in
                Observable.empty()
            }
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
}
