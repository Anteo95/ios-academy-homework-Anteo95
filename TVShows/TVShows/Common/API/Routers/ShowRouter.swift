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
    case readShowDetails(id: String)
    case readShowEpisodes(id: String)
    case createShowEpisode(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .readShows:
            return .get
        case .readShowDetails:
            return .get
        case .readShowEpisodes:
            return .get
        case .createShowEpisode:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .readShows:
            return "/shows"
        case .readShowDetails(let id):
            return "/shows/\(id)"
        case .readShowEpisodes(let id):
            return "/shows/\(id)/episodes"
        case .createShowEpisode:
            return "/episodes"
        }
    }
    
    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: Constants.API.baseURL + path, method: method, headers: nil)
        
        switch self {
        case .readShows:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .readShowDetails:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .readShowEpisodes:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .createShowEpisode(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
