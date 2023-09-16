//
//  TodayTrendingMoviesViewController.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit

class TodayTrendingMoviesViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = TrendingMovieViewModel()
    private var movieList: [TrendingMovie] = []
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 13 / 255.0, green: 36 / 255.0, blue: 63 / 255.0, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.title = "Trending Movies"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        self.bindViewModel()
        self.viewModel.getTrendingMovieBy(.day)
    }
    
    // MARK: Private
    private func setupUI() {
        self.collectionView.register(UINib(nibName: "TrendingMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    private func bindViewModel() {
        self.viewModel.errorBR.subscribe(onNext: { error in
            if let error = error {
                self.show(title: "Error", message: error.message)
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.movieListBR.subscribe(onNext: { list in
            self.movieList = list
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: Event
}

extension TodayTrendingMoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? TrendingMovieCollectionViewCell else {
            return TrendingMovieCollectionViewCell()
        }
        
        cell.setupData(movieList[indexPath.row])
        return cell
    }
}

extension TodayTrendingMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2 - 16
        let height = width * 327 / 170
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension TodayTrendingMoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        vc.currentMovie = movieList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


