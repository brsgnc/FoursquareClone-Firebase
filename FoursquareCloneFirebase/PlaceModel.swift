//
//  PlaceModel.swift
//  FoursquareCloneFirebase
//
//  Created by Barış Genç on 17.05.2021.
//  Copyright © 2021 BG. All rights reserved.
//

import Foundation
import UIKit

class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    var placeName = ""
    var placeType = ""
    var description = ""
    var image = UIImage()
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    private init() {
        
    }
}
