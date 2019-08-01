//
//  EpisodeDetails.swift
//  TVShows
//
//  Created by Anteo Ivankov on 30/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation


struct EpisodeDetails: Codable {
    let id: String
    let showId: String
    let title: String
    let description: String
    let imageUrl: String?
    let episodeNumber: String
    let season: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case showId
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
        case type
    }
}
