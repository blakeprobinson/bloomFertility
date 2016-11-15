//
//  fertilityInput.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/11/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class FertilityInput: NSObject {
    
    var name: Name
    var selected: Bool
    var isCategory: Bool
    var category:Category
    var isLength: Bool
    let requiredInput:RequiredInput?
    
    enum Category:String {
        case bleeding, dry, mucus, none
    }
    
    enum Name:String {
        case dry, bleeding, mucus, lubrication, heavy, moderate, light, veryLight = "very light", brown, damp, shiny, wet, quarterInch = "1/4 Inch", halfToThreeQuarterInch = "1/2 to 3/4 inch", oneInch = "greater than 1 inch", clear, cloudyClear = "cloudy/clear", cloudy, yellow, pasty, none
    }
    
    
    init(name:Name, isCategory:Bool, category:Category, isLength:Bool, requiredInput:RequiredInput?) {
        self.name = name
        self.isCategory = (isCategory)
        self.category = category
//        if let category = Category(rawValue: category) {
//            self.category = category
//        } else {
//            self.category = Category.none
//        }
        self.selected = false
        self.isLength = isLength
        self.requiredInput = requiredInput
        super.init()
    }

}
