//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 23/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol AddEpisodeDelegate: class {
    func didCreateEpisode(episode: Episode)
}

final class AddEpisodeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var seasonNumberTextField: UITextField!
    @IBOutlet private weak var episodeNumberTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    
    // MARK: - Properties
    
    var id: String! = nil
    private let showService = ShowService()
    
    weak var delegate: AddEpisodeDelegate? = nil
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        setupNavigationBar()
    }
    
    // MARK: - Actions
    
    @objc func didSelectCancel() {
        dismiss(animated: true)
    }
    
    @objc func didSelectAddShow() {
        guard
            let title = titleTextField.text,
            let description = descriptionTextField.text,
            !title.isEmpty,
            !description.isEmpty
        else {
            showAlert(title: "Error Adding episode", message: "Title and description must not be empty.")
            return
        }
    
        SVProgressHUD.show()
        showService.createEpisodeForShow(with: id, title: title, description: description, episodeNumber: episodeNumberTextField.text, season: seasonNumberTextField.text) { [weak self] result in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.dismiss(animated: true) {
                    self.delegate?.didCreateEpisode(episode: value)
                }
                
            case .failure(let error):
                self.showAlert(title: "Error Adding episode", message: error.localizedDescription)
            }
        }
        
    }
}

// MARK: - Private navigation bar setup

private extension AddEpisodeViewController {
    func setupNavigationBar() {
        let navigationBar = navigationController!.navigationBar
        navigationBar.barTintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = Constants.Colors.pink
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow)
        )
        title = "Add episode"
    }
}

// MARK: - Keyboard

private extension AddEpisodeViewController {
    
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
