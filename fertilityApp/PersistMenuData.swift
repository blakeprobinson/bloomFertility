//
//  PersistMenuData.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/4/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

struct PersistMenuData {
    
    var days = PersistMenuData.fetchDays()

    func selectedArrayToUserInput(_ selectedArray:[FertilityInput]) -> Dictionary<String, String> {
        
        var userInput: [String:String] = Dictionary()
        
        switch selectedArray.count {
        case 1:
            userInput = [
                "category1": selectedArray[0].category.rawValue,
                "selection1":selectedArray[0].name.rawValue,
                "category2": "",
                "selection2": "",
                "selection3": ""
            ]
        case 2:
            if selectedArray[0].category != selectedArray[1].category {
                userInput = [
                    "category1": selectedArray[0].category.rawValue,
                    "selection1":selectedArray[0].name.rawValue,
                    "category2": selectedArray[1].category.rawValue,
                    "selection2":selectedArray[1].name.rawValue,
                    "selection3": ""
                ]
            } else {
                userInput = [
                    "category1": selectedArray[0].category.rawValue,
                    "category2": "",
                    "selection1":selectedArray[0].name.rawValue,
                    "selection2":selectedArray[1].name.rawValue,
                    "selection3": ""
                ]
            }
        default:
            if selectedArray[0].category != selectedArray[1].category {
                userInput = [
                    "category1": selectedArray[0].category.rawValue,
                    "selection1":selectedArray[0].name.rawValue,
                    "category2": selectedArray[1].category.rawValue,
                    "selection2":selectedArray[1].name.rawValue,
                    "selection3":selectedArray[2].name.rawValue
                ]
            } else {
                userInput = [
                    "category1": selectedArray[0].category.rawValue,
                    "category2": selectedArray[2].category.rawValue,
                    "selection1":selectedArray[0].name.rawValue,
                    "selection2":selectedArray[1].name.rawValue,
                    "selection3":selectedArray[2].name.rawValue
                ]
            }
            
        }
        return userInput
    }
    
    mutating func addNewUserInput(_ selectedArray: [FertilityInput], menuData:MenuData, date:Date) {
        
        let currentUserInput:Dictionary = selectedArrayToUserInput(selectedArray)
        
        let fertile:Bool = isFertile(currentUserInput, menuData:menuData)
        let mucusType:String = findMucusType(currentUserInput, menuData: menuData)
        let peak:Bool = false
        //check to see if previous day is peak
        //if so, change bool to peak.
        
        markPreviousDayAsPeakIfNecessary(mucusType, date:date)
        //When can you know that peak type mucus is over?  the next day?
        //two days later?
        let color:String = determineColor(currentUserInput)
        
        
        //All categories and selections can be force unwrapped since they are set
        //with values in selectedArrayToUserInput function
        let currentDay = Day(category1:currentUserInput["category1"]!,
                             category2: currentUserInput["category2"]!,
                             selection1: currentUserInput["selection1"]!,
                             selection2: currentUserInput["selection2"]!,
                             selection3: currentUserInput["selection3"]!,
                             mucusType:mucusType,
                             heart: menuData.heartTouched,
                             lubrication: menuData.lubricationSelected,
                             date: date,
                             color: color,
                             fertile:fertile,
                             peak:peak)
        
        if let currentDay = currentDay {
            days.append(currentDay)
        }
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
    
    func isFertile(_ currentUserInput:Dictionary<String, String>, menuData:MenuData) -> Bool {
        var isFertile:Bool = false
        
        if menuData.lubricationSelected {
            isFertile = true
        } else if currentUserInput["category1"] == "Mucus" || currentUserInput["category2"] == "Mucus" {
            isFertile = true
        } else if isFertileBasedOnPastMucus() {
            isFertile = true
        }
        
        //else if three days in a row of nonpeak mucus exist three days or less ago, then this day is fertile
        
        //else if peak mucus exists three days or less ago
        
        return isFertile
    }

    func isFertileBasedOnPastMucus() -> Bool {
        var isFertile:Bool = false
        
        if isFertilePastPeakMucus() {
            isFertile = true
        }
        else if isFertilePastNonPeakMucus() {
            isFertile = true
        }
        
        return isFertile
    }
    
    func isFertilePastPeakMucus() -> Bool {
        //for peak mucus check
        //look at the last three days in the list
        //if any of the days
        
        var isFertile:Bool = false
        
        let daysCount = days.count
        
        if daysCount > 0 {
            //just iterate through last three elements
            let lastIteration = daysCount > 2 ? daysCount - 3 : 0
            
            for i in (lastIteration ..< daysCount).reversed() {
                if days[i].mucusType == "peak" {
                    isFertile = true
                    break
                }
            }
        }
        
        return isFertile
    }
    
    func isFertilePastNonPeakMucus() -> Bool {
        
        //for non-peak mucus check
        //look at the last five days to see if a consecutive
        //string of three non-peak mucus days exists.
        
        var isFertile:Bool = false
        
        let daysCount = days.count
        
        if daysCount > 0 {
            //just iterate through last five elements
            let lastIteration = daysCount > 4 ? daysCount - 5 : 0
            // user iterator to track fertile stuff
            var firstNonPeakMucus:Bool = false
            var secondNonPeakMucus:Bool = false
            
            for i in (lastIteration ..< daysCount).reversed() {
                
                if days[i].mucusType == "non-peak" {
                    if firstNonPeakMucus {
                        if secondNonPeakMucus {
                            isFertile = true
                            break
                        } else {
                            secondNonPeakMucus = true
                        }
                    } else {
                        firstNonPeakMucus = true
                    }
                } else {
                    firstNonPeakMucus = false
                    secondNonPeakMucus = false
                }
            }
            
        }
        
        return isFertile
    }
    
    func markPreviousDayAsPeakIfNecessary(_ mucusType:String, date:Date) {
        if mucusType == "" || mucusType == "non-peak" {
            //check last day for peak mucus
            let daysCount = days.count
            for i in (0 ..< daysCount).reversed() {
                //If current date is after date in days array,
                // stop loop and return date iterating
                if date.compare(days[i].date as Date) == ComparisonResult.orderedAscending {
                    if days[i].mucusType == "peak" {
                        days[i].peak = true;
                        break
                    }
                }
                
            }
            
        }
    }
    
    func determineColor(_ currentUserInput:Dictionary <String,String>) -> String {
        var color:String = "green"
        
        if currentUserInput["category1"] == "Bleeding" || currentUserInput["category2"] == "Bleeding" {
            color = "red"
            return color
        } else if currentUserInput["category1"] == "Mucus" || currentUserInput["category2"] == "Mucus" {
            color = "white"
            return color
        }
        return color
        
    }
    
    func saveDays() {
        Day.saveDays(days)
    }
    
}

extension PersistMenuData {
    static func fetchDays() -> [Day] {
        if let days = NSKeyedUnarchiver.unarchiveObject(withFile: Day.ArchiveURL.path) as? [Day] {
            return days
        } else {
            return [Day]()
        }
    }
}
