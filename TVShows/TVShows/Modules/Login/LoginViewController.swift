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
    private var userService = UserService()
    
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
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty
        else {
            showAlert(title: "Login error", message: "Enter username and password")
            return
        }
        
        SVProgressHUD.show()
        userService.login(with: username, password: password) { [weak self] loginResult in
            guard let self = self else { return }
            
            SVProgressHUD.dismiss()
            switch loginResult {
            case .success(let value):
                self.loginData = value
                self.navigateToHomeScreen()
                
            case .failure(let error):
                self.showAlert(title: "Login error", message: "Wrong username or password")
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
        
        SVProgressHUD.show()
        userService.register(with: username, password: password) { [weak self] registerResult in
            guard let self = self else { return }
            
            SVProgressHUD.dismiss()
            switch registerResult {
            case .success(let value):
                self.user = value
                
                SVProgressHUD.show()
                self.userService.login(with: username, password: password) { [weak self] loginResult in
                    guard let self = self else { return }
                    
                    SVProgressHUD.dismiss()
                    switch loginResult {
                    case .success(let value):
                        self.loginData = value
                        self.navigateToHomeScreen()
                        
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
}


