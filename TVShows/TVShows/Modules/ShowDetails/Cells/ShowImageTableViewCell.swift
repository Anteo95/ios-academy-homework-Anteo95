//
//  ShowImageTableViewCell.swift
//  TVShows
//
//  Created by Anteo Ivankov on 23/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import Kingfisher

class ShowImageTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var showImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        showImage.image = nil
    }
}

// MARK: - Configure

extension ShowImageTableViewCell {
    func configure(with urlString: String) {
        showImage.kf.setImage(with: URL(string: urlString))
    }
}
