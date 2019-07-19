//
//  SessionManager.swift
//  TVShows
//
//  Created by Anteo Ivankov on 19/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import Alamofire

final class SessionManager {
    
    static var shared = Alamofire.SessionManager.default
    
    private init() { }
    
    static func attachAccessTokenAdapter(adapter: AccessTokenAdapter) {
        shared.adapter = adapter
    }
    
}
