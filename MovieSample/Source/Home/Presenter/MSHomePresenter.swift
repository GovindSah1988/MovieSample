//
//  MSHomePresenter.swift
//  MovieSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

protocol MSHomePresenterOutput: class {
    func tracks(_ tracks: [MSTrack]?, error: MSError?)
}

/**
 Protocol that defines the Presenter's use case.
 */
protocol MSHomePresenterInput: class {
    func fetchTracks(cachePolicy: MSCachePolicy)
    func numberOfTracks() -> Int
    func track(at index: Int) -> MSTrack?
}

class MSHomePresenter: NSObject {
    
    // to hold the list of API manager objects
    // in case we need to cancel thme at later point of time
    private var managers: NSMutableArray = []
    
    // weak can never be let as the ARC can set nil to this variable whenever it needs to
    weak private var output: MSHomePresenterOutput?
    
    private var tracks: [MSTrack]?
    
    init(delegate: MSHomePresenterOutput) {
        output = delegate
    }

}

extension MSHomePresenter: MSHomePresenterInput {
    
    func numberOfTracks() -> Int {
        return tracks?.count ?? 0
    }
    
    func track(at index: Int) -> MSTrack? {
        guard let tracks = tracks, tracks.count > 0 else {
            return nil
        }
        return tracks[index]
    }
    
    func fetchTracks(cachePolicy: MSCachePolicy = .network) {
        cancelOutstandingRequests()
        let request = MSHomeRequest.getTracks
        let apiManager = MSAPIManager(agent: RSAgentFactory.agent(cachePolicy: cachePolicy))
        managers.add(apiManager)
        apiManager.executeRequest(request: request, responseType: MSTrackResponse.self) { [weak self] (response, error) in
            if nil == error, nil != response {
                self?.tracks = response?.result?.tracks
                self?.output?.tracks(self?.tracks, error: error as? MSError)
            } else {
                //TODO: handle error cases
                
                // fetch from local db in case the network is offline
                if cachePolicy == .network && (error as? MSError) == MSError.notConnectedToInternet {
                    self?.fetchTracks(cachePolicy: .local)
                } else {
                    self?.output?.tracks(nil, error: MSError.unknown)
                }
            }
            self?.managers.remove(apiManager)
        }
    }
    
    private func cancelOutstandingRequests() {
        if managers.count > 0 {
            for manager in managers {
                (manager as? MSAPIManager)?.cancelRequest()
            }
            managers.removeAllObjects()
        }
    }
}
