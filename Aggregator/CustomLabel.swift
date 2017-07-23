//
//  File.swift
//  Aggregator
//
//  Created by pukar sharma on 6/12/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 0
   
        
        
        
        {
        didSet{
            
            
            layer.cornerRadius = cornerRadius
            layer.borderWidth = borderWidth
            layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            
            layer.masksToBounds = true
            
//            let recognizer = UITapGestureRecognizer()
//            recognizer.addTarget(self, action: #selector(self.lbllongpress))
//            self.addGestureRecognizer(recognizer)
            
        }
    }
    
//    func lbllongpress(gesture: UILongPressGestureRecognizer) {
//        switch gesture.state {
//        case UIGestureRecognizerState.began:
//            
//            
//            self.backgroundColor = UIColor.red
//            
//        case UIGestureRecognizerState.ended:
//            
//            self.backgroundColor = UIColor.yellow
//
//        // Implementation here...
//        default: break
//        }
//    }
}
