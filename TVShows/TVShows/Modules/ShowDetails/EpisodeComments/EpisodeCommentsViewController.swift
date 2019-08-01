//
//  EpisodeCommentsViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 30/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import SVProgressHUD

final class EpisodeCommentsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var commentsTableView: UITableView!
    @IBOutlet private weak var postCommentButton: UIButton!
    @IBOutlet private weak var postCommentTextField: UITextField!
    @IBOutlet private weak var postCommentStackViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var episodeId: String! = nil
    private var items: [Comment] = []
    private let showService = ShowService()
    private let placeholderImages = [UIImage(named: "img-placeholder-user1"), UIImage(named: "img-placeholder-user2"), UIImage(named: "img-placeholder-user3")]
    
    private let noCommentsView = UINib(nibName: "NoComments", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    
    // MARK - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        setupTableView()
        setupNavigationBar()
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction private func touchPostCommentButtonActionHandler() {
        postComment()
    }
    
    @objc private func didSelectBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView setup

extension EpisodeCommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: String(describing: EpisodeCommentTableViewCell.self)) as! EpisodeCommentTableViewCell
        let imageIndex = indexPath.row % placeholderImages.count
        let image = placeholderImages[imageIndex]
        cell.configure(with: items[indexPath.row], userImage: image!)
        return cell
    }
}

extension EpisodeCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private table view setup

private extension EpisodeCommentsViewController {
    
    func setupTableView() {
        let episodeCommentCell = UINib(nibName: String(describing: EpisodeCommentTableViewCell.self), bundle: nil)
        commentsTableView.register(episodeCommentCell, forCellReuseIdentifier: String(describing: EpisodeCommentTableViewCell.self))
        
        commentsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: commentsTableView.frame.size.width, height: 1))
        
        commentsTableView.estimatedRowHeight = 64
        commentsTableView.rowHeight = UITableView.automaticDimension
        
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
    }
    
}

// MARK: - Private UI setup

private extension EpisodeCommentsViewController {
    
    func setupNavigationBar() {
        let navigationBar = navigationController!.navigationBar
        navigationBar.barTintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "ic-navigate-back"), for: .normal)
        backButton.addTarget(self, action: #selector(didSelectBack), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
        
        title = "Comments"
    }
}

// MARK: - Private API request

private extension EpisodeCommentsViewController {
    func fetchComments() {
        SVProgressHUD.show()
        
        showService.fetchCommentsForEpisode(with: episodeId) { [weak self] result in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                if value.isEmpty {
                    self.commentsTableView.backgroundView = self.noCommentsView
                } else {
                    self.items = value
                    self.commentsTableView.backgroundView = nil
                    self.commentsTableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching episode comments: \(error)")
            }
        }
    }
    
    func postComment() {
        guard let comment = postCommentTextField.text else { return }
        SVProgressHUD.show()
        
        showService.createCommentForEpisode(with: episodeId, text: comment) { [weak self] _ in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            self.postCommentTextField.text = ""
            self.fetchComments()
        }
    }
}

private extension EpisodeCommentsViewController {
    
    func subscribeToKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustScrollViewForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustScrollViewForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustScrollViewForKeyboard(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        let bottomSafe = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            animateKeyboard(constant: 8)
        } else {
            animateKeyboard(constant: keyboardHeight - bottomSafe + 8)
        }
    }
}

private extension EpisodeCommentsViewController {
    func animateKeyboard(constant: CGFloat) {
        postCommentStackViewBottomConstraint.constant = constant
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
