//
//  InputTableViewFooter.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/11/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

protocol InputTableViewFooterDelegate {
    func datePickerValueChanged(_ sender: UIDatePicker)
}

class InputTableViewFooter: UIView {

    let screenSize: CGRect = UIScreen.main.bounds
    var delegate: InputTableViewFooterDelegate?
    var date = Date()
    
    // Mark: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 250)
        self.addSubview(addDatePicker())
    }
    
    func addDatePicker() -> UIDatePicker{
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 200)
        datePicker.timeZone = TimeZone.autoupdatingCurrent
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(datePickerSelectorWrapper(_:)), for: .valueChanged)
        return datePicker
    }
    
    func datePickerSelectorWrapper(_ sender: UIDatePicker!) {
        delegate?.datePickerValueChanged(sender)
    }

}
