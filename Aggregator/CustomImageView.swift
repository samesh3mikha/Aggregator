//
//  CustomImageView.swift
//  Aggregator
//
//  Created by pukar sharma on 3/29/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
        {
        didSet{
            layer.cornerRadius = cornerRadius
            layer.borderWidth = 1
            layer.borderColor = UIColor.gray.cgColor
        }
    }
}
