//
//  Day.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/26/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class Day: NSObject, NSCoding {
    
    //MARK: Class Methods
    
    //This function and the function below will be needed when we allow users to input data
    //from different dates.  For now they can't do that.
    class func saveDays(days:Array<Day>) {
        
        if days.count >= 2 {
            let firstDate = days[days.count-1].date
            let secondDate = days[days.count-2].date
            let daysBetweenDates = Day.determineDaysBetweenDates(firstDate,secondDate: secondDate)
            if daysBetweenDates > 0 {
                let filledInDays = Day.addDaysToArray(days, daysBetweenDates: daysBetweenDates)
                let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(filledInDays, toFile: Day.ArchiveURL.path!)
                if !isSuccessfulSave {
                    print("Failed to save days...")
                }
            } else {
                let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(days, toFile: Day.ArchiveURL.path!)
                
                if !isSuccessfulSave {
                    print("Failed to save days...")
                }
            }
        }
        
    }
    
    class func addDaysToArray(days:Array<Day>, daysBetweenDates:Int) -> Array<Day> {
        
        var daysToMutate = days
        //what dummy data do I want to put in
        //I want to build an array of length equal to daysBetweenDates

        
        var currentDay = days[days.count-2].date
        
        for index in 1...daysBetweenDates {
            let nextDay = NSCalendar.currentCalendar()
                .dateByAddingUnit(
                    .Day,
                    value: 1,
                    toDate: currentDay,
                    options: []
            )
            let day = Day(category1: "", category2: nil, selection1: "", selection2: nil, selection3: nil, mucusType:"", heart: false, lubrication: false, date: nextDay!, color:"yellow", fertile:false, peak: false)!
            
            daysToMutate.insert(day, atIndex: days.count-2)
            currentDay = nextDay!
        }
        
        
        
        return daysToMutate
    }
    
    class func determineDaysBetweenDates(firstDate:NSDate, secondDate:NSDate) -> Int {
        
        let calendar = NSCalendar.currentCalendar()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDayForDate(firstDate)
        let date2 = calendar.startOfDayForDate(secondDate)
        
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: date2, toDate: date1, options: [])
        
        return components.day-1  // This will return the number of day(s) between dates
    }
    
    class func loadDaysAsCycles() -> [[Day]] {
        var days = [Day]()
        var cycleArray = [Day]()
        var arrayOfCycles = [[Day]]()
        var previousDayNotRed = true
        
        if let daysWrapped = NSKeyedUnarchiver.unarchiveObjectWithFile(Day.ArchiveURL.path!) as? [Day] {
            days = daysWrapped
            
            for day in days {
                //if today is red but yesterday was not
                if day.color == "red" && previousDayNotRed {
                    if cycleArray.count > 0 {
                        arrayOfCycles.append(cycleArray)
                        cycleArray = [Day]()
                        cycleArray.append(day)
                        previousDayNotRed = false
                    }
                    //else not getting added
                } else {
                    cycleArray.append(day)
                    previousDayNotRed = true
                }
            }
            
        } else {
            arrayOfCycles = loadSampleDays()
        }
        
        
        
        
        return arrayOfCycles
    }
    
    class func loadSampleDays() -> [[Day]]{
        let date1 = NSDate(dateString:"09/26/2016")
        let day1 = Day(category1: "Bleeding", category2: nil, selection1: "heavy", selection2: nil, selection3: nil, mucusType:"", heart: false, lubrication: false, date: date1, color:"red", fertile:false, peak:false)!
        
        let date2 = NSDate(dateString:"09/25/2016")
        let day2 = Day(category1: "Bleeding", category2: nil, selection1: "heavy", selection2: nil, selection3: nil, mucusType:"non-peak", heart: false, lubrication: false, date: date2, color:"red", fertile:true, peak:false)!
        
        let date3 = NSDate(dateString:"09/25/2016")
        let day3 = Day(category1: "Bleeding", category2: nil, selection1: "heavy", selection2: nil, selection3: nil, mucusType:"peak", heart: false, lubrication: false, date: date3, color:"white", fertile:true, peak: true)!
        
        var days = [[Day]]()
        
        days.append([day1, day2, day3])
        
        return days
        
    }
    
    // MARK: Properties
    var category1:String
    var category2:String?
    var selection1:String
    var selection2:String?
    var selection3:String?
    var mucusType:String?
    var heart:Bool
    var lubrication:Bool
    var date:NSDate
    var color:String
    var fertile:Bool
    var peak:Bool
    
    struct PropertyKey {
        static let category1Key = "category1"
        static let category2Key = "category2"
        static let selection1Key = "selection1"
        static let selection2Key = "selection2"
        static let selection3Key = "selection3"
        static let mucusTypeKey = "mucusType"
        static let heartKey = "heart"
        static let lubricationKey = "lubrication"
        static let dateKey = "date"
        static let colorKey = "color"
        static let fertileKey = "fertile"
        static let peakKey = "peak"
    }
    
    init?(category1: String, category2: String?, selection1: String, selection2: String?, selection3:String?, mucusType:String?, heart:Bool, lubrication:Bool, date:NSDate, color:String, fertile:Bool, peak:Bool) {
        
        self.category1 = category1
        self.category2 = category2
        self.selection1 = selection1
        self.selection2 = selection2
        self.selection3 = selection3
        self.mucusType = mucusType
        self.heart = heart
        self.lubrication = lubrication
        self.date = date
        self.color = color
        self.fertile = fertile
        self.peak = peak
        
        
        
        
        super.init()
        
        //create methods that populate calendarOutput properties like
        //color, isFertile, etc.
        
//        if category1.isEmpty || selection1.isEmpty {
//            return nil
//        }
        
        
    }
    
    func returnUIColor() -> UIColor {
        var color = UIColor()
        
        switch self.color {
            case "red":
                color = UIColor.redColor()
            case "green":
                color = UIColor.greenColor()
            case "yellow":
                color = UIColor.yellowColor()
            default:
                color = UIColor.whiteColor()
        }
        
        return color
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(category1, forKey: PropertyKey.category1Key)
        aCoder.encodeObject(category2, forKey: PropertyKey.category2Key)
        aCoder.encodeObject(selection1, forKey: PropertyKey.selection1Key)
        aCoder.encodeObject(selection2, forKey: PropertyKey.selection2Key)
        aCoder.encodeObject(selection3, forKey: PropertyKey.selection3Key)
        aCoder.encodeObject(mucusType, forKey: PropertyKey.mucusTypeKey)
        aCoder.encodeBool(heart, forKey: PropertyKey.heartKey)
        aCoder.encodeBool(lubrication, forKey: PropertyKey.lubricationKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(color, forKey: PropertyKey.colorKey)
        aCoder.encodeBool(fertile, forKey: PropertyKey.fertileKey)
        aCoder.encodeBool(peak, forKey: PropertyKey.peakKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let category1 = aDecoder.decodeObjectForKey(PropertyKey.category1Key) as! String
        let category2 = aDecoder.decodeObjectForKey(PropertyKey.category2Key) as? String
        let selection1 = aDecoder.decodeObjectForKey(PropertyKey.selection1Key) as! String
        let selection2 = aDecoder.decodeObjectForKey(PropertyKey.category1Key) as? String
        let selection3 = aDecoder.decodeObjectForKey(PropertyKey.category1Key) as? String
        let mucusType = aDecoder.decodeObjectForKey(PropertyKey.mucusTypeKey) as! String
        let heart = aDecoder.decodeBoolForKey(PropertyKey.heartKey)
        let lubrication = aDecoder.decodeBoolForKey(PropertyKey.lubricationKey)
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        let color = aDecoder.decodeObjectForKey(PropertyKey.colorKey) as! String
        let fertile = aDecoder.decodeBoolForKey(PropertyKey.fertileKey)
        let peak = aDecoder.decodeBoolForKey(PropertyKey.peakKey)
        
        self.init(category1:category1, category2: category2, selection1: selection1, selection2: selection2, selection3: selection3, mucusType: mucusType, heart:heart, lubrication: lubrication, date:date, color:color, fertile:fertile, peak:peak)
        
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("days")

    // MARK: Utility methods
    
}
