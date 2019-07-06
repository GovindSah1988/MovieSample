//
//  MSTrackTableViewCell.swift
//  MovieSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class MSTrackTableViewCell: UITableViewCell {

    var track: MSTrack! {
        didSet {
            trackIV.loadImage(fromURL: track.imageUrl)
            titleLB.text = track.title
        }
    }
    
    @IBOutlet weak var trackIV: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    
    override func prepareForReuse() {
        trackIV.image = UIImage()
    }
}
