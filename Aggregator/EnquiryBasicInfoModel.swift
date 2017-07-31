//
//  EnquiryBasicInfoModel.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/27/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class EnquiryDetailsModel : NSObject {
    
    var first_name = ""
    var last_name = ""
    var phone = ""
    var email_address = ""
    var comment = ""
    var reply = ""
    var course_name = ""
    var institute_logo_url = ""
    
    var full_name : String {
        return first_name + " " + last_name
    }
    
    init(firstName : String , lastName : String, phone : String, email_address : String) {
        self.first_name = firstName
        self.last_name = lastName
        self.email_address = email_address
        self.phone = phone
    }
}
