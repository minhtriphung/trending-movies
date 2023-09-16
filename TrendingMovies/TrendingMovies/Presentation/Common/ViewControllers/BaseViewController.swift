//
//  BaseViewController.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit
import RxSwift

class NavigationController: UINavigationController {

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}


class BaseViewController: UIViewController {

    public let disposeBag = DisposeBag()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupBackNavigationBarItem() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "icon_back"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleBackBarButtonItemEvent(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    // MARK: Event
    @objc private func handleBackBarButtonItemEvent(_ button: UIButton) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
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
