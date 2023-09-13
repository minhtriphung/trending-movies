//
//  TodayTrendingMoviesViewController.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit

class TodayTrendingMoviesViewController: BaseViewController {

    let viewModel = TrendingMovieViewModel()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel.getTrendingMovieBy(.day) { error in
            if let error = error {
                self.show(title: "Error", message: error.message)
            }
        }
    }

    // MARK: Event
    
    @IBAction func testAction(_ sender: UIButton) {
        self.viewModel.getTrendingMovieBy(.day) { error in
            if let error = error {
                self.show(title: "Error", message: error.message)
            }
        }
    }
    
}
