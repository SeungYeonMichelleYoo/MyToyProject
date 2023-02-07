//
//  MovieTableViewCell.swift
//  MovieRanking
//
//  Created by SeungYeon Yoo on 2023/02/06.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var audienceCount: UILabel!
}
