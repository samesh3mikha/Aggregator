//
//  Courses.swift
//  Aggregator
//
//  Created by pukar sharma on 3/28/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class Courses: NSObject{
    
    let course_id : String
    let courseName : String
    let instituteName : String
    let studyLevel : String
    let country : String
    let institutionType : String
    let image : String
    let isWishlisted : Bool
    
    
   
    
    
    
    let isEnquired : Bool
    let isBookmarked : Bool
    
    
    enum searchCategory: String {
        case All
        case Courses
        case University
        case Location
    }
    
    init(course_id :String ,courseName : String,instituteName : String, studyLevel : String, country : String, institutionType : String,  image : String, isWishlisted : Bool , isEnquired : Bool , isBookmarked : Bool ) {
        self.course_id = course_id
        self.courseName = courseName
        self.instituteName = instituteName
        self.studyLevel = studyLevel
        self.country = country
        self.institutionType = institutionType
        self.image = image
        self.isWishlisted = isWishlisted
        self.isEnquired = isEnquired
        self.isBookmarked = isBookmarked
        
       
        
        super.init()
        
        
    }
    
}

