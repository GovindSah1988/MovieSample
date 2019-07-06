//
//  MSDetailViewController.swift
//  MovieSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class MSDetailViewController: UIViewController {

    @IBOutlet weak var trackIV: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var descriptionLB: UILabel!
    
    var track: MSTrack!
    
    class func detailVC() -> MSDetailViewController {
        let storyboard = UIStoryboard.mainStoryboard()
        let detailViewController = storyboard.instantiateViewController(withIdentifier: MSConstants.MSViewIdentifiers.detailVC) as! MSDetailViewController
        return detailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    private func initialSetup() {
        if nil != track {
            trackIV.loadImage(fromURL: track.imageUrl)
            titleLB.text = track.title
            descriptionLB.text = track.descriptionStr
        }
    }
    
}
