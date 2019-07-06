//
//  MSResponse.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

// the generic type Result is stored as 'result' property type
struct MSResponse<Result> {
    // MARK: - Properties
    var request: MSRequestable?
    var headerReponse: [AnyHashable: Any]?
    var statusCode: Int?
    var result: Result?
    
    // MARK: - init method
    init(urlResponse: HTTPURLResponse?, result: Result? = nil, request: MSRequestable?) {
        self.request = request
        statusCode = urlResponse?.statusCode
        headerReponse = urlResponse?.allHeaderFields
        self.result = result
    }
}
