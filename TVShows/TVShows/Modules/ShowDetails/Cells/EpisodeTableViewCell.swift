//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Anteo Ivankov on 22/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var episodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        episodeLabel.text = nil
    }    
}

// MARK: - Configure

extension EpisodeTableViewCell {
    func configure(with item: Episode) {
        titleLabel.text = item.title
        episodeLabel.text = "S\(item.season) Ep\(item.episodeNumber)"
    }
}
