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
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteAverageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.moviePosterImageView.layer.cornerRadius = 10.0
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.voteAverageView.layer.cornerRadius = self.voteAverageView.frame.width / 2
    }

    func setupData(_ movie: TrendingMovie, isLocal: Bool = false) {
        self.movieNameLabel.text = movie.title
        self.voteAverageLabel.text = String(format: "%.1f", movie.voteAverage)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:movie.releaseDate) ?? Date()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        self.releaseDateLabel.text = dateFormatter.string(from: date)
        
        if let fileURL = URL(string: movie.imageUrl) {
            if isLocal {
                self.activityIndicator.stopAnimating()
                self.moviePosterImageView.image = movie.loadImageWith(fileName: fileURL.lastPathComponent)
            } else {
                self.moviePosterImageView.kf.setImage(with: fileURL) { result in
                    switch result {
                    case .success(let value):
                        movie.saveImage(imageName: fileURL.lastPathComponent, image: value.image)
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
