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
        switch fertilityInput.name {
            case .dry:
                indexPaths = addSubInputsToFertilityArray(dryInputs)
            case .mucus:
                indexPaths = addSubInputsToFertilityArray(mucusInputs)
            case .lubrication:
                print("Lubrication Selected")
            case .bleeding:
                indexPaths = addSubInputsToFertilityArray(bleedingInputs)
            default:
                print("arrived at meaningless default")
        }
        return indexPaths
    }
    
    mutating func removeSubInputsFromFertilityArrayReturnIndexPaths(_ FertilityInput: FertilityInput) -> [IndexPath]? {
        
        switch FertilityInput.name {
            
        case .dry:
            return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths(FertilityInput.name.rawValue)
        case .mucus:
        return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths(FertilityInput.name.rawValue)
        case .lubrication:
            return nil
        case .bleeding:
            return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths(FertilityInput.name.rawValue)
        default: break
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
            if element.name.rawValue == "lubrication" {
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
                    if selectedArray[0].name.rawValue == "light" || selectedArray[0].name.rawValue == "very light" || selectedArray[0].name.rawValue == "brown" {
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
            if firstFertilityInput.name.rawValue == "light" || firstFertilityInput.name.rawValue == "very light" || firstFertilityInput.name.rawValue == "brown" {
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
            if element.name.rawValue == subArray[0].category.rawValue {
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
        return [FertilityInput(name: FertilityInput.Name.dry, isCategory: true, category: FertilityInput.Category.none, isLength:false, requiredInput:nil),
                FertilityInput(name: FertilityInput.Name.bleeding, isCategory: true, category: FertilityInput.Category.none, isLength:false, requiredInput:nil),
                FertilityInput(name: FertilityInput.Name.mucus, isCategory: true, category: FertilityInput.Category.none, isLength:false, requiredInput:nil),
                FertilityInput(name: FertilityInput.Name.lubrication, isCategory: true, category: FertilityInput.Category.none, isLength:false, requiredInput:nil)]
    }
    
    static func bleedingSubCategory() -> [FertilityInput] {
        let bleedingArray = [RequiredInput.bleeding(RequiredInput.BleedingInput.heavy),
                RequiredInput.bleeding(RequiredInput.BleedingInput.moderate),
                RequiredInput.bleeding(RequiredInput.BleedingInput.light),
                RequiredInput.bleeding(RequiredInput.BleedingInput.veryLight),
                RequiredInput.bleeding(RequiredInput.BleedingInput.brown)]
        
        return [FertilityInput(name: FertilityInput.Name.heavy, isCategory: false, category: FertilityInput.Category.bleeding, isLength:false, requiredInput: bleedingArray[0]),
                FertilityInput(name: FertilityInput.Name.moderate, isCategory: false, category: FertilityInput.Category.bleeding, isLength:false, requiredInput: bleedingArray[1]),
                FertilityInput(name: FertilityInput.Name.light, isCategory: false, category: FertilityInput.Category.bleeding, isLength:false, requiredInput: bleedingArray[2]),
                FertilityInput(name: FertilityInput.Name.veryLight, isCategory: false, category: FertilityInput.Category.bleeding, isLength:false, requiredInput: bleedingArray[3]),
                FertilityInput(name: FertilityInput.Name.brown, isCategory: false, category: FertilityInput.Category.bleeding, isLength:false, requiredInput: bleedingArray[4])]
        
    }
    
    static func drySubCategory() -> [FertilityInput] {
        let dryArray = [RequiredInput.dry(RequiredInput.DryInput.damp),
                RequiredInput.dry(RequiredInput.DryInput.shiny),
                RequiredInput.dry(RequiredInput.DryInput.wet)]
        
        return [FertilityInput(name: FertilityInput.Name.damp, isCategory: false, category: FertilityInput.Category.dry, isLength:false, requiredInput:dryArray[0]),
                FertilityInput(name: FertilityInput.Name.shiny, isCategory: false, category: FertilityInput.Category.dry, isLength:false, requiredInput:dryArray[1]),
                FertilityInput(name: FertilityInput.Name.wet, isCategory: false, category: FertilityInput.Category.dry, isLength:false, requiredInput:dryArray[2])]
    }
    
    static func mucusSubCategory() -> [FertilityInput] {
        let mucusArray = [RequiredInput.mucus(RequiredInput.MucusInput.length(RequiredInput.MucusLengthInput.quarterInch), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.length(RequiredInput.MucusLengthInput.halfToThreeQuarterInch), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.length(RequiredInput.MucusLengthInput.oneInch), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.clear), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.cloudyClear), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.cloudy), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.yellow), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.pasty), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.brown), nil)]
        
            
        return [FertilityInput(name: FertilityInput.Name.quarterInch, isCategory: false, category: FertilityInput.Category.mucus, isLength: true, requiredInput:mucusArray[0]),
                FertilityInput(name: FertilityInput.Name.halfToThreeQuarterInch, isCategory: false, category: FertilityInput.Category.mucus, isLength: true, requiredInput:mucusArray[1]),
                FertilityInput(name: FertilityInput.Name.oneInch, isCategory: false, category: FertilityInput.Category.mucus, isLength: true, requiredInput:mucusArray[2]),
                FertilityInput(name: FertilityInput.Name.clear, isCategory: false, category: FertilityInput.Category.mucus, isLength:false, requiredInput:mucusArray[3]),
                FertilityInput(name: FertilityInput.Name.cloudyClear, isCategory: false, category: FertilityInput.Category.mucus, isLength:false, requiredInput:mucusArray[4]),
                FertilityInput(name:FertilityInput.Name.cloudy, isCategory: false, category: FertilityInput.Category.mucus, isLength:false, requiredInput:mucusArray[5]),
                FertilityInput(name: FertilityInput.Name.yellow, isCategory: false, category: FertilityInput.Category.mucus, isLength:false, requiredInput:mucusArray[6]),
                FertilityInput(name: FertilityInput.Name.brown, isCategory: false, category: FertilityInput.Category.mucus, isLength:false, requiredInput:mucusArray[7]),
                FertilityInput(name: FertilityInput.Name.pasty, isCategory: false, category: FertilityInput.Category.mucus, isLength:false, requiredInput:mucusArray[8])]

    }
}
