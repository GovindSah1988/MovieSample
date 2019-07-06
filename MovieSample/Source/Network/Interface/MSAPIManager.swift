//
//  MSAPIManager.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

class MSAPIManager {
    
    let agent: MSAgentProtocol?

    init(agent: MSAgentProtocol? = RSAgentFactory.agent(cachePolicy: .network)) {
        self.agent = agent
    }
    
    /**
     type:  will tell which response Type the generic A is
            Also response type must be a subclass of MSResponseBaseModel
     */
    func executeRequest<A>(request: MSRequestable, responseType: A.Type, completion: @escaping (MSResponse<A>?, Error?) -> Void) where A: MSResponseBaseModel {
        agent?.execute(request: request) { (responseObject, error) in
            completion(responseObject, error)
        }
    }

    /// to cancel the ongoing network request
    func cancelRequest() {
        agent?.cancelRequest()
    }
}

class RSAgentFactory {
    static func agent(cachePolicy: MSCachePolicy) -> MSAgentProtocol? {
        switch cachePolicy {
        case .local:
            return MSLocalAgent() //Can be used to create MSLocalAgent() in case we have anything to store on db
        case .network:
            return MSNetworkAgent()
        }
    }
}
