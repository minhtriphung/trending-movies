//
//  APIResponse.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit
import Alamofire
import Moya
import SwiftyJSON

struct APIError: LocalizedError {
    
    var code: String
    var message: String
    
    init (code: Int, message: String) {
        self.code = "\(code)"
        self.message = message
    }
    
    init (code: String, message: String) {
        self.code = code
        self.message = message
    }
}

class APIResponse {
    
    var error: APIError?
    let data: JSON?
    
    init(response: Response) {
        let json = JSON(response.data)
        if response.isSuccess {
            self.data = json
        } else {
            if let errorCode = json["status_code"].int {
                self.error = APIError(code: errorCode, message: json["status_message"].stringValue)
            } else {
                self.error = APIError(code: response.statusCode, message: json["status_message"].stringValue)
            }
            self.data = nil
        }
    }
    
    public func toObject<T: JSONParsable>(_ as: T.Type) -> T? {
        guard let data = self.data else {
            return nil
        }
        
        return T(json: data)
    }
    
    public func toArray<T: JSONParsable>(_ as: [T.Type]) -> [T] {
        guard let arrayData = self.data else {
            return []
        }
        
        return (arrayData.arrayValue.compactMap { T(json: $0) })
    }
}

// MARK: - Moya Extension
extension Response {
    
    func mapApi() -> APIResponse {
        return APIResponse(response: self)
    }
}

extension Moya.Response {
    
    var isSuccess: Bool {
        return statusCode == 200
    }
    
    var isUnauthenticated: Bool {
        return statusCode == 401
    }
    
    var isUnauthorized: Bool {
        return statusCode == 403
    }
}
