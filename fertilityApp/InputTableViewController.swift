//
//  InputTableViewController.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/11/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class InputTableViewController: UITableViewController, TableViewCellDelegate {
    @IBOutlet var inputTableView: UITableView!
    var menuData = MenuData()
    
    var validationLabel = UILabel()
    var heartTouched = false
    var lubricationSelected = false
    var date = Date()
    var days = [Day]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedDays = loadDays() {
            days += savedDays
        }
        
        inputTableView.separatorStyle = .none
        inputTableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        inputTableView.backgroundColor = UIColor.white
        
        //set up header view
        let screenSize: CGRect = UIScreen.main.bounds
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 180))
        
        let button = UIButton(frame: CGRect(x: screenSize.width*(0.1), y: 40, width: screenSize.width*(0.6), height: 60))
        
        button.backgroundColor = UIColor(red: 109.0/255, green: 228/250.0, blue: 209/255.0, alpha: 1.0)
        button.setTitle("Save", for: UIControlState())
        button.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        
        let image = UIImage(named: "heart emoji") as UIImage?
        let heartButton   = UIButton(type: UIButtonType.custom) as UIButton
        heartButton.frame = CGRect(x: screenSize.width*(0.75), y: 50, width: screenSize.width*(0.15), height: 50)
        heartButton.setImage(image, for: UIControlState())
        heartButton.addTarget(self, action: #selector(InputTableViewController.heartButtonAction(_:)), for:.touchUpInside)
        
        validationLabel = UILabel(frame: CGRect(x: screenSize.width*(0.1), y: 110, width: screenSize.width*(0.8), height: 60))
        validationLabel.text = ""
        validationLabel.numberOfLines = 0
        validationLabel.textAlignment = NSTextAlignment.center
        validationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//        validationLabel.font = UIFont(descriptor: JennaSue, size: 17);
        
        headerView.addSubview(button)
        headerView.addSubview(validationLabel)
        headerView.addSubview(heartButton)
        inputTableView.tableHeaderView = headerView
        //To make the table view not underlap the battery bar and the tab bar
        inputTableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0)
        
        //set up footerview for tableview
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 250))
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 200)
        datePicker.timeZone = TimeZone.autoupdatingCurrent
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(InputTableViewController.datePickerValueChanged(_:)), for: .valueChanged)
        footerView.addSubview(datePicker)
        
        inputTableView.tableFooterView = footerView
        
    }
    
    // MARK: TableView and related
    
    func heartButtonAction(_ sender: UIButton!) {
        heartTouched = !heartTouched
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        date = sender.date
    }
    
    func saveButtonAction(_ sender: UIButton!) {
        validationLabel.text = ""
        var selectedArray = [FertilityInput]()
        for (_, element) in menuData.fertilityInputs.enumerated() {
            if element.selected && !element.isCategory {
                selectedArray.append(element)
            }
            //Since lubrication is a category with no items in it we need this
            //conditional
            if element.name == "Lubrication" {
                lubricationSelected = true
            }
        }
        //Validate inputs, which also sorts them
        validationLabel.text = menuData.validateInputs(selectedArray)
        
        //If no validation label is generated, then inputs are valid.
        if validationLabel.text == "" {
            addNewUserInput(selectedArray)
            saveDays()
            for (_, element) in menuData.fertilityInputs.enumerated() {
            
                element.selected = false;
            }
            self.inputTableView.reloadData()
            
            
            let cycleViewController = tabBarController?.viewControllers![1]	
            cycleViewController?.viewWillAppear(true)
            tabBarController?.selectedIndex = 1
        }
        
        
    }

    func fertilityInputCategoryDeselected(_ FertilityInput:FertilityInput) {
        let index = (menuData.fertilityInputs as NSArray).index(of: FertilityInput)
        if index == NSNotFound { return }
        
        // use the UITableView to animate the removal of this row
        inputTableView.beginUpdates()
        
        //if indexPaths has a value then remove those indexPaths from the tableView
        if let indexPaths = removeSubInputsFromFertilityArrayReturnIndexPaths(FertilityInput) {
            inputTableView.deleteRows(at: indexPaths, with: .fade)
        }
        inputTableView.endUpdates()
    }
    
    func removeSubInputsFromFertilityArrayReturnIndexPaths(_ FertilityInput: FertilityInput) -> [IndexPath]? {
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
    
    func removeInputsOfCategoryAndReturnRemovedIndecesAsIndexPaths(_ category: String) ->  [IndexPath]{
        var indexPathArray = [IndexPath]()
        for (index, element) in menuData.fertilityInputs.enumerated().reversed() {
            if element.category == category {
                menuData.fertilityInputs.remove(at: index)
                let indexPath = IndexPath(row: index, section: 0)
                indexPathArray.append(indexPath)
            }
        }
        return indexPathArray
    }
    
    func fertilityInputSelected(_ fertilityInput: FertilityInput) {
        menuData.selected(input: fertilityInput)
        inputTableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuData.fertilityInputs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let initialCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let cell = initialCell as? TableViewCell else {
            return initialCell
        }
        
        //cell.textLabel?.backgroundColor = UIColor.clearColor()
        
        let fertilityInput = menuData.fertilityInputs[indexPath.row]
        //cell.textLabel?.text = fertilityInput.name
        cell.selectionStyle = .none
        cell.delegate = self
        cell.FertilityInput = fertilityInput
        cell.backgroundColor = colorForCell(fertilityInput)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if menuData.fertilityInputs[indexPath.row].isCategory {
            return 75.0
        } else {
            return 50.0
        }
    }
    
    func colorForCell(_ input: FertilityInput) -> UIColor {
        var color:UIColor
        switch input.category {
            case "none":
                switch input.name {
                    case "Dry":
                        color = UIColor(red: 93.0/255, green: 188.0/255, blue: 210.0/255, alpha: 1.0)
                    case "Bleeding":
                        color = UIColor(red: 255.0/255, green: 192.0/255, blue: 203.0/255, alpha: 1.0)
                    case "Lubrication":
                        //rgb(255,255,102)
                        color = UIColor(red: 255.0/255, green: 255.0/255, blue: 102.0/255, alpha: 1.0)
                default:
                        color = UIColor(red: 230.0/255, green: 230.0/255, blue: 250.0/255, alpha: 1.0)
                }
            case "Dry":
                color = UIColor(red: 93.0/255, green: 188.0/255, blue: 210.0/255, alpha: 1.0)
            case "Bleeding":
                color = UIColor(red: 255.0/255, green: 192.0/255, blue: 203.0/255, alpha: 1.0)
            default:
                color = UIColor(red: 230.0/255, green: 230.0/255, blue: 250.0/255, alpha: 1.0)
        }
        return color
    }
    
    // MARK: prep to persist methods
    
    func addNewUserInput(_ selectedArray: [FertilityInput]) {
        
        var currentUserInput:Dictionary = selectedArrayToUserInput(selectedArray)
        
        let fertile:Bool = isFertile(currentUserInput)
        let mucusType:String = findMucusType(currentUserInput)
        let peak:Bool = false
        //check to see if previous day is peak
        //if so, change bool to peak.
        
        markPreviousDayAsPeakIfNecessary(mucusType)
        //When can you know that peak type mucus is over?  the next day?
        //two days later?
        let color:String = determineColor(currentUserInput)
        
        
        
        let currentDay = Day(category1:currentUserInput["category1"]!,
                             category2: currentUserInput["category2"]!,
                             selection1: currentUserInput["selection1"]!,
                             selection2: currentUserInput["selection2"]!,
                             selection3: currentUserInput["selection3"]!,
                             mucusType:mucusType,
                             heart: heartTouched,
                             lubrication: lubricationSelected,
                             date: date,
                             color: color,
                             fertile:fertile,
                             peak:peak)
        
        if let currentDay = currentDay {
            days.append(currentDay)
        }
    }
    
    func markPreviousDayAsPeakIfNecessary(_ mucusType:String) {
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
    
    func isFertile(_ currentUserInput:Dictionary<String, String>) ->Bool {
        var isFertile:Bool = false
        
        if lubricationSelected {
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
    
    func findMucusType(_ currentUserInput:Dictionary<String, String>) ->String {
        var mucusType:String = ""
        
        if lubricationSelected {
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
    
    // MARK: NSCoding
    
    func saveDays() {
        Day.saveDays(days)
    }
    
    func loadDays() -> [Day]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Day.ArchiveURL.path) as? [Day]
    }
}
