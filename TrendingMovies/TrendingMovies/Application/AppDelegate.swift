//
//  AppDelegate.swift
//  TrendingMovies
//
//  Created by Minh Tri on 13/09/2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // --------------------------------------
    // MARK: Lifecycle
    // --------------------------------------
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        let vc = TodayTrendingMoviesViewController(nibName: "TodayTrendingMoviesViewController", bundle: nil)
        let navi = NavigationController(rootViewController: vc)
        self.window?.rootViewController = navi
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    
    

}

