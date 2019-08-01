//
//  Comment.swift
//  TVShows
//
//  Created by Anteo Ivankov on 31/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation


struct Comment: Codable {
    let id: String
    let text: String
    let episodeId: String
    let userEmail: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
        case episodeId
        case userEmail
    }
}
