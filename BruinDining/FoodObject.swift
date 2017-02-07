//
//  FoodObject.swift
//  BruinDining
//
//  Created by Anthony Lai on 1/15/17.
//  Copyright © 2017 Anthony Lai. All rights reserved.
//

import Foundation

class FoodObject: NSObject {
    
    var name: String
//    var activity: String
    var allergens = [String]()
    
    init(name: String, allergens: [String]) {
        self.name = name
        self.allergens = allergens
    }
    
}
