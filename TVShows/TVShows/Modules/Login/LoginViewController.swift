//
//  LoginViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 05/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    
    // MARK: - Private properties
    
    private var user: User? = nil
    private var userService = UserService()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextChangeHandlers()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
                SessionManager.attachAccessTokenAdapter(adapter: AccessTokenAdapter(accessToken: value.token))
                if self.rememberMeButton.isSelected {
                    KeychainManager.addUserInfo(username: username, password: password, token: value.token)
                }
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
                        SessionManager.attachAccessTokenAdapter(adapter: AccessTokenAdapter(accessToken: value.token))
                        if self.rememberMeButton.isSelected {
                            KeychainManager.addUserInfo(username: username, password: password, token: value.token)
                        }
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

// MARK: - RX setup
private extension LoginViewController {
    func setupTextChangeHandlers() {
        let validName =
            usernameTextField
            .rx
            .text
            .throttle(DispatchTimeInterval.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .map {
                self.validateTextField(string: $0)
            }
        let validPassword =
            passwordTextField
            .rx
            .text
            .throttle(DispatchTimeInterval.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .map {
                self.validateTextField(string: $0)
            }
        let loginButtonEnabled = Observable.combineLatest(validName, validPassword) {
            return $0 && $1
        }
        
        
        loginButtonEnabled.subscribe(onNext: { [unowned self] in
            self.loginButton.alpha = $0 ? 1.0 : 0.5
            self.loginButton.isEnabled = $0
        })
        .disposed(by: disposeBag)
    }
    
    func validateTextField(string: String?) -> Bool {
        return string?.count ?? 0 >= 5
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
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 16, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}


