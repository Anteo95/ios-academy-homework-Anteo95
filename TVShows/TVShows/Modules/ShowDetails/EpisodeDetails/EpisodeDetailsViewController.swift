//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 30/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import SVProgressHUD

final class EpisodeDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var episodeImage: UIImageView!
    @IBOutlet private weak var episodeTitleLabel: UILabel!
    @IBOutlet private weak var episodeSeasonAndNumberLabel: UILabel!
    @IBOutlet private weak var episodeDescriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var episodeId: String! = nil
    private let showService = ShowService()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEpisodeDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: Actions
    
    @IBAction private func touchBackButtonActionHandler() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction private func touchViewCommentsButtonActionHandler() {
        navigateToEpisodeCommentsScreen(episodeId: episodeId)
    }
}


// MARK: Private API requests

private extension EpisodeDetailsViewController {
    
    func fetchEpisodeDetails() {
        SVProgressHUD.show()
        
        showService.fetchDetailsForEpisode(with: episodeId) { [weak self] result in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                if let imageUrl = value.imageUrl {
                    self.episodeImage.kf.setImage(with: URL(string: Constants.API.baseURL + imageUrl))
                }
                self.episodeTitleLabel.text = value.title
                self.episodeSeasonAndNumberLabel.text = "S\(value.season) Ep\(value.episodeNumber)"
                self.episodeDescriptionLabel.text = value.description
                
            case .failure(let error):
                print("Error fetching episode details: \(error)")
            }
        }
    }
}
