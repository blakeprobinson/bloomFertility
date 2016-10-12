//
//  InputContainerViewController.swift
//  fertilityApp
//
//  Created by Blake Robinson on 10/10/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class InputContainerViewController: UIViewController, UIPageViewControllerDataSource {
    
    var dates:[String] = []
    var model:[[Day]] = Day.loadDaysAsCycles()
    
    @IBOutlet weak var saveFertilityInput: UIButton!
    
    override func viewDidLoad() {
        dates = ["Today", "Yesterday", "10/8/16", "10/7/16"]
        var pageViewController:UIPageViewController
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InputPageViewController") as! UIPageViewController
        pageViewController.dataSource = self
        let startingViewController = self.viewControllerAtIndex(0)
        let viewControllers = [startingViewController]
        pageViewController.setViewControllers(viewControllers, direction:.Forward, animated: false, completion:nil)
        
        pageViewController.view.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70);
        self.addChildViewController(pageViewController)
        
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let pageViewController = viewController as! FertilitySignViewController
        var index:Int
        if let pageIndex = pageViewController.pageIndex {
            index = pageIndex
            if pageIndex == 0 {
                return nil
            } else {
                index=index-1
            }
        } else {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let pageViewController = viewController as! FertilitySignViewController
        var index:Int
        if let pageIndex = pageViewController.pageIndex {
            index = pageIndex
            if pageIndex == model.count {
                return nil
            } else {
                index=index+1
            }
        } else {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index:Int) -> FertilitySignViewController {
        
        let fertilitySignVC = self.storyboard?.instantiateViewControllerWithIdentifier("FertilitySignViewController") as! FertilitySignViewController
        
        fertilitySignVC.pageIndex = 0;
        fertilitySignVC.leftDateText = "Yesterday"
        fertilitySignVC.middleDateString = "Today"
        
        return fertilitySignVC
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
