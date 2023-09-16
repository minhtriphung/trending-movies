//
//  TrendingMovieViewModel.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

class TrendingMovieViewModel {
    
    // MARK: - Define Variables
    private let disposeBag = DisposeBag()
    
    let realm = try! Realm()
    
    var errorBR = BehaviorRelay<APIError?>(value: nil)
    var movieListBR = BehaviorRelay<[TrendingMovie]>(value: [])
    var movieSelected = BehaviorRelay<TrendingMovie?>(value: nil)
    
    // MARK: - Support Methods
    func getTrendingMovieBy(time: TrendingMovieTime, isLocal: Bool = false) {
        if isLocal {
            let objects = realm.objects(TrendingMovie.self)
            if objects.count > 0 {
                self.movieListBR.accept(objects.toArray(type: TrendingMovie.self))
            }
            return
        }
        
        let request = TMDBAPIProvider.rx.request(.getTrendingMovies(time: time))
        request.asObservable().subscribe(onNext: { [weak self] (response) in
            guard let self = self else { return }
            let apiResponse = response.mapApi()
            if response.isSuccess {
                if let data = apiResponse.data {
                    let movieList = data["results"].arrayValue.compactMap { TrendingMovie(json: $0) }
                    self.movieListBR.accept(movieList)
                    try! self.realm.write {
                        self.realm.add(movieList, update: .modified)
                    }
                }
                self.errorBR.accept(nil)
            } else {
                self.errorBR.accept(apiResponse.error)
            }
        }, onError: { (error) in
            self.errorBR.accept(APIError(code: "Error", message: error.localizedDescription))
        }).disposed(by: disposeBag)
    }
    
    func getDetailMovie(id: Int, isLocal: Bool = false) {
        if isLocal {
            let predicate = NSPredicate(format: "id == %ld", id)
            let objects = realm.objects(TrendingMovie.self).filter(predicate)
            if objects.count > 0 {
                let list = objects.toArray(type: TrendingMovie.self)
                self.movieSelected.accept(list.first)
            }
            return
        }
        
        let request = TMDBAPIProvider.rx.request(.getDetailMovie(id: id))
        request.asObservable().subscribe(onNext: { [weak self] (response) in
            guard let self = self else { return }
            let apiResponse = response.mapApi()
            if response.isSuccess {
                if let data = apiResponse.data {
                    let movie = TrendingMovie(json: data)
                    self.movieSelected.accept(movie)
                    try! self.realm.write {
                        movie.genres.forEach { genre in
                            self.realm.add(genre, update: .all)
                        }

                        movie.productionCountries.forEach { country in
                            self.realm.add(country, update: .all)
                        }
                        self.realm.add(movie, update: .modified)
                    }
                }
                self.errorBR.accept(nil)
            } else {
                self.errorBR.accept(apiResponse.error)
            }
        }, onError: { (error) in
            self.errorBR.accept(APIError(code: "Error", message: error.localizedDescription))
        }).disposed(by: disposeBag)
    }
    
    func searchMovie(query: String) {
        let request = TMDBAPIProvider.rx.request(.searchMovie(query: query))
        
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
            self.errorBR.accept(APIError(code: "Error", message: error.localizedDescription))
        }).disposed(by: disposeBag)
    }
}
