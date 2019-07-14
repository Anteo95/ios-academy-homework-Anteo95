//
//  LoginService.swift
//  TVShows
//
//  Created by Anteo Ivankov on 13/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire

final class UserService {
    
    // MARK: - Typealiases
    
    typealias RegisterResponseBlock = (DataResponse<User>) -> Void
    typealias LoginResponseBlock = (DataResponse<LoginData>) -> Void
    
    // MARK: - Register API request
    
    func register(with email: String, password: String, completionHandler: @escaping RegisterResponseBlock) {
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        Alamofire
            .request("https://api.infinum.academy/api/users",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder(), completionHandler: completionHandler)
    }
    
    // MARK: - Login API request
    
    func login(with email: String, password: String, completionHandler: @escaping LoginResponseBlock) -> Void {
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        Alamofire
            .request(
            "https://api.infinum.academy/api/users/sessions",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder(), completionHandler: completionHandler)
    }
}


