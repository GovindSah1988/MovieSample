//
//  MSHomeRequest.swift
//  MovieSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

enum MSHomeRequest: MSRequestable {
    case getTracks
    
    var baseURL: String? {
        switch self {
        case .getTracks:
            return MSNetworkConstants.APIEndpoints.allAlbums
        }
    }
    
    var parameters: APIParams? {
        switch self {
        case .getTracks:
            return fetchTrackParams()
        }
    }

    var method: String? {
        return MSRequestMethod.get.rawValue
    }

}

extension MSHomeRequest {
    
    private func fetchTrackParams() -> APIParams {
        return APIParams()
    }
}
