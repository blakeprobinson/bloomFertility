//
//  InputTableViewHeader.swift
//  fertilityApp
//
//  Created by Blake Robinson on 11/11/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

protocol InputTableViewHeaderDelegate {
    func saveButtonAction(_ sender: UIButton!)
    func heartButtonAction(_ sender: UIButton!)
}

class InputTableViewHeader: UIView {
    
    let screenSize: CGRect = UIScreen.main.bounds
    var delegate: InputTableViewHeaderDelegate?

    // Mark: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 180)
        let saveButton = setupSaveButton()
        let heartButton = setupHeartButton()
        self.addSubview(saveButton)
        self.addSubview(heartButton)
    }
    
    func setupSaveButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: screenSize.width*(0.1), y: 40, width: screenSize.width*(0.6), height: 60))
        button.backgroundColor = UIColor(red: 109.0/255, green: 228/250.0, blue: 209/255.0, alpha: 1.0)
        button.setTitle("Save", for: UIControlState())
        button.addTarget(self, action: #selector(saveButtonActionWrapper(_:)), for: .touchUpInside)
        return button
    }
    
    func setupHeartButton() -> UIButton {
        let image = UIImage(named: "heart emoji")
        let heartButton   = UIButton(type: UIButtonType.custom)
        heartButton.frame = CGRect(x: screenSize.width*(0.75), y: 50, width: screenSize.width*(0.15), height: 50)
        heartButton.setImage(image, for: UIControlState())
        heartButton.addTarget(self, action: #selector(heartButtonActionWrapper(_:)), for:.touchUpInside)
        return heartButton
    }
    
    func saveButtonActionWrapper(_ sender:UIButton!) {
        delegate?.saveButtonAction(sender)
    }
    
    func heartButtonActionWrapper(_ sender: UIButton!) {
        delegate?.heartButtonAction(sender)
    }
    
//    validationLabel = UILabel(frame: CGRect(x: screenSize.width*(0.1), y: 110, width: screenSize.width*(0.8), height: 60))
//    validationLabel.text = ""
//    validationLabel.numberOfLines = 0
//    validationLabel.textAlignment = NSTextAlignment.center
//    validationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//    //        validationLabel.font = UIFont(descriptor: JennaSue, size: 17);
//    
//    headerView.addSubview(button)
//    headerView.addSubview(validationLabel)
//    headerView.addSubview(heartButton)

}
