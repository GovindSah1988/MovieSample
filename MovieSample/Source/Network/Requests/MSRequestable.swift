//
//  MSRequestable.swift
//  MovieSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

protocol MSRequestable: MSEndpoint {
    
}

extension MSRequestable {
    func asURLRequest() throws -> URLRequest {
        guard let urlString = baseURL else {
            throw MSError.pathMissing
        }
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw MSError.pathMissing
        }
        
        var urlComponents = URLComponents(string: encodedUrlString)!
        var queryItems = [URLQueryItem]()
        if let parameters = parameters {
            for param in parameters {
                queryItems.append(URLQueryItem(name: param.key, value: param.value as? String))
            }
            urlComponents.queryItems = queryItems
        }
        guard let resourceURL = urlComponents.url else { throw MSError.urlMalformed }
        let request = NSMutableURLRequest(url: resourceURL)
        request.httpMethod = method!
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
}
