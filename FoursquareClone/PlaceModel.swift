//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Yurii Sameliuk on 16/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//


import UIKit
 // sozdaem singlton
class PlaceModel {

    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placelongitude = ""
    
    private init(){}
}
