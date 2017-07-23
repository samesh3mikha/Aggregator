//
//  BasicCompreData.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/12/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class BasicComparedatas:NSObject{
    
    let institutecourseid : String
    let course_name : String
    let full_duration : String
    let entry_requirements :String
    let fee_detail : String
    let  course_structure : String
    let  redirect_institution : String
    var  institute_name : String
    let  subjects : String
    let  redirect_course : String
    let  is_international_student : Bool
    
   
    
    init(institution_course_id :String ,course_name : String, full_duration : String, entry_requirements : String, fee_detail : String, course_structure : String , redirect_institution : String , institute_name : String ,subjects:String,redirect_course:String,is_international_student:Bool ) {
      
        
        self.course_name = course_name
        self.institute_name = institute_name
        self.full_duration = full_duration
        self.entry_requirements = entry_requirements
        self.fee_detail = fee_detail
        self.is_international_student = is_international_student
       
        self.institute_name = institute_name
        self.institutecourseid = institution_course_id
        self.course_structure = course_structure
        self.subjects = subjects
        self.redirect_course = redirect_course
        self.redirect_institution = redirect_institution
        
        
        super.init()
        
   
    }
    
    
    
    
    
    
}
