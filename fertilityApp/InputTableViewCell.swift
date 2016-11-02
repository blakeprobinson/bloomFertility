//
//  InputTableViewCell.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/12/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit
import QuartzCore

protocol TableViewCellDelegate {
    // indicates that the given item has been deleted
    func fertilityInputCategoryDeselected(_ fertilityInput: fertilityInput)
    func fertilityInputSelected(_ fertilityInput: fertilityInput)
}

class TableViewCell: UITableViewCell {
    
    let gradientLayer = CAGradientLayer()
    
    var originalCenter = CGPoint()
    var deselectOnDragRelease = false
    var tickLabel: UILabel!, crossLabel: UILabel!
    var selectOnDragRelease = false
    let label: StrikeThroughText
    var itemCompleteLayer = CALayer()
    
    // The object that acts as delegate for this cell.
    var delegate: TableViewCellDelegate?
    // The item that this cell renders.
    var FertilityInput: fertilityInput? {
        didSet {
            label.text = FertilityInput!.name
//            label.strikeThrough = FertilityInput!.selected
            itemCompleteLayer.isHidden = !FertilityInput!.selected || FertilityInput!.isCategory
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // create a label that renders the to-do item text
        label = StrikeThroughText(frame: CGRect.null)
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        // remove the default blue highlight for selected cells
        selectionStyle = .none
        // gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        
        // tick and cross labels for context cues
        tickLabel = createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .right
        addSubview(tickLabel)
        crossLabel = createCueLabel()
        crossLabel.text = "\u{2717}"
        crossLabel.textAlignment = .left
        addSubview(crossLabel)
        
        // add a layer that renders a green background when an item is complete
        itemCompleteLayer = CALayer(layer: layer)
        itemCompleteLayer.backgroundColor = UIColor(red: 109/255, green: 228/255, blue: 209/255,
                                                    alpha: 1.0).cgColor
        itemCompleteLayer.isHidden = true
        layer.insertSublayer(itemCompleteLayer, at: 0)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(TableViewCell.handlePan(_:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    let kLabelLeftMargin: CGFloat = 15.0
    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0
    override func layoutSubviews() {
        super.layoutSubviews()
        // ensure the gradient layer occupies the full bounds
        gradientLayer.frame = bounds
        itemCompleteLayer.frame = bounds
        label.frame = CGRect(x: kLabelLeftMargin, y: 0,
                             width: bounds.size.width - kLabelLeftMargin,
                             height: bounds.size.height)
        
        
        tickLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
                                 width: kUICuesWidth, height: bounds.size.height)
        crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
                                  width: kUICuesWidth, height: bounds.size.height)
    }
    
    // utility method for creating the contextual cues
    func createCueLabel() -> UILabel {
        let label = UILabel(frame: CGRect.null)
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        label.backgroundColor = UIColor.clear
        return label
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deselectOnDragRelease = frame.origin.x < -frame.size.width / 4.0
            selectOnDragRelease = frame.origin.x > frame.size.width / 4.0
            
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            tickLabel.alpha = cueAlpha
            crossLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            tickLabel.textColor = selectOnDragRelease ? UIColor.green : UIColor.white
            crossLabel.textColor = deselectOnDragRelease ? UIColor.red : UIColor.white
        }
        // 3
        if recognizer.state == .ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            
            if deselectOnDragRelease {
                if delegate != nil && FertilityInput != nil {
                    // notify the delegate that this item should be deleted
                    FertilityInput!.selected = false
                    itemCompleteLayer.isHidden = true
                    delegate!.fertilityInputCategoryDeselected(FertilityInput!)
                    UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
                }
            } else if selectOnDragRelease {
                if delegate != nil && FertilityInput != nil {
                   
                   
                    if !FertilityInput!.isCategory || FertilityInput!.name == "Lubrication" {
                        //only mark subInputs as selected or not
                        itemCompleteLayer.isHidden = false
                        FertilityInput!.selected = true
                    } else {
                        //the categories need to be selected also so they can't be re-selected
                        if !FertilityInput!.selected {
                            delegate!.fertilityInputSelected(FertilityInput!)
                        }
                        FertilityInput!.selected = true
                        
                    }
                }
                
                //label.strikeThrough = true
//                if self.FertilityInput {
//                    
//                }
                
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            } else {
                // if the item is not being deleted or selected, snap back to the original location
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
            
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
