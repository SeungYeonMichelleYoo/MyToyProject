//
//  APIRequest.swift
//  RxSwift_PeopleList
//
//  Created by SeungYeon Yoo on 2023/02/18.
//

import Foundation
import RxSwift

class APIRequest {
    let baseURL = URL(string: "https://reqres.in/api/users")!
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    
    func callAPI<T: Codable>() -> Observable<T> {
        return Observable<T>.create { observer in //disposable을 반환하는 Observable<T> 생성
            self.dataTask = self.session.dataTask(with: self.baseURL, completionHandler: { data, response, error in //URL session 활용, API호출
                do {
                    let model: DataModel = try JSONDecoder().decode(DataModel.self, from: data ?? Data()) //응답 받으면 디코딩 시도
                    observer.onNext(model.data as! T) //디코딩 성공 시 onNext 이벤트 내보낸다
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            self.dataTask?.resume()
            return Disposables.create { //observable.create함수는 disposable 객체를 반환해야 함
                self.dataTask?.cancel()
            }
        }
    }
}
