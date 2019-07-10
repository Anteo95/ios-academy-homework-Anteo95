//
//  LoginViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 05/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - Properties
    
    var tapCount = 0
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = button.frame.height / 2
        
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let indicator = self?.activityIndicator else { return }
            if indicator.isAnimating {
                indicator.stopAnimating()
                self?.button.setTitle("Start!", for: UIControl.State.normal)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onBtnTap(_ sender: Any) {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            button.setTitle("Start!", for:UIControl.State.normal)
        } else {
            activityIndicator.startAnimating()
            button.setTitle("Stop!", for: UIControl.State.normal)
        }
        tapCount += 1
        label.text = "Tap count: \(tapCount)"
    }
}
