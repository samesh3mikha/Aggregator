//
//  roundView.swift
//  Aggregator
//
//  Created by pukar sharma on 5/17/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class roundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 0
   
    
        
        {
        didSet{
            layer.cornerRadius = cornerRadius
            layer.borderWidth = borderWidth
            layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor

        }
    }
}
