//
//  Episode.swift
//  TVShows
//
//  Created by Anteo Ivankov on 20/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String?
    let episodeNumber: String
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}


