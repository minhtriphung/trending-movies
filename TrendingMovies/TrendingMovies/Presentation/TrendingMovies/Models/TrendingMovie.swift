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
    let id: Int
    let adult: Bool
    let title: String
    let releaseDate: String
    let imageUrl: URL?
    let backdropUrl: URL?
    let voteAverage: Float
    let overview: String
    let tagline: String
    let originalLanguage: String
    let genres: [Genres]
    let productionCountries: [ProductionCountry]
    
    // MARK: Init
    required init(json: JSON) {
        self.id = json["id"].intValue
        self.adult = json["adult"].boolValue
        self.title = json["title"].stringValue
        self.imageUrl = URL(string: String(format: "%@%@", TMDBImageUrl, json["poster_path"].stringValue))
        self.backdropUrl = URL(string: String(format: "%@%@", TMDBImageUrl, json["backdrop_path"].stringValue))
        self.releaseDate = json["release_date"].stringValue
        self.voteAverage = json["vote_average"].floatValue
        self.overview = json["overview"].stringValue
        self.tagline = json["tagline"].stringValue
        self.originalLanguage = json["original_language"].stringValue
        self.genres = json["genres"].arrayValue.compactMap { Genres(json: $0) }
        self.productionCountries = json["production_countries"].arrayValue.compactMap { ProductionCountry(json: $0) }
    }
}
