//
//  Genres.swift
//  TrendingMovies
//
//  Created by Minh Tri on 16/09/2023.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Genres: Object, JSONParsable {
    
    // MARK: Define Variables
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    // MARK: Init
    override init() { }
    
    required init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
}
