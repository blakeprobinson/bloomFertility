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
    var category:String
    var isLength: Bool
    
    
    init(name:String, isCategory:Bool, category:String, isLength:Bool) {
        self.name = (name)
        self.isCategory = (isCategory)
        self.category = category
        self.selected = false
        self.isLength = isLength
        super.init()
    }

}
