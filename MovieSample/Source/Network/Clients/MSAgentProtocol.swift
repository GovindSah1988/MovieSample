//
//  MSAgentProtocol.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

protocol MSAgentProtocol {
    // A - generic type which allows any response type(provided it conforms to MSResponseBaseModel)
    func execute<A>(request: MSRequestable, completion: @escaping (MSResponse<A>?, Error?) -> Void) where A: MSResponseBaseModel
    func cancelRequest()
}
