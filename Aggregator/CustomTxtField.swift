//
//  studentTxtField.swift
//  MeshedEportal
//
//  Created by Rekha Bohara on 9/14/16.
//  Copyright © 2016 websutra. All rights reserved.
//

import UIKit


var textImage = UIImageView()

@IBDesignable class CustomTxtField: UITextField {
    
    
    @IBInspectable var inset: CGFloat = 0
    @IBInspectable var ImageName: String = ""
    @IBInspectable var cornerRadius: CGFloat = 0
     
        {
        
        didSet{
            
            leftViewMode = UITextFieldViewMode.always
            
            let emailImgContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            
            let emailImView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            
            let image = UIImage(named: ImageName)?.withRenderingMode(.alwaysTemplate)
            
          
            emailImView.image = image
            
            emailImView.tintColor = UIColor.black
            backgroundColor = UIColor.clear
            //emailImView.center = emailImgContainer.center
            emailImView.contentMode = .scaleAspectFit
            emailImgContainer.addSubview(emailImView)
            
            
            leftView = emailImgContainer
            layer.cornerRadius = cornerRadius
           
            
        }
    }

    override func draw(_ rect: CGRect) {
        
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 2.0
        
        tintColor.setStroke()
        
        path.stroke()
    }
    
}


    
    



