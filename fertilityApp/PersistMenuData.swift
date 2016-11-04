//
//  PersistMenuData.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/4/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

struct PersistMenuData {

    func selectedArrayToUserInput(_ selectedArray:[FertilityInput]) -> Dictionary<String, String> {
        
        var userInput: [String:String] = Dictionary()
        
        switch selectedArray.count {
        case 1:
            userInput = [
                "category1": selectedArray[0].category,
                "selection1":selectedArray[0].name,
                "category2": "",
                "selection2": "",
                "selection3": ""
            ]
        case 2:
            if selectedArray[0].category != selectedArray[1].category {
                userInput = [
                    "category1": selectedArray[0].category,
                    "selection1":selectedArray[0].name,
                    "category2": selectedArray[1].category,
                    "selection2":selectedArray[1].name,
                    "selection3": ""
                ]
            } else {
                userInput = [
                    "category1": selectedArray[0].category,
                    "category2": "",
                    "selection1":selectedArray[0].name,
                    "selection2":selectedArray[1].name,
                    "selection3": ""
                ]
            }
        default:
            if selectedArray[0].category != selectedArray[1].category {
                userInput = [
                    "category1": selectedArray[0].category,
                    "selection1":selectedArray[0].name,
                    "category2": selectedArray[1].category,
                    "selection2":selectedArray[1].name,
                    "selection3":selectedArray[2].name
                ]
            } else {
                userInput = [
                    "category1": selectedArray[0].category,
                    "category2": selectedArray[2].category,
                    "selection1":selectedArray[0].name,
                    "selection2":selectedArray[1].name,
                    "selection3":selectedArray[2].name
                ]
            }
            
        }
        return userInput
    }
    
    func findMucusType(_ currentUserInput:Dictionary<String, String>, menuData:MenuData) ->String {
        var mucusType:String = ""
        
        if menuData.lubricationSelected {
            mucusType = "peak"
            
        } else if currentUserInput["selection1"] == "Greater than 1 inch" || currentUserInput["selection1"] == "Clear" || currentUserInput["selection1"] == "Cloudy/Clear" {
            mucusType = "peak"
            
        } else if currentUserInput["selection2"] == "Greater than 1 inch" || currentUserInput["selection2"] == "Clear" || currentUserInput["selection2"] == "Cloudy/Clear" {
            mucusType = "peak"
            
        } else if currentUserInput["selection3"] == "Greater than 1 inch" || currentUserInput["selection3"] == "Clear" || currentUserInput["selection3"] == "Cloudy/Clear" {
            mucusType = "peak"
        }  else if currentUserInput["selection1"] == "1/4 Inch" || currentUserInput["selection1"] == "1/2 to 3/4 inch" {
            mucusType = "non-peak"
        }  else if currentUserInput["selection2"] == "1/4 Inch" || currentUserInput["selection2"] == "1/2 to 3/4 inch" {
            mucusType = "non-peak"
        } else if currentUserInput["selection3"] == "1/4 Inch" || currentUserInput["selection3"] == "1/2 to 3/4 inch" {
            mucusType = "non-peak"
        }
        return mucusType
    }

}
