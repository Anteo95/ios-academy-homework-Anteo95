//
//  Keychain.swift
//  TVShows
//
//  Created by Anteo Ivankov on 30/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainManager {
    
   private static let shared = Keychain(server: Constants.API.baseURL, protocolType: .https)
    
    private init() {}
    
    class func addUserInfo(username: String, password: String, token: String) {
        shared["username"] = username
        shared["password"] = password
        shared["token"] = token
    }
    
    class func getUserInfo() -> (username: String, password: String, token: String)? {
         if
            let username = shared["username"],
            let password = shared["password"],
            let token = shared["token"] {
            return (username: username, password: password, token: token)
         } else {
            return nil
        }
    }
    
    class func removeUserInfo() {
        shared["username"] = nil
        shared["password"] = nil
        shared["token"] = nil
    }
    
}

