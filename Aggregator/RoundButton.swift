//
//  RoundButton.swift
//  MeshedEportal
//
//  Created by Rekha Bohara on 9/6/16.
//  Copyright © 2016 websutra. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 0
    
        {
        didSet{
            layer.cornerRadius = cornerRadius
            layer.borderWidth = borderWidth
            layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        }
    }
}
