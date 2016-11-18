//
//  MenuData.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/3/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

struct MenuData {
    //categories are sorted to make sure switch statement functions correctly in 
    //add subinputs to fertility array
    var fertilityInputs = MenuData.categoryData()
    var categoryIndecesInFertilityInputs = [0,1,2]
    var lubricationSelected = false
    var heartTouched = false
    private var dryInputs = MenuData.drySubCategory()
    private var bleedingInputs = MenuData.bleedingSubCategory()
    private var mucusInputs = MenuData.mucusSubCategory()
    
    mutating func selected(index indexPath:IndexPath) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let selected = fertilityInputs[indexPath.row]
        let index = indexPath.row
        switch selected.name {
            case "dry":
                indexPaths = addSubInputsToFertilityArray(dryInputs, index:index)
            case "mucus":
                indexPaths = addSubInputsToFertilityArray(mucusInputs, index:index)
            case "lubrication":
                print("Lubrication Selected")
            case "bleeding":
                indexPaths = addSubInputsToFertilityArray(bleedingInputs, index:index)
            default:
                print("arrived at meaningless default")
        }
        return indexPaths
    }
    
    mutating func removeSubInputsFromFertilityArray(indexPath: IndexPath) -> [IndexPath]? {
        
        let unselected = fertilityInputs[indexPath.row]
        if unselected.isCategory && unselected.name != "lubrication"{
            return removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths(unselected.name)
        } else {
            return nil
        }
    }
    
    mutating func removeAnySubInputsFromFertilityArray() {
        fertilityInputs = MenuData.categoryData()
    }
    
    mutating func changeInputSelection(indexPath: IndexPath, select: Bool) {
        for (index, var input) in fertilityInputs.enumerated() {
            if index == indexPath.row {
                input.selected = select
            }
        }
    }
    
    mutating func selectedElements() -> [InputViewModel] {
        var selectedArray = [InputViewModel]()
        for (_, element) in fertilityInputs.enumerated() {
            if element.selected && !element.isCategory {
                selectedArray.append(element)
            }
            //Since lubrication is a category with no items in it we need this
            //conditional
            if element.name == "lubrication" {
                lubricationSelected = true
            }
        }
        return selectedArray
    }
    
    func validateInputs(_ selectedArray:[InputViewModel]) -> String {
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
                    if selectedArray[0].name == "light" || selectedArray[0].name == "very light" || selectedArray[0].name == "brown" {
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
            if firstFertilityInput.name == "light" || firstFertilityInput.name == "very light" || firstFertilityInput.name == "brown" {
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
    
    mutating func addSubInputsToFertilityArray(_ subArray: [InputViewModel], index: Int) -> [IndexPath] {

        return addInputsAfterIndex(subArray: subArray, index: index)
    }
    
    mutating func addInputsAfterIndex(subArray: [InputViewModel], index:Int) -> [IndexPath] {
        var mutableIndex = index + 1
        var indexPaths = [IndexPath]()
        for subArrayElement in subArray {
            fertilityInputs.insert(subArrayElement, at: mutableIndex)
            let indexPath = IndexPath(row: mutableIndex, section: 0)
            indexPaths.append(indexPath)
            mutableIndex += 1
        }
 
        return indexPaths
    }
    
    mutating func updateCategoryIndecesInFertilityInputs(categoryIndex: Int, countOfSubArr: Int) {
        let index = categoryIndex - 1
        
    }
    
//    func firstInputOfType(input: FertilityInput?) -> Int {
//        //fertility
//        if let requiredInput = input?.requiredInput {
//            for input in fertilityInputs {
//                switch requiredInput {
//                case .bleeding:
//                    
//                case .dry:
//                    break
//                case .mucus:
//                    break
//                }
//            }
//            return
//        }
//        
//    }
    
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
    
    static func convertToViewModel(fromFertilityInput fertilityInput: FertilityInput) -> InputViewModel {
        return InputViewModel(input: fertilityInput)
    }
    
    static func convertToViewModelArr(fromFertilityInputArr array:[FertilityInput]) -> [InputViewModel] {
        var inputVMArray = [InputViewModel]()
        for input in array {
            inputVMArray.append(convertToViewModel(fromFertilityInput: input))
        }
        return inputVMArray
    }
    
    static func categoryData() -> [InputViewModel] {
        let array = [FertilityInput(name: FertilityInput.Name.dry, isCategory: true, category: FertilityInput.Category.none, isLength:false, requiredInput:nil),
                FertilityInput(name: FertilityInput.Name.bleeding, isCategory: true, category: FertilityInput.Category.none, isLength:false, requiredInput:nil),
                FertilityInput(name: FertilityInput.Name.mucus, isCategory: true, category: FertilityInput.Category.none, isLength:false, requiredInput:nil),
                FertilityInput(name: FertilityInput.Name.lubrication, isCategory: true, category: FertilityInput.Category.none, isLength:false, requiredInput:nil)]
        return convertToViewModelArr(fromFertilityInputArr: array)
    }
    
    static func bleedingSubCategory() -> [InputViewModel] {
        let bleedingArray = [RequiredInput.bleeding(RequiredInput.BleedingInput.heavy),
                RequiredInput.bleeding(RequiredInput.BleedingInput.moderate),
                RequiredInput.bleeding(RequiredInput.BleedingInput.light),
                RequiredInput.bleeding(RequiredInput.BleedingInput.veryLight),
                RequiredInput.bleeding(RequiredInput.BleedingInput.brown)]
        
        let array =  [FertilityInput(requiredInput: bleedingArray[0]),
                FertilityInput(requiredInput: bleedingArray[1]),
                FertilityInput(requiredInput: bleedingArray[2]),
                FertilityInput(requiredInput: bleedingArray[3]),
                FertilityInput(requiredInput: bleedingArray[4])]
        
        return convertToViewModelArr(fromFertilityInputArr: array)
        
    }
    
    static func drySubCategory() -> [InputViewModel] {
        let dryArray = [RequiredInput.dry(RequiredInput.DryInput.damp),
                RequiredInput.dry(RequiredInput.DryInput.shiny),
                RequiredInput.dry(RequiredInput.DryInput.wet)]
        
        let array =  [FertilityInput(requiredInput:dryArray[0]),
                FertilityInput(requiredInput:dryArray[1]),
                FertilityInput(requiredInput:dryArray[2])]
        
        return convertToViewModelArr(fromFertilityInputArr: array)
    }
    
    static func mucusSubCategory() -> [InputViewModel] {
        let mucusArray = [RequiredInput.mucus(RequiredInput.MucusInput.length(RequiredInput.MucusLengthInput.quarterInch), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.length(RequiredInput.MucusLengthInput.halfToThreeQuarterInch), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.length(RequiredInput.MucusLengthInput.oneInch), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.clear), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.cloudyClear), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.cloudy), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.yellow), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.pasty), nil),
                RequiredInput.mucus(RequiredInput.MucusInput.color(RequiredInput.MucusColorInput.brown), nil)]
        
            
        let array =  [FertilityInput(requiredInput:mucusArray[0]),
                FertilityInput(requiredInput:mucusArray[1]),
                FertilityInput(requiredInput:mucusArray[2]),
                FertilityInput(requiredInput:mucusArray[3]),
                FertilityInput(requiredInput:mucusArray[4]),
                FertilityInput(requiredInput:mucusArray[5]),
                FertilityInput(requiredInput:mucusArray[6]),
                FertilityInput(requiredInput:mucusArray[7]),
                FertilityInput(requiredInput:mucusArray[8])]
        
        return convertToViewModelArr(fromFertilityInputArr: array)

    }
}
