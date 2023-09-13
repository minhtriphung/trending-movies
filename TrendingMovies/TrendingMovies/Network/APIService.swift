//
//  APIService.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit
import Moya

var TMDBAPIProvider = MoyaProvider<TMDBAPI>(endpointClosure: endPointClosure)

enum TMDBAPI {
    case getTrendingMovies
}

extension TMDBAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .getTrendingMovies:
            return "trending/movie/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTrendingMovies:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getTrendingMovies:
            return ["": ""]
        }
    }
    
    var task: Moya.Task {
        if self.parameters != nil {
            if self.method == .post || self.method == .put {
                return .requestParameters(parameters: self.parameters!, encoding: JSONEncoding.default)
            }
            
            return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
        }
        return .requestPlain
    }
    
    var headers: [String : String]? {
        let header = [
          "Accept" : "application/json",
          "Content-Type" : "application/json",
          "Authorization" : "Bearer 47aa75b56464da7a186b813a50035cd4"
        ]
        
        return header
    }
    
    var sampleData: Data {
        return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
    }
}

var endPointClosure = { (target: TMDBAPI) -> Endpoint in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let endpoint: Endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    return endpoint.adding(newHTTPHeaderFields: target.headers!)
}
