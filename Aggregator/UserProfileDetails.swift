//
//  UserProfileDetails.swift
//  Aggregator
//
//  Created by pukar sharma on 6/12/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class UserProfileDetails : NSObject
{
    
    let first_name : String
    let last_name : String
    let phone : String
    let email_address : String
    let date_of_birth : String
    let gender : String
    
    let highest_degree_name : String
    let english_proficiency_name : String
    let country_of_study_name : String
    let work_experience : String
    let notes : String
    
    let country : String
    let city : String
    let street_address : String
    let state : String
    let profileImageLink : String
    
    init(firstName : String , lastName : String, email_address : String, date_of_birth : String, gender : String, highest_degree_name : String,  english_proficiency_name : String, country_of_study_name : String,work_experience : String,notes : String,state : String, country : String ,city : String,street_address : String, phone : String,profileImageLink : String
 )
    {
        
        self.first_name = firstName
        self.last_name = lastName
        self.email_address = email_address
        self.date_of_birth = date_of_birth
        self.gender = gender
        self.highest_degree_name = highest_degree_name
        self.english_proficiency_name = english_proficiency_name
        self.country_of_study_name = country_of_study_name
        self.work_experience = work_experience
        self.notes = notes
        self.country = country
        self.city = city
        self.street_address = street_address
        self.phone = phone
        self.state = state
        self.profileImageLink = profileImageLink
        
    }
    
    
    
}
