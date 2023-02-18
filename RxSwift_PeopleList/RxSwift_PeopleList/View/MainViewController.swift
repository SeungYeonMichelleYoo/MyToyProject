//
//  MainViewController.swift
//  RxSwift_PeopleList
//
//  Created by SeungYeon Yoo on 2023/02/18.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    fileprivate let bag = DisposeBag()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let userViewModelInstance = UserViewModel()
    let userList = BehaviorRelay<[UserDetailModel]>(value: [])
    let filteredList = BehaviorRelay<[UserDetailModel]>(value: [])
    var controller: UserDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userViewModelInstance.fetchUserList()
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController
        bindUI()
    }
    //받은 데이터를 테이블뷰 구성요소에 바인딩. (뷰와 데이터를 바인딩)
    func bindUI() {
        userViewModelInstance.userViewModelObserver.subscribe(onNext: { (value) in
            self.filteredList.accept(value)
            self.userList.accept(value)
        }, onError: { error in
            self.errorAlert()
        }).disposed(by: bag)
        
        tableView.tableFooterView = UIView()
        
        //table datasources를 table 및 cell 과 바인딩
        filteredList.bind(to: tableView.rx.items(cellIdentifier: "CellIdentifier", cellType: UserCell.self)) { row, model, cell in
            cell.configureCell(userDetail: model)
        }.disposed(by: bag)
        
        //didSelectRowAt() 대신 씀
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.controller?.userDetail.accept(self.filteredList.value[indexPath.row])
            self.controller?.userDetail.value.isFavObservable.subscribe(onNext: { _ in //즐겨찾기 상태 업데이트시 자동으로 새로 고쳐지도록 isFavObervable 구독
                self.tableView.reloadData()
            }).disposed(by: self.bag)
            self.navigationController?.pushViewController(self.controller ?? UserDetailViewController(), animated: true)
        }).disposed(by: bag)
        
        //검색 기능: 전체 데이터 모델을 search textfield에 결합. 그리고 검색결과를 테이블뷰에 바인딩된 데이터 모델에 바인딩.
        Observable.combineLatest(userList.asObservable(), searchTextField.rx.text, resultSelector: { users, search in //userList(사용자 전체 목록) observable로
            return users.filter { (user) -> Bool in //검색 문자열에 따라 필터링
                self.filterUserList(userModel: user, searchText: search)
            }
        }).bind(to: filteredList).disposed(by: bag) //필터링하고 얻은 결과를 FilterList에 바인딩
    }

    //검색 기능 (필터링 작업)
    func filterUserList(userModel: UserDetailModel, searchText: String?) -> Bool {
        if let search = searchText, !search.isEmpty, !(userModel.userData.first_name?.contains(search) ?? false) {
            return false
        }
        return true
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Check your Internet connection and Try Again!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
