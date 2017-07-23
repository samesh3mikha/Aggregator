//
//  File.swift
//  Aggregator
//
//  Created by pukar sharma on 6/1/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class PopupViewData: NSObject{
    
    let courseID : String
    let courseName : String
    let logo : String
    let shortComment : String
   
    
    
   
    init(courseID : String , courseName : String, logo : String, shortComment : String ) {
        
        self.courseID = courseID
        self.courseName = courseName
        self.logo = logo
        self.shortComment = shortComment
                
        super.init()
        
        
}

}
