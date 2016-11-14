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
    
    enum Category:String {
        case bleeding, dry, mucus, none
    }
    
    //Potential Replacement for FertilityInput class
    struct FertilityInputTemp {
        enum Bleeding:String {
            case heavy, moderate, light, veryLight = "very light", brown
        }
        
        enum Dry:String {
            case damp, shiny, wet
        }
        
        struct Mucus {
            enum length:String {
                case quarterInch = "1/4 Inch", halfToThreeQuarterInch = "1/2 to 3/4 inch", oneInch = "greater than 1 inch"
            }
            enum color:String {
                case clear, cloudyClear = "cloudy/clear", cloudy, yellow, pasty, none
            }
        }
    }
    
    enum Name:String {
        case dry, bleeding, mucus, lubrication, heavy, moderate, light, veryLight = "very light", brown, damp, shiny, wet, quarterInch = "1/4 Inch", halfToThreeQuarterInch = "1/2 to 3/4 inch", oneInch = "greater than 1 inch", clear, cloudyClear = "cloudy/clear", cloudy, yellow, pasty, none
    }
    
    
    init(name:Name, isCategory:Bool, category:Category, isLength:Bool) {
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
        super.init()
    }

}
