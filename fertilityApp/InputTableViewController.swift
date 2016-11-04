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
    var persistMenuData = PersistMenuData()
    
    var validationLabel = UILabel()
    var date = Date()
    var days = PersistMenuData.fetchDays()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        menuData.heartTouched = !menuData.heartTouched
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        date = sender.date
    }
    
    func saveButtonAction(_ sender: UIButton!) {
        validationLabel.text = ""
        let selectedArray = menuData.selectedElements()
        
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
    
    // MARK: - Cell Selection/Deselection Protocol

    func fertilityInputCategoryDeselected(_ FertilityInput:FertilityInput) {
        let index = (menuData.fertilityInputs as NSArray).index(of: FertilityInput)
        if index == NSNotFound { return }
        
        // use the UITableView to animate the removal of this row
        inputTableView.beginUpdates()
        
        //if indexPaths has a value then remove those indexPaths from the tableView
        if let indexPaths = menuData.removeSubInputsFromFertilityArrayReturnIndexPaths(FertilityInput) {
            inputTableView.deleteRows(at: indexPaths, with: .fade)
        }
        inputTableView.endUpdates()
    }
    
    func fertilityInputSelected(_ fertilityInput: FertilityInput) {
        let indexPaths = menuData.selected(input: fertilityInput)
        inputTableView.beginUpdates()
        inputTableView.insertRows(at: indexPaths, with: .bottom)
        inputTableView.endUpdates()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.fertilityInputs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let initialCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let cell = initialCell as? TableViewCell else {
            return initialCell
        }
        
        let fertilityInput = menuData.fertilityInputs[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.fertilityInput = fertilityInput
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if menuData.fertilityInputs[indexPath.row].isCategory {
            return 75.0
        } else {
            return 50.0
        }
    }
    
    // MARK: prep to persist methods
    
    func addNewUserInput(_ selectedArray: [FertilityInput]) {
        
        let currentUserInput:Dictionary = persistMenuData.selectedArrayToUserInput(selectedArray)
        
        let fertile:Bool = persistMenuData.isFertile(currentUserInput, menuData:menuData)
        let mucusType:String = persistMenuData.findMucusType(currentUserInput, menuData: menuData)
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
    
    
    // MARK: NSCoding
    
    func saveDays() {
        Day.saveDays(days)
    }
    
}
