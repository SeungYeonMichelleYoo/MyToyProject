//
//  MovieModel.swift
//  MovieRanking
//
//  Created by SeungYeon Yoo on 2023/02/07.
//

import Foundation

struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Codable {
    let movieNm: String
    let audiCnt: String
}
