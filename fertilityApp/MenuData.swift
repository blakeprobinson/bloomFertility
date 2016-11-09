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
    var lubricationSelected = false
    var heartTouched = false
    private var dryInputs = MenuData.drySubCategory()
    private var bleedingInputs = MenuData.bleedingSubCategory()
    private var mucusInputs = MenuData.mucusSubCategory()
    
    mutating func selected(input fertilityInput: FertilityInput) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        if fertilityInput.isCategory == true {
            switch fertilityInput.name {
            case "dry":
                indexPaths = addSubInputsToFertilityArray(dryInputs)
            case "mucus":
                indexPaths = addSubInputsToFertilityArray(mucusInputs)
            case "lubrication":
                print("Lubrication Selected")
            default:
                indexPaths = addSubInputsToFertilityArray(bleedingInputs)
            }
        }
        return indexPaths
    }
    
    mutating func removeSubInputsFromFertilityArrayReturnIndexPaths(_ FertilityInput: FertilityInput) -> [IndexPath]? {
        if FertilityInput.isCategory == true {
            switch FertilityInput.name {
                
            case "dry":
                return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths("dry")
            case "mucus":
                return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths("mucus")
            case "lubrication":
                return nil
            default:
                return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths("bleeding")
            }
        }
        return nil
    }
    
    mutating func removeAnySubInputsFromFertilityArray() {
        fertilityInputs = MenuData.categoryData()
    }
    
    mutating func selectedElements() -> [FertilityInput] {
        var selectedArray = [FertilityInput]()
        for (_, element) in fertilityInputs.enumerated() {
            if element.selected && !element.isCategory {
                selectedArray.append(element)
            }
            //Since lubrication is a category with no items in it we need this
            //conditional
            if element.name == "Lubrication" {
                lubricationSelected = true
            }
        }
        return selectedArray
    }
    
    func validateInputs(_ selectedArray:[FertilityInput]) -> String {
        var selectedArray = selectedArray
        var validationText = ""
        let arrayCount =  selectedArray.count
        selectedArray.sort { $0.category.rawValue < $1.category.rawValue }
        var categoryZero = String()
        var categoryOne = String()
        if arrayCount > 0 {
            categoryZero = selectedArray[0].category.rawValue
        }
        if arrayCount > 1 {
            categoryOne = selectedArray[1].category.rawValue
        }
        
        switch arrayCount {
        case 0:
            validationText = "I think you forgot to choose an option ;)"
        case 1:
            if categoryZero == "Mucus" {
                if selectedArray[0].isLength {
                    validationText = "Please select a color for the mucus, too"
                } else {
                    validationText = "Please select a length for the mucus, too"
                }
            }
        case 2:
            //case 1 one each from two different categories
            if categoryZero != categoryOne {
                //validate that one element is bleeding - very light/brown and the
                //the situation could be needing to select a length or a color in mucus...
                if categoryZero == "Bleeding" && categoryOne == "Mucus" {
                    if selectedArray[0].name == "Light" || selectedArray[0].name == "Very Light" || selectedArray[0].name == "Brown" {
                        if selectedArray[1].isLength {
                            //please select a color
                        } else {
                            //please select a length
                        }
                    }
                } else {
                    validationText = "Dry doesn't work with any other option ;)"
                }
            } else {
                //case 2 two from "Bleeding", but not one length and one color
                if categoryZero == "Bleeding" {
                    
                    if selectedArray[0].isLength && selectedArray[1].isLength {
                        validationText = "Please select a color instead of one of the lengths you selected."
                    } else if !selectedArray[0].isLength && !selectedArray[1].isLength {
                        validationText = "Please select a length instead of one of the colors you selected."
                    }
                } else if categoryZero == "Mucus" {
                    if selectedArray[0].isLength && !selectedArray[1].isLength {
                        
                    } else if !selectedArray[0].isLength && selectedArray[1].isLength {
                        
                    } else {
                        validationText = "Please select one length and one color from the mucus category."
                    }
                } else {
                    //case 3 two from the same category, but not "bleeding"
                    validationText = "You can only choose one from the Dry and Bleeding categories."
                    
                }
            }
        case 3:
            let firstFertilityInput = selectedArray[0]
            let secondFertilityInput = selectedArray[1]
            let thirdFertilityInput = selectedArray[2]
            if firstFertilityInput.name == "Light" || firstFertilityInput.name == "Very Light" || firstFertilityInput.name == "Brown" {
                //since a value of false for isLength could be another category besides mucus
                //I am checking to make sure the category is mucus
                if secondFertilityInput.isLength && !thirdFertilityInput.isLength && thirdFertilityInput.category.rawValue == "mucus" {
                    
                    
                } else if !secondFertilityInput.isLength && secondFertilityInput.category.rawValue == "mucus" && thirdFertilityInput.isLength {
                    
                } else {
                    validationText = "The only combination of three selections is Light, Very Light or Brown Bleeding and two Mucus selections"
                }
            }
            
        default:
            validationText = "I think you've chosen at least one too many options ;)"
            
        }
        return validationText
    }

}

// MARK: Private Helpers

private extension MenuData {
    
    mutating func addSubInputsToFertilityArray(_ subArray: [FertilityInput]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for (index, element) in fertilityInputs.enumerated() {
            //if the subArray is the category of the fertilityInput
            if element.name == subArray[0].category.rawValue {
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
        return indexPaths
    }
    
    mutating func removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths(_ category: String) ->  [IndexPath]{
        var indexPathArray = [IndexPath]()
        for (index, element) in fertilityInputs.enumerated().reversed() {
            if element.category.rawValue == category {
                fertilityInputs.remove(at: index)
                let indexPath = IndexPath(row: index, section: 0)
                indexPathArray.append(indexPath)
            }
        }
        return indexPathArray
    }
}

// MARK: Static Data

private extension MenuData {
    
    static func categoryData() -> [FertilityInput] {
        return [FertilityInput(name: "dry", isCategory: true, category: FertilityInput.Category.none, isLength:false),
                FertilityInput(name: "bleeding", isCategory: true, category: FertilityInput.Category.none, isLength:false),
                FertilityInput(name: "mucus", isCategory: true, category: FertilityInput.Category.none, isLength:false),
                FertilityInput(name: "lubrication", isCategory: true, category: FertilityInput.Category.none, isLength:false)]
    }
    
    static func bleedingSubCategory() -> [FertilityInput] {
        return [FertilityInput(name: "Heavy", isCategory: false, category: FertilityInput.Category.bleeding, isLength:false),
                FertilityInput(name: "Moderate", isCategory: false, category: FertilityInput.Category.bleeding, isLength:false),
                FertilityInput(name: "Light", isCategory: false, category: FertilityInput.Category.bleeding, isLength:false),
                FertilityInput(name: "Very Light", isCategory: false, category: FertilityInput.Category.bleeding, isLength:false),
                FertilityInput(name: "Brown", isCategory: false, category: FertilityInput.Category.bleeding, isLength:false)]
    }
    
    static func drySubCategory() -> [FertilityInput] {
        return [FertilityInput(name: "Damp", isCategory: false, category: FertilityInput.Category.dry, isLength:false),
                FertilityInput(name: "Shiny", isCategory: false, category: FertilityInput.Category.dry, isLength:false),
                FertilityInput(name: "Wet", isCategory: false, category: FertilityInput.Category.dry, isLength:false)]
    }
    
    static func mucusSubCategory() -> [FertilityInput] {
        return [FertilityInput(name: "1/4 Inch", isCategory: false, category: FertilityInput.Category.mucus, isLength: true),
                FertilityInput(name: "1/2 to 3/4 inch", isCategory: false, category: FertilityInput.Category.mucus, isLength: true),
                FertilityInput(name: "Greater than 1 inch", isCategory: false, category: FertilityInput.Category.mucus, isLength: true),
                FertilityInput(name: "Clear", isCategory: false, category: FertilityInput.Category.mucus, isLength:false),
                FertilityInput(name: "Cloudy/Clear", isCategory: false, category: FertilityInput.Category.mucus, isLength:false),
                FertilityInput(name: "Cloudy", isCategory: false, category: FertilityInput.Category.mucus, isLength:false),
                FertilityInput(name: "Yellow", isCategory: false, category: FertilityInput.Category.mucus, isLength:false),
                FertilityInput(name: "Brown", isCategory: false, category: FertilityInput.Category.mucus, isLength:false),
                FertilityInput(name: "Pasty", isCategory: false, category: FertilityInput.Category.mucus, isLength:false)]
    }
}
