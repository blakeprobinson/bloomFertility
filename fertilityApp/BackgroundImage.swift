//
//  BackgroundImage.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/14/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "Watercolor Flowers Top Bottom.")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }}