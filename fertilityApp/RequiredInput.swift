//
//  FertilityInputTemp.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/15/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation


enum RequiredInput {
    case bleeding(BleedingInput)
    case dry(DryInput)
    case mucus(MucusColorInput, MucusLengthInput)
}

extension RequiredInput {
    enum BleedingInput:String {
        case heavy, moderate, light, veryLight = "very light", brown
    }
    
    enum DryInput:String {
        case damp, shiny, wet
    }
    
    enum MucusColorInput:String {
        case clear, cloudyClear = "cloudy/clear", cloudy, yellow, pasty
    }
    
    enum MucusLengthInput:String {
        case quarterInch = "1/4 Inch", halfToThreeQuarterInch = "1/2 to 3/4 inch", oneInch = "greater than 1 inch"
    }
}
