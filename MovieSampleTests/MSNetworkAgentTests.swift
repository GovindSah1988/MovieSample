//
//  MSNetworkAgentTests.swift
//  FindMyTrainSampleTests
//
//  Created by Govind Sah on 05/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import XCTest
@testable import MovieSample

/// The MockURLSession acts like a URLSession
class MSMockURLSession: MSURLSessionProtocol {
    
    // for exposing lastURL only as a getter,
    // can be still accessed as public
    private (set) var lastURL: URL?
    
    var currentDataTask = MSMockURLSessionDataTask()
    var responseData: Data?
    var error: Error?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    func failedHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
    }

    func dataTask(with request: URLRequest, completion: @escaping DataTaskResult) -> MSURLSessionDataTaskProtocol {
        lastURL = request.url
        completion(responseData, (nil == error) ? successHttpURLResponse(request: request) : failedHttpURLResponse(request: request), error)
        return currentDataTask
    }
}

/**In URLSession, the return value must be a URLSessionDataTask.
 However, the URLSessionDataTask can’t be created programmatically,
 thus, this is an object that needs to be mocked
 */
class MSMockURLSessionDataTask: MSURLSessionDataTaskProtocol {
    
    private (set) var isResumed = false
    private (set) var isCancelled = false
    
    func cancel() {
        isCancelled = true
    }
    
    func resume() {
        isResumed = true
    }
}

class MSNetworkAgentTests: XCTestCase {

    let session = MSMockURLSession()
    var apiManager: MSAPIManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        apiManager = MSAPIManager(agent: MSNetworkAgent(session: session))
    }

    func test_request_fail() {
        
        session.error = MSError.unknown
        
        let request = MSHomeRequest.getTracks
        
        apiManager.executeRequest(request: request, responseType: MSTrackResponse.self) { (response, error) in
            XCTAssertEqual(MSError.unknown, error as! MSError)
        }
    }
    
    func test_request_cancel() {
        
        session.error = NSError(domain: "", code: NSURLErrorCancelled, userInfo: nil)
        
        let request = MSHomeRequest.getTracks
        apiManager.executeRequest(request: request, responseType: MSTrackResponse.self) { (response, error) in

            // Return data
            // Asserting if the error is present
            XCTAssert(MSError.requestCancelled.localizedDescription == error?.localizedDescription)
            
        }
    }

    func test_request_data() {

        session.responseData = Data()
        
        let request = MSHomeRequest.getTracks

        let completion = expectation(description: "completion")

        apiManager.executeRequest(request: request, responseType: MSTrackResponse.self) { (response, error) in

            completion.fulfill()

            // Return data
            // Asserting if the error is present
            XCTAssert(nil == error)
        }
        
        // to wait out for 1 sec and then call the completion
        wait(for: [completion], timeout: 1)
    }

    /// for testing whether the network agent sends the same url for making the request as intended
    func test_getTrains_request_url() {
        let request = MSHomeRequest.getTracks
        
        let completion = expectation(description: "data task resumed")

        apiManager.executeRequest(request: request, responseType: MSTrackResponse.self) { (response, error) in

            // Return data
            
            completion.fulfill()

            do {
                let requestUrl = try request.asURLRequest().url
                let actualUrl = try response?.request?.asURLRequest().url
                
                // Asserting if the intended request url is different than the actual network request url
                XCTAssert(requestUrl == actualUrl)
                
            } catch {
                
            }

        }
        
        wait(for: [completion], timeout: 2)
        
        // Asserting if the intended request url is different than the actual network request url
        do {
            let url = try request.asURLRequest().url
            XCTAssert(session.lastURL == url)
        } catch {
            
        }
    }
    
    /// for testing the cancel functionality for any outstanding search request
    func test_cancel_outstanding_getStations_request() {
        
        let dataTask = MSMockURLSessionDataTask()
        session.currentDataTask = dataTask
        
        let request = MSHomeRequest.getTracks
        
        let completion = expectation(description: "data task resumed")

        apiManager.executeRequest(request: request, responseType: MSTrackResponse.self) { (response, error) in
            // data
            completion.fulfill()
        }
        
        wait(for: [completion], timeout: 1)
        
        XCTAssert(false == dataTask.isCancelled)
        
        let cancelCompletion = expectation(description: "data task cancelled")
        
        apiManager.cancelRequest()
        
        cancelCompletion.fulfill()
        
        wait(for: [cancelCompletion], timeout: 1)

        XCTAssert(true == dataTask.isCancelled)
    }
    
    /// to test whether the request is actually submitted or not
    func test_get_resume_called() {
        let dataTask = MSMockURLSessionDataTask()
        session.currentDataTask = dataTask
        
        let request = MSHomeRequest.getTracks

        let completion = expectation(description: "data task resumed")
        
        apiManager.executeRequest(request: request, responseType: MSTrackResponse.self) { (response, error) in

            completion.fulfill()
        }
                
        waitForExpectations(timeout: 2) { (_) in
            XCTAssert(true == dataTask.isResumed)
        }
    }
        
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
