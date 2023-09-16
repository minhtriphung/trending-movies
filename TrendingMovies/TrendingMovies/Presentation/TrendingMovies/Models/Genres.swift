//
//  Genres.swift
//  TrendingMovies
//
//  Created by Minh Tri on 16/09/2023.
//

import UIKit
import SwiftyJSON

class Genres: JSONParsable {
    
    // MARK: Define Variables
    let id: Int
    let name: String
    
    
    // MARK: Init
    required init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
}
