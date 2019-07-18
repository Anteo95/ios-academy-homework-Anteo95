//
//  UIViewControllerExtension.swift
//  TVShows
//
//  Created by Anteo Ivankov on 16/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func navigateToHomeScreen(loginData: LoginData) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.loginData = loginData
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(alertController, animated:  true, completion: nil)
    }
}
