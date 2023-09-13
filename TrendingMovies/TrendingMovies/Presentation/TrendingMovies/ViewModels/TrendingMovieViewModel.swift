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
    
    
    // MARK: - Support Methods
    func getTrendingMovieBy(_ time: TrendingMovieTime, completion: ((APIError?) -> Void)?) {
        let request = TMDBAPIProvider.rx.request(.getTrendingMovies(time: time))
        
        request.asObservable().subscribe(onNext: { [weak self] (response) in
            guard let self = self else { return }
            
            let apiResponse = response.mapApi()
            if response.isSuccess {
                completion?(nil)
            } else {
                completion?(apiResponse.error)
            }
        }, onError: { (error) in
            completion?(APIError(code: "Timeout", message: "Request time out"))
        }).disposed(by: disposeBag)
    }
}
