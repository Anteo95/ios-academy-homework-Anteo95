//
//  EpisodeCommentTableViewCell.swift
//  TVShows
//
//  Created by Anteo Ivankov on 30/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

final class EpisodeCommentTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var placeholderImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        usernameLabel.text = nil
        commentLabel.text = nil
        placeholderImage.image = nil
    }
}

// MARK: - Configure

extension EpisodeCommentTableViewCell {
    func configure(with item: Comment, userImage: UIImage) {
        usernameLabel.text = item.userEmail
        commentLabel.text = item.text
        placeholderImage.image = userImage
    }
}
