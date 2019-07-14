//
//  LoginViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 05/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import SVProgressHUD

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: - Private properties
    
    private var loginData: LoginData? = nil
    private var user: User? = nil
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribeToKeyboardNotifications()
    }
    
    // MARK: - Actions
    
    @IBAction private func touchRememberMeButtonActionHandler(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction private func touchLoginButtonActionHandler() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        let userService = UserService()
        
        SVProgressHUD.show()
        userService.login(with: username, password: password) { [weak self] dataResponse in
            SVProgressHUD.dismiss()
            
            switch dataResponse.result {
            case .success(let response):
                self?.loginData = response
                self?.navigateToHomeScreen()
                
            case .failure(let error):
                self?.showAlert(title: "Login error", message: "Wrong username or password")
                print("Login error: \(error)")
            }
        }
    }
    
    @IBAction private func touchCreateAccountButtonActionHandler() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        if username.isEmpty || password.isEmpty {
            showAlert(title: "Registration error",  message: "Please enter username and password")
            return
        }
        let userService = UserService()
        
        SVProgressHUD.show()
        userService.register(with: username, password: password) { [weak self] registerResponse in
            SVProgressHUD.dismiss()
            
            switch registerResponse.result {
            case .success(let response):
                self?.user = response
                
                SVProgressHUD.show()
                userService.login(with: username, password: password) { [weak self] loginResponse in
                    SVProgressHUD.dismiss()
                    
                    switch loginResponse.result {
                    case .success(let response):
                        self?.loginData = response
                        self?.navigateToHomeScreen()
                        
                    case .failure(let error):
                        print("Login error: \(error)")
                    }
                }
                
            case .failure(let error):
                print("Registration error: \(error)")
            }
        }
    }
    
}

// MARK: - Private UI setup

private extension LoginViewController {
    
    func setupUI() {
        loginButton.layer.cornerRadius = 5
    }
}

// MARK: - Private Functions

private extension LoginViewController {
    
    func subscribeToKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustScrollViewForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustScrollViewForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustScrollViewForKeyboard(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    
    func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(alertController, animated:  true, completion: nil)
    }
}


