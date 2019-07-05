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
    
    var tapCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBtnTap(_ sender: Any) {
        tapCount += 1
        label.text = String(tapCount)
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
