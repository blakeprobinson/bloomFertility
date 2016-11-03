//
//  MenuData.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/3/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

struct MenuData {
    
    static func categoryData() -> [FertilityInput] {
        return [FertilityInput(name: "Dry", isCategory: true, category: "none", isLength:false),
                FertilityInput(name: "Bleeding", isCategory: true, category: "none", isLength:false),
                FertilityInput(name: "Mucus", isCategory: true, category: "none", isLength:false),
                FertilityInput(name: "Lubrication", isCategory: true, category: "none", isLength:false),]
    }
}
