//
//  JSONParsable.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit
import SwiftyJSON

protocol JSONParsable {
    
    init(json: JSON)
    func export() -> JSON
}

extension JSONParsable {
    
    func export() -> JSON {
        return .null
    }
}
