//
//  RadioButton.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 8/1/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import UIKit
class RadioButton: UIButton {
    // Images
    let uncheckedImage = UIImage(named: "unchecked")! as UIImage
    let checkedImage = UIImage(named: "checked")! as UIImage
  
     var inButtoncount : Int = 0
    // Bool property
    var isChecked: Bool = true {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
                inButtoncount = 1
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
                inButtoncount = 0
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = true
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
