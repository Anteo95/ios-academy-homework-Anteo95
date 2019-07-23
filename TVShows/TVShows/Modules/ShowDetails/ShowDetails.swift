//
//  ShowDetails.swift
//  TVShows
//
//  Created by Anteo Ivankov on 20/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation

struct ShowDetails: Codable {
    let id: String
    let type: String
    let title: String
    let description: String
    let likesCount: Int
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type
        case title
        case description
        case likesCount
        case imageUrl
    }
}
