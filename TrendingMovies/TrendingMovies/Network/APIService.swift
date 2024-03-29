//
//  APIService.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit
import Moya

var TMDBAPIProvider = MoyaProvider<TMDBAPI>(endpointClosure: endPointClosure)

let APIAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxY2Y0MDJlNTg1M2VkOWM3ZWJmMDIyZjg2YWNkZTZjZSIsInN1YiI6IjY1MDFjZTg2ZTBjYTdmMDEyZWI5NGFkYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.mn-QAi2WlJdyoJfqYdj-WWcq9LU_dq1HVjM1ngvpawg"

let TMDBImageUrl = "https://image.tmdb.org/t/p/original"

enum TMDBAPI {
    case getTrendingMovies(time: TrendingMovieTime)
    case getDetailMovie(id: Int)
    case searchMovie(query: String)
}

extension TMDBAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }
    
    var path: String {
        switch self {
        case .getTrendingMovies(let time):
            return "/3/trending/movie/\(String(describing: time))?language=en-US"
        case .getDetailMovie(let id):
            return "/3/movie/\(id)"
        case .searchMovie(let query):
            return "/3/search/movie?query=\(query)&include_adult=false&language=en-US&page=1"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTrendingMovies:
            return .get
        case .getDetailMovie:
            return .get
        case .searchMovie:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getTrendingMovies:
            return nil
        case .getDetailMovie:
            return nil
        case .searchMovie:
            return nil
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
          "Authorization" : "Bearer \(APIAccessToken)"
        ]
        
        return header
    }
    
    var sampleData: Data {
        return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
    }
}

var endPointClosure = { (target: TMDBAPI) -> Endpoint in
    let url = String(format: "%@%@", target.baseURL.absoluteString, target.path)
    let endpoint: Endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    return endpoint.adding(newHTTPHeaderFields: target.headers!)
}
