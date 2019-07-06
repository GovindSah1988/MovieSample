//
//  MSNetworkAgent.swift
//  MovieSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

class MSNetworkAgent: MSBaseAgent {
    
    /// It is an object of MSURLSessionDataTaskProtocol -
    /// which must adpot the functionalities of the URLSessionDataTask ultimately.
    var requestTask: MSURLSessionDataTaskProtocol?
}

typealias MSDataResponse<A> = (MSResponse<A>?, Error?) -> Void

extension MSNetworkAgent: MSAgentProtocol {
    
    internal func execute<A>(request: MSRequestable, completion: @escaping MSDataResponse<A>) where A: MSResponseBaseModel {
        
        do {
            let urlRequest = try request.asURLRequest()
            // making request on global queue
            DispatchQueue.global(qos: .userInitiated).async {
                self.requestTask = self.session?.dataTask(with: urlRequest as URLRequest, completion: { data, res, error -> Void in
                    if nil !=  error {
                        var err = MSError.unknown
                        if (error as NSError?)?.code == NSURLErrorCancelled {
                            err = MSError.requestCancelled
                        } else if (error as NSError?)?.code == NSURLErrorNotConnectedToInternet {
                            err = MSError.notConnectedToInternet
                        }
                        DispatchQueue.main.async {
                            completion(nil, err)
                        }
                    } else {
                        guard let data = data else {
                            let response = MSResponse<A>(urlResponse: res as? HTTPURLResponse, request: request)
                            DispatchQueue.main.async {
                                completion(response, MSError.unknown)
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            let response = MSResponse(urlResponse: res as? HTTPURLResponse, result: A.init(data: data), request: request)
                            completion(response, nil)
                        }
                    }
                })
                self.requestTask?.resume()
            }
        } catch {
            
        }
        
    }
    
    func cancelRequest() {
        self.requestTask?.cancel()
    }
}
