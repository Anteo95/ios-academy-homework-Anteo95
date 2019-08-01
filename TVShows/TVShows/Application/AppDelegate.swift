//
//  AppDelegate.swift
//  TVShows
//
//  Created by Anteo Ivankov on 04/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setDefaultMaskType(.black)

        let navigationController = window?.rootViewController as! UINavigationController
        
        if let userInfo = KeychainManager.getUserInfo() {
            SessionManager.attachAccessTokenAdapter(adapter: AccessTokenAdapter(accessToken: userInfo.token))
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            navigationController.pushViewController(homeViewController, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            navigationController.pushViewController(loginViewController, animated: true)
        }
        return true
    }
}

