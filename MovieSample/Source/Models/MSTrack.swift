//
//  MSTrack.swift
//  MovieSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation
import CoreData

class MSTrack: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case imageUrl = "track_art_work"
        case album = "track_album"
        case artist = "artist"
    }

    @NSManaged var imageUrl: String
    @NSManaged var title: String
    @NSManaged var album: String
    @NSManaged var artist: String
    
    var descriptionStr: String {
        return artist.capitalized + " | " + album.capitalized
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: MSTrack.className, in: managedObjectContext) else {
                fatalError("Failed to decode MSTrack")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        album = try container.decode(String.self, forKey: .album)
        artist = try container.decode(String.self, forKey: .artist)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(album, forKey: .album)
        try container.encode(artist, forKey: .artist)
    }
}
