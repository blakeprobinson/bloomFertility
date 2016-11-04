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

}
