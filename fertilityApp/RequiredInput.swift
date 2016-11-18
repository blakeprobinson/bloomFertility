//
//  FertilityInputTemp.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/15/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

//mucus has one or two associated values because
//when a user selects mucus both a MucusInput.length
//and a MucusInput.color are required.  When, however,
//RequiredInputs are used to set up MenuData, only
//one MucusInput can be associated with a RequiredInput

enum RequiredInput {
    case bleeding(BleedingInput)
    case dry(DryInput)
    case mucus(MucusInput, MucusInput?)
}

//Enums for RequiredInput associated values
extension RequiredInput {
    enum BleedingInput:String {
        case heavy, moderate, light, veryLight = "very light", brown
    }
    
    enum DryInput:String {
        case damp, shiny, wet
    }
    
    enum MucusInput {
        case color(MucusColorInput)
        case length(MucusLengthInput)
    }
}

//Enums for MucusInput associated values
extension RequiredInput {
    enum MucusColorInput:String {
        case clear, cloudyClear = "cloudy/clear", cloudy, yellow, pasty, brown
    }
    
    enum MucusLengthInput:String {
        case quarterInch = "1/4 Inch", halfToThreeQuarterInch = "1/2 to 3/4 inch", oneInch = "greater than 1 inch"
    }
}

//Enum method
//extension RequiredInput {
//    func 
//}
