//
//  ShowService.swift
//  TVShows
//
//  Created by Anteo Ivankov on 17/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

final class ShowService {
    
    // MARK: - Typealiases
    
    typealias FetchShowsResponseBlock = (Result<[Show]>) -> Void
    typealias FetchShowDetailsResponseBlock = (Result<ShowDetails>) -> Void
    typealias FetchShowEpisodesResponseBlock = (Result<[Episode]>) -> Void
    typealias CreateEpisodeResponseBlock = (Result<Episode>) -> Void
    typealias FetchEpisodeDetailsResponseBlock = (Result<EpisodeDetails>) -> Void
    typealias FetchEpisodeCommentsResponseBlock = (Result<[Comment]>) -> Void
    typealias CreateCommentResponseBlock = (Result<Comment>) -> Void
    typealias UploadImageResponseBlock = (Result<Media>) -> Void
    
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
    
    func createEpisodeForShow(with id: String, title: String, description: String, episodeNumber: String?, season: String?, mediaId: String?, completionHandler: @escaping  CreateEpisodeResponseBlock) {
        let parameters: [String: Any] = [
                "title": title,
                "showId": id,
                "description": description,
                "episodeNumber": episodeNumber,
                "season": season,
                "mediaId": mediaId
        ]
        .compactMapValues { $0 }
        
        request(router: ShowRouter.createShowEpisode(parameters: parameters), completionHandler: completionHandler)
    }
    
    func fetchDetailsForEpisode(with id: String, completionHandler: @escaping FetchEpisodeDetailsResponseBlock) {
        request(router: ShowRouter.episodeDetails(id: id), completionHandler: completionHandler)
    }
    
    func fetchCommentsForEpisode(with id: String, completionHandler: @escaping FetchEpisodeCommentsResponseBlock) {
        request(router: ShowRouter.episodeComments(id: id), completionHandler: completionHandler)
    }
    
    func createCommentForEpisode(with id: String, text: String, completionHandler: @escaping CreateCommentResponseBlock) {
        let parameters: [String: Any] = [
            "episodeId": id,
            "text": text
        ]
        request(router: ShowRouter.createComment(parameters: parameters), completionHandler: completionHandler)
    }
    
    func uploadImage(imageBytedata: Data, completionHandler: @escaping UploadImageResponseBlock) {
        Alamofire
            .upload(multipartFormData: { multipartformdata in
            multipartformdata.append(imageBytedata,
                                      withName: "file",
                                      fileName: "image.png",
                                      mimeType: "image/png")
            }, with: ShowRouter.uploadImage) { result in
                switch result {
                case .success(let uploadRequest, _, _):
                    uploadRequest.responseDecodableObject(keyPath: "data") { (response: DataResponse<Media>) in
                            completionHandler(response.result)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
    }
    
}
