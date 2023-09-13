//
//  TrendingMovie.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit
import SwiftyJSON

enum TrendingMovieTime {
    case day
    case week
}

class TrendingMovie: JSONParsable {
    
    // MARK: Define Variables
    let title: String
    let releaseDate: String
    let image: String
    let voteAverage: Float
    
    // MARK: Init
    required init(json: JSON) {
        self.title = json["title"].stringValue
        self.image = json["backdrop_path"].stringValue
        self.releaseDate = json["release_date"].stringValue
        self.voteAverage = json["vote_average"].floatValue
    }
}
