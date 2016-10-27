//
//  CycleTableViewController.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/15/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class CycleTableViewController: UITableViewController {
    
    //let model: [[UIColor]] = generateRandomData()
    @IBOutlet var cycleTableView: UITableView!
    
    var model:[[Day]] = Day.loadDaysAsCycles()

    
//    var days = [[Day]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let headerFrame = CGRectMake(0, 0, screenSize.width, 60)
        let headerView = UIView(frame: headerFrame)
        headerView.backgroundColor = UIColor(red:0.36, green:0.81, blue:0.94, alpha:1.0)
        let labelFrame = CGRectMake(0, 20, screenSize.width, 40)
        let label = UILabel(frame: labelFrame)
        label.text = "Your cycles"
        label.textAlignment = NSTextAlignment.Center
        headerView.addSubview(label)
        cycleTableView.tableHeaderView = headerView

        
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        model = Day.loadDaysAsCycles()
        cycleTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        // Return the number of sections.
        return model.count
    }

    override func tableView(tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cycleCell",
                                                               forIndexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 25))
        headerView.backgroundColor = UIColor.cyanColor()
        
        let headerLabel = UILabel(frame: CGRectMake(5, 3, 200, 20))
        headerView.addSubview(headerLabel)
        let sectionString = String(section)
        
        switch (section) {
            case 0:
                headerLabel.text = "This cycle"
            case 1:
                headerLabel.text = "Last cycle"
            default:
                headerLabel.text = "("+sectionString+")"
        }
        
        return headerView
    }
    
    override func tableView(tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? cycleTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }

}

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "MM/dd/yyyy"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

extension CycleTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return model[collectionView.tag].count
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cycleCell",
                                                                         forIndexPath: indexPath)
        
        cell.backgroundColor = model[collectionView.tag][indexPath.item].returnUIColor()
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.grayColor().CGColor
        
        return cell
    }
}
