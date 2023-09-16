//
//  MovieDetailViewController.swift
//  TrendingMovies
//
//  Created by Minh Tri on 15/09/2023.
//

import UIKit
import Kingfisher

class MovieDetailViewController: BaseViewController {

    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainIndicator: UIActivityIndicatorView!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var voteaverageLabel: UILabel!
    @IBOutlet weak var voteaverageView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    let viewModel = TrendingMovieViewModel()
    var currentMovie: TrendingMovie?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        self.bindViewModel()
    }
    
    // MARK: Private
    private func setupUI() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.mainIndicator.startAnimating()
        self.mainIndicator.hidesWhenStopped = true
        self.setupBackNavigationBarItem()
        
        self.voteaverageView.layer.cornerRadius = self.voteaverageView.frame.width / 2
        self.voteaverageLabel.layer.cornerRadius = self.voteaverageLabel.frame.width / 2
        self.voteaverageLabel.layer.masksToBounds = true
        self.nameLabel.text = ""
        self.taglineLabel.text = ""
        self.overviewLabel.text = ""
        self.voteaverageLabel.text = ""
        self.releaseDateLabel.text = ""
        self.genresLabel.text = ""
        guard let movie = currentMovie else { return }
        self.navigationItem.title = "Movie Detail"
        self.backdropImageView.kf.setImage(with: movie.backdropUrl) { result in
            self.activityIndicator.stopAnimating()
        }
        
        self.viewModel.getDetailMovie(movie.id)
    }
    
    private func bindViewModel() {
        self.viewModel.errorBR.subscribe(onNext: { error in
            self.mainIndicator.stopAnimating()
            if let error = error {
                self.show(title: "Error", message: error.message)
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.movieSelected.subscribe(onNext: { movie in
            guard let movie = movie else { return }
            self.mainIndicator.stopAnimating()
            self.setupMovieData(movie)
        }).disposed(by: self.disposeBag)
    }

    // MARK: Utilities
    private func setupMovieData(_ movie: TrendingMovie) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:movie.releaseDate) ?? Date()
        
        dateFormatter.dateFormat = "yyyy"
        self.nameLabel.text = movie.title + " (\(dateFormatter.string(from: date)))"
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let countryCode = movie.productionCountries.map({$0.code}).joined(separator: ",")
        self.releaseDateLabel.text = dateFormatter.string(from: date) + " (\(countryCode.uppercased()))"
        
        self.genresLabel.text = movie.genres.map({$0.name}).joined(separator: ", ")
        
        self.taglineLabel.text = movie.tagline
        self.overviewLabel.text = movie.overview
        self.voteaverageLabel.text = String(format: "%.1f", movie.voteAverage)
    }
}
