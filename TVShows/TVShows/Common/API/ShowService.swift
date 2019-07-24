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
    
    func fetchShows(completionHandler: @escaping FetchShowsResponseBlock) {
        Alamofire
            .request(ShowRouter.readShows)
            .validate()
            .responseDecodableObject(keyPath: "data") { dataResponse in
                completionHandler(dataResponse.result)
            }
    }
    
    func fetchShowDetails(with id: String, completionHandler: @escaping FetchShowDetailsResponseBlock) {
        Alamofire
            .request(ShowRouter.readShowDetails(id: id))
            .validate()
            .responseDecodableObject(keyPath: "data") { dataResponse in
                completionHandler(dataResponse.result)
            }
    }
    
    func fetchEpisodesForShow(with id: String, completionHandler: @escaping FetchShowEpisodesResponseBlock) {
        Alamofire
            .request(ShowRouter.readShowEpisodes(id: id))
            .validate()
            .responseDecodableObject(keyPath: "data") { dataResponse in
                completionHandler(dataResponse.result)
            }
    }
    
    func createEpisodeForShow(with id: String, title: String, description: String, episodeNumber: String?, season: String?, completionHandler: @escaping  CreateEpisodeResponseBlock) {
        let parameters: [String: Any] = [
                "title": title,
                "showId": id,
                "description": description,
                "episodeNumber": episodeNumber,
                "season": season
        ]
        .filter { $0.value != nil && $0.value != "" }
        .mapValues{ $0! }
        
        Alamofire
            .request(ShowRouter.createShowEpisode(parameters: parameters))
            .validate()
            .responseDecodableObject(keyPath: "data") { dataResponse in
                completionHandler(dataResponse.result)
            }
    }
}
