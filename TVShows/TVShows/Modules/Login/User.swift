//
//  User.swift
//  TVShows
//
//  Created by Anteo Ivankov on 13/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}

struct LoginData: Codable {
    let token: String
}
