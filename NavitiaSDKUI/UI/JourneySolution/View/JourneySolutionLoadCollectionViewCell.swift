//
//  JourneySolutionLoadCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 04/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionLoadCollectionViewCell: UICollectionViewCell {
    
    func setup() {
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
