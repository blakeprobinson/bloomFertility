//
//  FertilitySignViewController.swift
//  fertilityApp
//
//  Created by Blake Robinson on 10/7/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class FertilitySignViewController: UIViewController {
    //Dry
    @IBOutlet weak var Damp: UIButton!
    @IBOutlet weak var Shiny: UIButton!
    @IBOutlet weak var Wet: UIButton!
    //Bleeding
    @IBOutlet weak var VeryLight: UIButton!
    @IBOutlet weak var Light: UIButton!
    @IBOutlet weak var Moderate: UIButton!
    @IBOutlet weak var Heavy: UIButton!
    @IBOutlet weak var Brown: UIButton!
    //Mucus
    @IBOutlet weak var QuarterInch: UIButton!
    @IBOutlet weak var HalfToThreeQuarters: UIButton!
    @IBOutlet weak var GreaterThanAnInch: UIButton!
    
    @IBOutlet weak var Clear: UIButton!
    @IBOutlet weak var CloudyClear: UIButton!
    @IBOutlet weak var Cloudy: UIButton!
    
    @IBOutlet weak var Yellow: UIButton!
    
    @IBOutlet weak var BrownMucus: UIButton!
    @IBOutlet weak var Pasty: UIButton!
    
    //Other
    @IBOutlet weak var Lubrication: UIButton!
    
    @IBOutlet weak var Intercourse: UIButton!
    
    //Date Labels
    @IBOutlet weak var LeftDate: UILabel!
    
    @IBOutlet weak var MiddleDate: UILabel!
    
    @IBOutlet weak var RightDate: UILabel!
    
    var pageIndex:Int!
    var leftDateText:String!
    var middleDateString:String!
    var rightDateString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LeftDate.text = self.leftDateText
        self.MiddleDate.text = self.middleDateString
        self.RightDate.text = self.rightDateString
    }
    
}
