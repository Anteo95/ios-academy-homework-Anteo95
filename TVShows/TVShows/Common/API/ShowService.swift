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
    
    typealias GetShowsResponseBlock = (Result<[Show]>) -> Void
    
    // MARK: - API requests
    
    func fetchShows(completionHandler: @escaping GetShowsResponseBlock) {
        Alamofire
            .request(ShowRouter.readShows)
            .validate()
            .responseDecodableObject(keyPath: "data") { dataResponse in
                completionHandler(dataResponse.result)
            }
    }
}
