//
//  AreaOfInterest.swift
//  Aggregator
//
//  Created by pukar sharma on 3/30/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class AreaOfInterest: NSObject{
    
    let facultyName : String
    let facultyId : Int
    var checkStatus : Int
    
    
    init(facultyName : String, facultyId : Int, checkStatus : Int)
    {
        
        self.facultyName = facultyName
        self.facultyId = facultyId
        self.checkStatus = checkStatus
        
        super.init()
        
        
    }
    
}

