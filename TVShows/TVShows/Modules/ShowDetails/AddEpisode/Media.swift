//
//  Media.swift
//  TVShows
//
//  Created by Anteo Ivankov on 31/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation

struct Media: Codable {
    let id: String
    let path: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case path
        case type
    }
}
