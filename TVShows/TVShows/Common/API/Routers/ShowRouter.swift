//
//  TVShowService.swift
//  TVShows
//
//  Created by Anteo Ivankov on 17/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import Alamofire

enum ShowRouter: URLRequestConvertible {
    case readShows
    
    var method: HTTPMethod {
        switch self {
        case .readShows:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .readShows:
            return "/shows"
        }
    }
    
    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: Constants.API.baseURL + path, method: method, headers: nil)
        
        switch self {
        case .readShows:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
