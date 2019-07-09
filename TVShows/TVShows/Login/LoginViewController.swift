//
//  LoginViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 05/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    
    var tapCount = 0
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
