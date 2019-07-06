//
//  MSLocalAgent.swift
//  MovieSample
//
//  Created by Govind Sah on 05/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class MSLocalAgent: MSBaseAgent {

}

extension MSLocalAgent: MSAgentProtocol {
    
    internal func execute<A>(request: MSRequestable, completion: @escaping MSDataResponse<A>) where A: MSResponseBaseModel {
        
        DispatchQueue.main.async {
            let response = MSResponse(urlResponse: nil, result: A.init(data: nil), request: request)
            completion(response, nil)
        }
    }
    
    func cancelRequest() {
        // do nothing
    }
}
