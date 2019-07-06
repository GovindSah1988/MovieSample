//
//  MSStoryboardExtension.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /// returns main story board
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: MSConstants.MSStoryboardConstants.main, bundle: nil)
    }
}
