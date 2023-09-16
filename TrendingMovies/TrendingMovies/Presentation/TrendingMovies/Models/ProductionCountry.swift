//
//  ProductionCountry.swift
//  TrendingMovies
//
//  Created by Minh Tri on 16/09/2023.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ProductionCountry: Object, JSONParsable {
    
    // MARK: Define Variables
    @objc dynamic var code: String = ""
    @objc dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        "code"
    }
    
    // MARK: Init
    override init() { }
    
    required init(json: JSON) {
        self.code = json["iso_3166_1"].stringValue
        self.name = json["name"].stringValue
    }
}
