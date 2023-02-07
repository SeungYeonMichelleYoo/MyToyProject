//
//  ViewController.swift
//  MovieRanking
//
//  Created by SeungYeon Yoo on 2023/02/06.
//

import UIKit

class HomeViewController: UIViewController {
    var movieData: MovieData?
    
    @IBOutlet weak var tableView: UITableView!
    var movieURL = "\(EndPoint.baseUrl)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        movieURL += makeYesterdayString()
        getData()
    }
    
    func makeYesterdayString() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: yesterday)
    }
    
    func getData() {
        if let url = URL(string: movieURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [self] data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let JSONdata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(MovieData.self, from: JSONdata)
                        self.movieData = decodedData
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                      for: indexPath) as! MovieTableViewCell
        
        cell.movieTitle.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        if let audiences = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiCnt {
            cell.audienceCount.text = "관객수: \(audiences) 명"
        }
        return cell
    }
}

