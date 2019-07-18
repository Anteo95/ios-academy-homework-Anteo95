//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Anteo Ivankov on 17/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit

final class TVShowTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var title: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // One of THE MOST important function in UITableViewCell
        // This method will be called before your cell gets dequeued
        // So this will give you time to "reset" the data you have in this cell
        // Failure to do so can result in wrong data in the wrong cell
        // Imageine that one cell is missing its thumbnail image,
        // and you reuse cell and you don't clean the thumbnail, you will have that same thumbnail once cell is reused.
        title.text = nil
    }
    
}

// MARK: - Configure

extension TVShowTableViewCell {
    func configure(with item: Show) {
        // Here we are using conditional unwrap, meaning if we have the image, use that, if not, fallback to placeholder image.
        title.text = item.title
    }
}

// MARK: - Private
private extension TVShowTableViewCell {
    func setupUI() {
        
    }
}
