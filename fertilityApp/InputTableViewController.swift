//
//  InputTableViewController.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/11/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class InputTableViewController: UITableViewController, TableViewCellDelegate, InputTableViewHeaderDelegate, InputTableViewFooterDelegate {
    @IBOutlet var inputTableView: UITableView!
    var menuData = MenuData()
    var persistMenuData = PersistMenuData()
    var headerView = InputTableViewHeader()
    var footerView = InputTableViewFooter()
    var date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTableView.separatorStyle = .none
        inputTableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        inputTableView.backgroundColor = UIColor.white
        inputTableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0)
        
        //set up header view and footer view
        headerView.delegate = self
        inputTableView.tableHeaderView = headerView
        
        footerView.delegate = self
        inputTableView.tableFooterView = footerView
        
    }
    
    // MARK: TableView and related
    
    func heartButtonAction(_ sender: UIButton!) {
        menuData.heartTouched = !menuData.heartTouched
    }
    
    func validationLabelText() -> Bool {
        let text = menuData.validateInputs(menuData.selectedElements())
        headerView.addValidationText(text: text)
        return text.characters.count == 0
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        date = sender.date
    }
    
    func saveButtonAction(_ sender: UIButton!) {
       
        //If no validation label is generated, then inputs are valid.
        if validationLabelText() {
        persistMenuData.addNewUserInput(menuData.selectedElements(), menuData:menuData, date:date)
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
        
        let inputViewModel = menuData.fertilityInputs[indexPath.row]
        cell.configure(withViewModel: inputViewModel)
        cell.selectionStyle = .none
        cell.delegate = self
        cell.fertilityInput = nil
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if menuData.fertilityInputs[indexPath.row].isCategory {
            return 75.0
        } else {
            return 50.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //call a method on menuData with the index path to
        //mark that InputViewModel as selected.
        menuData.changeInputSelection(indexPath: indexPath, select: true)
        let indexPaths = menuData.selected(index:indexPath)
        inputTableView.beginUpdates()
        inputTableView.insertRows(at: indexPaths, with: .bottom)
        inputTableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        menuData.changeInputSelection(indexPath: indexPath, select: false)
        
        // use the UITableView to animate the removal of this row
        inputTableView.beginUpdates()
        
        //if indexPaths has a value then remove those indexPaths from the tableView
        if let indexPaths = menuData.removeSubInputsFromFertilityArray(indexPath: indexPath) {
            inputTableView.deleteRows(at: indexPaths, with: .fade)
        }
        inputTableView.endUpdates()
    }
    
}
