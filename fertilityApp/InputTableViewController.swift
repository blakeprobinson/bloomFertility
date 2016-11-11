//
//  InputTableViewController.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/11/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class InputTableViewController: UITableViewController, TableViewCellDelegate, InputTableViewHeaderDelegate {
    @IBOutlet var inputTableView: UITableView!
    var menuData = MenuData()
    var persistMenuData = PersistMenuData()
    
    var validationLabel = UILabel()
    var date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTableView.separatorStyle = .none
        inputTableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        inputTableView.backgroundColor = UIColor.white
        
        //set up header view
        let screenSize: CGRect = UIScreen.main.bounds
        let headerView = InputTableViewHeader()
        headerView.delegate = self
        
//        validationLabel = UILabel(frame: CGRect(x: screenSize.width*(0.1), y: 110, width: screenSize.width*(0.8), height: 60))
//        validationLabel.text = ""
//        validationLabel.numberOfLines = 0
//        validationLabel.textAlignment = NSTextAlignment.center
//        validationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//        validationLabel.font = UIFont(descriptor: JennaSue, size: 17);
        
        //headerView.addSubview(button)
//        headerView.addSubview(validationLabel)
        //headerView.addSubview(heartButton)
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
            persistMenuData.addNewUserInput(selectedArray, menuData:menuData, date:date)
            persistMenuData.saveDays()
            goToCycleView()
            
            
            //clear existing selections in tableView
            menuData.removeAnySubInputsFromFertilityArray()
            self.inputTableView.reloadData()
        }
    }
    
    func goToCycleView() {
        if let cycleViewController = tabBarController?.viewControllers![1] {
            cycleViewController.viewWillAppear(true)
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
    
}
