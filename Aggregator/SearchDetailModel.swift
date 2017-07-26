//
//  SearchDetailModel.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/19/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
class SearchDeatils: NSObject{
    
    let institution_course_id : Int
    let course_id : Int
    let course_name : String
    let institute_id : Int
    let institute_name : String
    let phone : String
    let institute_image : String
    let institute_logo : String
    
    let gps_lattitude : Int
    let gps_longitude : Int
    let email_address : String
    let website : String
    let about_us : String
    let course_description : String
    let faculty_name : String
    let course_code : String
    
    let active : Bool
    let institute_full_address : String
    let study_level_name : String
    let country : String
    let institution_type : String
   
   
    enum searchCategory: String {
        
        case Courses
        case University
       
    }

    
     init( institution_course_id : Int
        ,course_id : Int,
         course_name : String,
         institute_id : Int,
         institute_name : String,
         phone : String,
         institute_image : String,
     institute_logo : String,
    
     gps_lattitude : Int,
     gps_longitude : Int,
     email_address : String,
     website : String,
     about_us : String,
     course_description : String,
     faculty_name : String,
     course_code : String,
    
     active : Bool,
     institute_full_address : String,
     study_level_name : String,
     country : String,
     institution_type : String
) {
        
        
        
               self.institution_course_id = institution_course_id
                self.course_id = course_id
                self.course_name = course_name
        
                self.institute_id = institute_id
                self.institute_name = institute_name
        self.phone = phone
        self.institute_image = institute_image
        self.institute_logo = institute_logo
        
        self.gps_lattitude = gps_lattitude
        self.gps_longitude = gps_longitude
        self.email_address = email_address
        self.website = website
        self.about_us = about_us
        
        self.course_description = course_description
        self.faculty_name = faculty_name
        
        self.course_code = course_code
       
        
        self.active = false
        self.institute_full_address = institute_full_address
        
        self.study_level_name = study_level_name
        self.country = country
         self.institution_type = institution_type

        
        
         super.init()
    }

    
        
        
        
        
   
        
    }
    


