//
//  TrendingMovieViewModel.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class TrendingMovieViewModel {
    
    // MARK: - Define Variables
    private let disposeBag = DisposeBag()
    
    var errorBR = BehaviorRelay<APIError?>(value: nil)
    var movieListBR = BehaviorRelay<[TrendingMovie]>(value: [])
    
    // MARK: - Support Methods
    func getTrendingMovieBy(_ time: TrendingMovieTime) {
        let request = TMDBAPIProvider.rx.request(.getTrendingMovies(time: time))
        
        request.asObservable().subscribe(onNext: { [weak self] (response) in
            guard let self = self else { return }
            let apiResponse = response.mapApi()
            if response.isSuccess {
                if let data = apiResponse.data {
                    let movieList = data["results"].arrayValue.compactMap { TrendingMovie(json: $0) }
                    self.movieListBR.accept(movieList)
                }
                self.errorBR.accept(nil)
            } else {
                self.errorBR.accept(apiResponse.error)
            }
        }, onError: { (error) in
            self.errorBR.accept(APIError(code: "Timeout", message: "Request time out"))
        }).disposed(by: disposeBag)
    }
}
