//
//  MSConstants.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct MSConstants {
    
    /// add all the localized constant here
    struct MSLocalizedStringConstants {
        static let alertOk = "OK"
        static let commonErrorInfo = "Something Went Wrong. Unable to connect to Server!!"
        static let homeTitle = "Home"
        static let emptyContent = "No Contents To Show!!"
    }
    
    /// add all the view identifiers here
    struct MSViewIdentifiers {
        static let detailVC = "MSDetailViewController"
        static let trackTVC = "MSTrackTableViewCell"
    }
    
    /// add all the storyboard name here
    struct MSStoryboardConstants {
        static let main = "Main"
    }
}

enum MSError: Error {
    case unknown
    case pathMissing
    case urlMalformed
    case requestCancelled
    case notConnectedToInternet
}

/** Specifies the cache policies used in the app
 - network : The data is directly fetched from the network and cache is updated
 - local   : The data is fetched from the cache (in our case 'Realm')
 */
enum MSCachePolicy: Int {
    case network
    case local
}

enum MSRequestMethod: String {
    case get = "GET"
    case post = "POST"
}
