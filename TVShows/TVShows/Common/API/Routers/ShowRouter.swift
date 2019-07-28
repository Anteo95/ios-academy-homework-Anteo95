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
    case shows
    case showDetails(id: String)
    case showEpisodes(id: String)
    case createShowEpisode(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .shows, .showDetails, .showEpisodes:
            return .get
        case .createShowEpisode:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .shows:
            return "/api/shows"
        case .showDetails(let id):
            return "/api/shows/\(id)"
        case .showEpisodes(let id):
            return "/api/shows/\(id)/episodes"
        case .createShowEpisode:
            return "/api/episodes"
        }
    }
    
    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: Constants.API.baseURL + path, method: method, headers: nil)
        
        switch self {
        case .shows, .showDetails, .showEpisodes:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .createShowEpisode(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
