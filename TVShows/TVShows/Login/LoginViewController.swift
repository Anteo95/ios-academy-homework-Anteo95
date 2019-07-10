//
//  LoginViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 05/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var counterButton: UIButton!
    
    // MARK: - Properties
    
    var tapCount = 0
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let indicator = self?.activityIndicator else { return }
            if indicator.isAnimating {
                indicator.stopAnimating()
                self?.counterButton.setTitle("Start!", for: .normal)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func touchCounterButtonActionHandler(_ sender: UIButton) {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            sender.setTitle("Start!", for: .normal)
        } else {
            activityIndicator.startAnimating()
            sender.setTitle("Stop!", for: .normal)
        }
        tapCount += 1
        counterLabel.text = "Tap count: \(tapCount)"
    }
}

// MARK: - Private UI setup

private extension LoginViewController {
    
    func setupUI() {
        counterButton.layer.cornerRadius = counterButton.frame.height / 2
        activityIndicator.startAnimating()

    }
}
