//
//  MSBaseAgent.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

/// done in order to mock URLSessionDataTask
protocol MSURLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

/// done in order to mock URLSession
protocol MSURLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping DataTaskResult) -> MSURLSessionDataTaskProtocol
}

extension URLSession: MSURLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping DataTaskResult) -> MSURLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completion) as MSURLSessionDataTaskProtocol
    }
}

/// by default URLSessionDataTask has something called resume() method
/// so no need to add protocol's method - func resume()
extension URLSessionDataTask: MSURLSessionDataTaskProtocol { }

class MSBaseAgent {
    
    /// It is an object of MSURLSessionProtocol -
    /// which must adpot the functionalities of the URLSession ultimately.
    private (set) var session: MSURLSessionProtocol? // only for exposing the getter for session object
    
    // Adding dependency injection for URLSession so that it can be mocked
    init(session: MSURLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}
