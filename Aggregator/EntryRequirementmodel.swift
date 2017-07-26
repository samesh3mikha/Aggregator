//
//  EntryRequirementmodel.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/25/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
class EntryRequirementsDetails : NSObject
{
    
    let entry_requirement_type : Int
    let ref_dtl_name : String
    let created_by1 : String
   // let add_info : String
    let active : Bool
    let created_by : Int
    
    let institution_course_id : Int
    let created_on1 : String
    let entry_description : String
    let created_on : String
    let ref_mst_id : Int
    
    let entry_requirement_id : Int
    let COURSEREQUIREMENT : Int
    let entry_type_name : String
    let ref_dtl_id : Int
    let ref_dtl_code : String
    
    init( entry_requirement_type : Int,ref_dtl_name : String,created_by1 : String, active : Bool, created_by : Int,institution_course_id : Int, created_on1 : String, entry_description : String, created_on : String, ref_mst_id : Int,entry_requirement_id : Int,COURSEREQUIREMENT : Int,entry_type_name : String,ref_dtl_id : Int,ref_dtl_code : String

        )
    {
        
        self.entry_requirement_type = entry_requirement_type
        self.ref_dtl_name = ref_dtl_name
        self.created_by1 = created_by1
       // self.add_info = add_info
        self.active = active
        self.created_by = created_by
        self.institution_course_id = institution_course_id
        self.created_on1 = created_on1
        self.entry_description = entry_description
        self.created_on = created_on
        self.ref_mst_id = ref_mst_id
        self.entry_requirement_id = entry_requirement_id
        self.COURSEREQUIREMENT = COURSEREQUIREMENT
        self.entry_type_name = entry_type_name
        self.ref_dtl_id = ref_dtl_id
        self.ref_dtl_code = ref_dtl_code
        
    }
    
    
    
}
