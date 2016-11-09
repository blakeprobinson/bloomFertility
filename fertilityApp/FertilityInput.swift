//
//  fertilityInput.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/11/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class FertilityInput: NSObject {
    
    var name: String
    var selected: Bool
    var isCategory: Bool
    var category:Category
    var isLength: Bool
    
    enum Category:String {
        case bleeding
        case dry
        case mucus
        case none
    }
    
    
    init(name:String, isCategory:Bool, category:Category, isLength:Bool) {
        self.name = (name)
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
