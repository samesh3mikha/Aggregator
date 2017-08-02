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
            layer.borderColor = UIColor.init(white: 0.2, alpha: 1).cgColor

        }
    }
}
