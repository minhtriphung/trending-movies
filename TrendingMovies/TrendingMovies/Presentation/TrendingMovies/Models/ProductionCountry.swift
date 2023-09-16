//
//  ProductionCountry.swift
//  TrendingMovies
//
//  Created by Minh Tri on 16/09/2023.
//

import UIKit
import SwiftyJSON

class ProductionCountry: JSONParsable {
    
    // MARK: Define Variables
    let code: String
    let name: String
    
    
    // MARK: Init
    required init(json: JSON) {
        self.code = json["iso_3166_1"].stringValue
        self.name = json["name"].stringValue
    }
}
