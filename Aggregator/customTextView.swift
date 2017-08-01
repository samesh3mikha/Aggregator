//
//  customTextView.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 8/1/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import UIKit
class MyTextView: UITextField {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 2
        
        {
        didSet{

            let upperBorder = CALayer.init(layer: self.layer)
            layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            upperBorder.backgroundColor = UIColor.darkGray.cgColor
            upperBorder.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1)
            layer.addSublayer(upperBorder)
//            upperBorder.backgroundColor = UIColor.darkGray.cgColor
            
            
        }
    }
}
