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
        
        let screenSize: CGRect = UIScreen.main.bounds
        let headerFrame = CGRect(x: 0, y: 0, width: screenSize.width, height: 60)
        let headerView = UIView(frame: headerFrame)
        headerView.backgroundColor = UIColor(red:0.36, green:0.81, blue:0.94, alpha:1.0)
        let labelFrame = CGRect(x: 0, y: 20, width: screenSize.width, height: 40)
        let label = UILabel(frame: labelFrame)
        label.text = "Your cycles"
        label.textAlignment = NSTextAlignment.center
        headerView.addSubview(label)
        cycleTableView.tableHeaderView = headerView

        
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        model = Day.loadDaysAsCycles()
        cycleTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 1
        // Return the number of sections.
        return model.count
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cycleCell",
                                                               for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        headerView.backgroundColor = UIColor.cyan
        
        let headerLabel = UILabel(frame: CGRect(x: 5, y: 3, width: 200, height: 20))
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
    
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                                            forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? cycleTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, self, forRow: indexPath.row)
    }

}

//extension Date
//{
//    
//    init(dateString:String) {
//        let dateStringFormatter = DateFormatter()
//        dateStringFormatter.dateFormat = "MM/dd/yyyy"
//        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
//        let d = dateStringFormatter.date(from: dateString)!
//        (self as NSDate).init(timeInterval:0, since:d)
//    }
//}

extension CycleTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cycleCell",
                                                                         for: indexPath)
        
        cell.backgroundColor = model[collectionView.tag][indexPath.item].returnUIColor()
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        
        return cell
    }
}
