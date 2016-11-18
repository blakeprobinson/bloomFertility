//
//  InputViewModel.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/17/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation
import UIKit

struct InputViewModel {
    
    let name: String
    let color: UIColor
    var selected: Bool
    let isCategory: Bool
    let category: FertilityInput.Category
    let isLength: Bool
    let requiredInput: RequiredInput?
    
    init(input: FertilityInput) {
        self.name = input.name.rawValue
        self.color = InputViewModel.colorForCell(input)
        self.selected = input.selected
        self.isCategory = input.isCategory
        self.category = input.category
        self.isLength = input.isLength
        self.requiredInput = input.requiredInput
        
    }
    
    private static func colorForCell(_ input: FertilityInput) -> UIColor {
        var color:UIColor
        switch input.category {
        case .none:
            switch input.name {
            case .dry:
                color = UIColor(red: 93.0/255, green: 188.0/255, blue: 210.0/255, alpha: 1.0)
            case .bleeding:
                color = UIColor(red: 255.0/255, green: 192.0/255, blue: 203.0/255, alpha: 1.0)
            case .lubrication:
                //rgb(255,255,102)
                color = UIColor(red: 255.0/255, green: 255.0/255, blue: 102.0/255, alpha: 1.0)
            case .mucus:
                color = UIColor(red: 230.0/255, green: 230.0/255, blue: 250.0/255, alpha: 1.0)
            default:
                color = UIColor(red: 230.0/255, green: 230.0/255, blue: 250.0/255, alpha: 1.0)
                print("arrived at meaningless default in switch")
            }
        case .dry:
            color = UIColor(red: 93.0/255, green: 188.0/255, blue: 210.0/255, alpha: 1.0)
        case .bleeding:
            color = UIColor(red: 255.0/255, green: 192.0/255, blue: 203.0/255, alpha: 1.0)
        default:
            color = UIColor(red: 230.0/255, green: 230.0/255, blue: 250.0/255, alpha: 1.0)
        }
        return color
    }
    
    
}
