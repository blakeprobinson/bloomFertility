//
//  MenuData.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/3/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

struct MenuData {
    var fertilityInputs = MenuData.categoryData()
    private var dryInputs = MenuData.drySubCategory()
    private var bleedingInputs = MenuData.bleedingSubCategory()
    private var mucusInputs = MenuData.mucusSubCategory()
    
    mutating func selected(input fertilityInput: FertilityInput) {
        if fertilityInput.isCategory == true {
            switch fertilityInput.name {
            case "Dry":
                addSubInputsToFertilityArray(dryInputs)
            case "Mucus":
                addSubInputsToFertilityArray(mucusInputs)
            case "Lubrication":
                print("Lubrication Selected")
            default:
                addSubInputsToFertilityArray(bleedingInputs)
            }
        }
    }
}

// MARK: Private Helpers

private extension MenuData {
    
    mutating func addSubInputsToFertilityArray(_ subArray: [FertilityInput]) {
        var indexPaths = [IndexPath]()
        for (index, element) in fertilityInputs.enumerated() {
            //if the subArray is the category of the fertilityInput
            if element.name == subArray[0].category {
                //aadd the elements of the subArray to FertilityInput
                var insertIndex = index + 1
                for subArrayElement in subArray {
                    fertilityInputs.insert(subArrayElement, at: insertIndex)
                    let indexPath = IndexPath(row: insertIndex, section: 0)
                    indexPaths.append(indexPath)
                    insertIndex += 1
                }
            }
        }
    }
}

// MARK: Static Data

private extension MenuData {
    
    static func categoryData() -> [FertilityInput] {
        return [FertilityInput(name: "Dry", isCategory: true, category: "none", isLength:false),
                FertilityInput(name: "Bleeding", isCategory: true, category: "none", isLength:false),
                FertilityInput(name: "Mucus", isCategory: true, category: "none", isLength:false),
                FertilityInput(name: "Lubrication", isCategory: true, category: "none", isLength:false)]
    }
    
    static func bleedingSubCategory() -> [FertilityInput] {
        return [FertilityInput(name: "Heavy", isCategory: false, category: "Bleeding", isLength:false),
                FertilityInput(name: "Moderate", isCategory: false, category: "Bleeding", isLength:false),
                FertilityInput(name: "Light", isCategory: false, category: "Bleeding", isLength:false),
                FertilityInput(name: "Very Light", isCategory: false, category: "Bleeding", isLength:false),
                FertilityInput(name: "Brown", isCategory: false, category: "Bleeding", isLength:false)]
    }
    
    static func drySubCategory() -> [FertilityInput] {
        return [FertilityInput(name: "Damp", isCategory: false, category: "Dry", isLength:false),
                FertilityInput(name: "Shiny", isCategory: false, category: "Dry", isLength:false),
                FertilityInput(name: "Wet", isCategory: false, category: "Dry", isLength:false)]
    }
    
    static func mucusSubCategory() -> [FertilityInput] {
        return [FertilityInput(name: "1/4 Inch", isCategory: false, category: "Mucus", isLength: true),
                FertilityInput(name: "1/2 to 3/4 inch", isCategory: false, category: "Mucus", isLength: true),
                FertilityInput(name: "Greater than 1 inch", isCategory: false, category: "Mucus", isLength: true),
                FertilityInput(name: "Clear", isCategory: false, category: "Mucus", isLength:false),
                FertilityInput(name: "Cloudy/Clear", isCategory: false, category: "Mucus", isLength:false),
                FertilityInput(name: "Cloudy", isCategory: false, category: "Mucus", isLength:false),
                FertilityInput(name: "Yellow", isCategory: false, category: "Mucus", isLength:false),
                FertilityInput(name: "Brown", isCategory: false, category: "Mucus", isLength:false),
                FertilityInput(name: "Pasty", isCategory: false, category: "Mucus", isLength:false)]
    }
}
