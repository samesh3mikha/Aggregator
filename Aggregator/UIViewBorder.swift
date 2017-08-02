//
//  UIViewBorder.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 8/2/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UIViewBorder: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 1
        
        {
        didSet{
            let upperBorder = CALayer.init(layer: self.layer)
            upperBorder.backgroundColor = UIColor.lightGray.cgColor
            upperBorder.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1)
            layer.addSublayer(upperBorder)
            
        }
    }
}
