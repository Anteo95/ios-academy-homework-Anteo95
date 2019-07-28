//
//  EpisodesTableViewCell.swift
//  TVShows
//
//  Created by Anteo Ivankov on 22/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

struct ShowDetailsTableViewCellItem {
    let title: String
    let description: String
    let numberOfEpisodes: Int
}

class ShowDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberOfEpisodesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        numberOfEpisodesLabel.text = nil
    }
}

// MARK: - Configure

extension ShowDetailsTableViewCell {
    func configure(with item: ShowDetailsTableViewCellItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        numberOfEpisodesLabel.text = String(item.numberOfEpisodes)
    }
}
