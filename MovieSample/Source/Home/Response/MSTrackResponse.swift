//
//  MSTrackResponse.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct MSTrackResponse: MSResponseBaseModel, Decodable {
    
    private(set) var tracks: [MSTrack]?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as! MSAppDelegate
        return appDelegate.persistentContainer
    }()
    
    enum MSTrackResponseConstantKeys: String, CodingKey {
        case tracks = "Tracks"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MSTrackResponseConstantKeys.self)
        self.tracks = try container.decode([MSTrack].self, forKey: .tracks)
    }

    init?(data: Data?) {
        if let data = data {
            do {
                
                // deleting the existing tracks from the local db
                try MSOfflineManager.shared.removeFromStorage(type: MSTrack.self)
                
                let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext!
                let managedObjectContext = persistentContainer.viewContext
                
                let decoder = JSONDecoder()
                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                self = try decoder.decode(MSTrackResponse.self, from: data)
                
                // to save the data in the local db
                try managedObjectContext.save()
            } catch let parsingError {
                print("Error", parsingError)
            }
        } else {
            // fetch from the local db
            do {
                self.tracks = try MSOfflineManager.shared.fetchFromStorage()
            } catch {
                print("Error", error)
            }
        }
    }
}
