//
//  CustomBorderLabel.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/31/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomBorderLabel: UILabel {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 1

    {
        didSet{
            let upperBorder = CALayer.init(layer: self.layer)
            upperBorder.backgroundColor = UIColor.darkGray.cgColor
            upperBorder.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1)
            layer.addSublayer(upperBorder)

        }
    }
}
