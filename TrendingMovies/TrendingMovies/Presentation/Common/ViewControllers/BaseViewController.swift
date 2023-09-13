//
//  BaseViewController.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}

// MARK: - Show Alert
extension BaseViewController {
    
    func show(title: String, message: String, okHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            okHandler?(action)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
