//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 19/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import SVProgressHUD


final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var addEpisodeButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var showDetailsTableView: UITableView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var addEpisodeButton: UIButton!
    
    // MARK: - Properties
    
    var id: String! = nil
    private var items: [Episode]  = []
    private var showDetails: ShowDetails! = nil
    private let showService = ShowService()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchShowDetails()
    }
    
    // MARK: - Actions
    
    @IBAction private func touchBackButtonActionHandler() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func touchAddEpisodeButtonActionHandler() {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let addEpisodeViewController = storyboard.instantiateViewController(withIdentifier: "AddEpisodeViewController") as! AddEpisodeViewController
        addEpisodeViewController.delegate = self
        addEpisodeViewController.id = id
        let navigationController = UINavigationController(rootViewController: addEpisodeViewController)
        present(navigationController, animated: true)
    }
    
}

// MARK: - AddEpisodeDelegate

extension ShowDetailsViewController: AddEpisodeDelegate {
    func didCreateEpisode(episode: Episode) {
        items.append(episode)
        showDetailsTableView.reloadData()
    }
}

// MARK: - UITableView

extension ShowDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count != 0 ? items.count + 2 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = showDetailsTableView.dequeueReusableCell(withIdentifier: String(describing: ShowImageTableViewCell.self), for: indexPath) as! ShowImageTableViewCell
            return cell
        }
        else if indexPath.row == 1 {
            let cell = showDetailsTableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailsTableViewCell.self), for: indexPath) as! ShowDetailsTableViewCell
            let showDetailsTableViewCellItem = ShowDetailsTableViewCellItem(
                title: showDetails.title,
                description: showDetails.description,
                numberOfEpisodes: items.count
            )
            cell.configure(with: showDetailsTableViewCellItem)
            return cell
        } else {
            let cell = showDetailsTableView.dequeueReusableCell(withIdentifier: String(describing: EpisodeTableViewCell.self), for: indexPath) as! EpisodeTableViewCell
            cell.configure(with: items[indexPath.row - 2])
            return cell
        }
    }
}


extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 128
        }
        else if indexPath.row == 1 {
            return UITableView.automaticDimension
        } 
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animateButtonsOut()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateButtonsIn()
    }
}

// MARK: - Private table view setup

private extension ShowDetailsViewController {
    func setupTableView() {
        let showDetailsCellNib = UINib.init(nibName: String(describing: ShowDetailsTableViewCell.self), bundle: nil)
        showDetailsTableView.register(showDetailsCellNib, forCellReuseIdentifier:  String(describing: ShowDetailsTableViewCell.self))
        
        let episodeTableCellNib = UINib.init(nibName: String(describing: EpisodeTableViewCell.self), bundle: nil)
        showDetailsTableView.register(episodeTableCellNib, forCellReuseIdentifier: String(describing: EpisodeTableViewCell.self))
        
        let showImageTableCellNib = UINib.init(nibName: String(describing: ShowImageTableViewCell.self), bundle: nil)
        showDetailsTableView.register(showImageTableCellNib, forCellReuseIdentifier: String(describing: ShowImageTableViewCell.self))
        
        showDetailsTableView.estimatedRowHeight = 64
        showDetailsTableView.rowHeight = UITableView.automaticDimension
        showDetailsTableView.tableFooterView = UIView()
        
        showDetailsTableView.dataSource = self
        showDetailsTableView.delegate = self
    }
}

// MARK: - Private API requests

private extension ShowDetailsViewController {
    func fetchShowDetails() {
        SVProgressHUD.show()
        
        showService.fetchShowDetails(with: id) { [weak self] showDetailsResult in
            guard let self = self else {
                SVProgressHUD.dismiss()
                return
            }
            
            switch showDetailsResult {
            case .success(let showDetails):
                self.showDetails = showDetails
                
                self.showService.fetchEpisodesForShow(with: self.id) { [weak self]
                    episodesResult in
                    SVProgressHUD.dismiss()
                    guard let self = self else { return }
                    
                    switch episodesResult {
                    case .success(let episodes):
                        self.items = episodes
                        self.showDetailsTableView.reloadData()
                        
                    case .failure(let error):
                        print("Error fetching show episodes: \(error)")
                    }
                }
                
            case .failure(let error):
                print("Error fetching show details: \(error)")
            }
        }
    }
}

// MARK: - Private animations

private extension ShowDetailsViewController {
    
    func animateButtonsOut() {
        addEpisodeButtonTrailingConstraint.constant = -addEpisodeButton.frame.width
        backButtonLeadingConstraint.constant = -backButton.frame.width
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func animateButtonsIn() {
        addEpisodeButtonTrailingConstraint.constant = 48
        backButtonLeadingConstraint.constant = 16
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
