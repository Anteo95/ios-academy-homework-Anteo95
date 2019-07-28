//
//  AccessTokenAdapter.swift
//  TVShows
//
//  Created by Anteo Ivankov on 18/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import Alamofire

final class AccessTokenAdapter: RequestAdapter {
    
    // MARK: - Private properties
    
    private let accessToken: String

    // MARK: - Initialization
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }

    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
