//
//  StationObject.swift
//  BruinDining
//
//  Created by Anthony Lai on 1/15/17.
//  Copyright © 2017 Anthony Lai. All rights reserved.
//

import Foundation

class StationObject: NSObject {
    
    var name: String
    var foodObjects = [FoodObject]()
    //    var activity: String
    
    init(name: String, foodObjects: [FoodObject]) {
        self.name = name
        self.foodObjects = foodObjects
    }
    
}
