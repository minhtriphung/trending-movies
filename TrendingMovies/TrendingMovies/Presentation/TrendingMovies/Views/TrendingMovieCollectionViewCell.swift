//
//  TrendingMovieCollectionViewCell.swift
//  TrendingMovies
//
//  Created by Minh Tri on 14/09/2023.
//

import UIKit
import Kingfisher

class TrendingMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.moviePosterImageView.layer.cornerRadius = 10.0
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
    }

    func setupData(_ movie: TrendingMovie) {
        self.movieNameLabel.text = movie.title
        self.releaseDateLabel.text = movie.releaseDate
        //self.moviePosterImageView.kf.setImage(with: movie.imageUrl)
        self.moviePosterImageView.kf.setImage(with: movie.imageUrl) { result in
            self.activityIndicator.stopAnimating()
        }
    }
}
