//
//  TVShowGridCollectionViewCell.swift
//  TVShows
//
//  Created by Anteo Ivankov on 30/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

class TVShowGridCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var showImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        showImage.image = nil
    }

}

// MARK: - Configure

extension TVShowGridCollectionViewCell {
    func configure(with item: Show) {
        if let imageUrlString = item.imageUrl {
            showImage.kf.setImage(with: URL(string: Constants.API.baseURL + imageUrlString))
        }
    }
}
