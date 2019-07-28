//
//  ShowService.swift
//  TVShows
//
//  Created by Anteo Ivankov on 17/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import Alamofire

final class ShowService {
    
    // MARK: - Typealiases
    
    typealias FetchShowsResponseBlock = (Result<[Show]>) -> Void
    typealias FetchShowDetailsResponseBlock = (Result<ShowDetails>) -> Void
    typealias FetchShowEpisodesResponseBlock = (Result<[Episode]>) -> Void
    typealias CreateEpisodeResponseBlock = (Result<Episode>) -> Void
    
    // MARK: - API requests
    
    func request<T: Decodable>(router: URLRequestConvertible, completionHandler: @escaping (Result<T>) -> Void) {
        Alamofire
            .request(router)
            .validate()
            .responseDecodableObject(keyPath: "data") { dataResponse in
                completionHandler(dataResponse.result)
        }
    }
    
    func fetchShows(completionHandler: @escaping FetchShowsResponseBlock) {
        request(router: ShowRouter.shows, completionHandler: completionHandler)
    }
    
    func fetchShowDetails(with id: String, completionHandler: @escaping FetchShowDetailsResponseBlock) {
        request(router: ShowRouter.showDetails(id: id), completionHandler: completionHandler)
    }
    
    func fetchEpisodesForShow(with id: String, completionHandler: @escaping FetchShowEpisodesResponseBlock) {
        request(router: ShowRouter.showEpisodes(id: id), completionHandler: completionHandler)
    }
    
    func createEpisodeForShow(with id: String, title: String, description: String, episodeNumber: String?, season: String?, completionHandler: @escaping  CreateEpisodeResponseBlock) {
        let parameters: [String: Any] = [
                "title": title,
                "showId": id,
                "description": description,
                "episodeNumber": episodeNumber,
                "season": season
        ]
        .compactMapValues { $0 }
        
        request(router: ShowRouter.createShowEpisode(parameters: parameters), completionHandler: completionHandler)
    }
}
