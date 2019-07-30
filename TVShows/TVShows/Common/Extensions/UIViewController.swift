//
//  UIViewControllerExtension.swift
//  TVShows
//
//  Created by Anteo Ivankov on 16/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
    
    func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
    func navigateToShowDetailsScreen(showId: String) {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let showDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        showDetailsViewController.id = showId
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
    
    func presentAddEpisodeScreen(showId: String, delegate: AddEpisodeDelegate?) {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let addEpisodeViewController = storyboard.instantiateViewController(withIdentifier: "AddEpisodeViewController") as! AddEpisodeViewController
        addEpisodeViewController.delegate = delegate
        addEpisodeViewController.id = showId
        let navigationController = UINavigationController(rootViewController: addEpisodeViewController)
        present(navigationController, animated: true)
    }
    
    func navigateToEpisodeDetailsScreen(episodeId: String) {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let episodeDetailsViewController = storyboard.instantiateViewController(withIdentifier: "EpisodeDetailsViewController") as! EpisodeDetailsViewController
        episodeDetailsViewController.episodeId = episodeId
        navigationController?.pushViewController(episodeDetailsViewController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated:  true, completion: nil)
    }
}
