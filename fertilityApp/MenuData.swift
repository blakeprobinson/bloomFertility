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
    
    mutating func removeSubInputsFromFertilityArrayReturnIndexPaths(_ FertilityInput: FertilityInput) -> [IndexPath]? {
        if FertilityInput.isCategory == true {
            switch FertilityInput.name {
                
            case "Dry":
                return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths("Dry")
            case "Mucus":
                return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths("Mucus")
            case "Lubrication":
                return nil
            default:
                return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths("Bleeding")
            }
        }
        return nil
    }
    
    func validateInputs(_ selectedArray:[FertilityInput]) -> String {
        var selectedArray = selectedArray
        var validationText = ""
        let arrayCount =  selectedArray.count
        selectedArray.sort { $0.category < $1.category }
        var categoryZero = String()
        var categoryOne = String()
        if arrayCount > 0 {
            categoryZero = selectedArray[0].category
        }
        if arrayCount > 1 {
            categoryOne = selectedArray[1].category
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
                if secondFertilityInput.isLength && !thirdFertilityInput.isLength && thirdFertilityInput.category == "Mucus" {
                    
                    
                } else if !secondFertilityInput.isLength && secondFertilityInput.category == "Mucus" && thirdFertilityInput.isLength {
                    
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
    
    mutating func removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths(_ category: String) ->  [IndexPath]{
        var indexPathArray = [IndexPath]()
        for (index, element) in fertilityInputs.enumerated().reversed() {
            if element.category == category {
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
