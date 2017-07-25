//
//  CourseCompareDetailsModel.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 7/25/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class CourseCompareDetailsModel: NSObject {
    var courses = [BasicComparedatas]()
    var pageIndex:Int! = 0
    
    init(courses: [BasicComparedatas], page: Int) {
        self.courses = courses
        self.pageIndex = page
    }
    
    func titleForPage() -> String {
        switch pageIndex {
        case 0:
            return "Entry Requirements"
        case 1:
            return "Institute Name"
        case 2:
            return "Course Structure"
        case 3:
            return "Fee Detail"
        case 4:
            return "Subjects"
        case 5:
            return "International Student"
        default:
            return "Entry Requirements"
        }
    }
    
    func detailsForSection(section: Int) -> String {
        let course = courses[section]
        switch pageIndex {
        case 0:
            return course.entry_requirements
        case 1:
            return course.institute_name
        case 2:
            return course.course_structure
        case 3:
            return course.fee_detail
        case 4:
            return course.subjects
        case 5:
            return (course.is_international_student) ? "Yes" : "No"
        default:
            return course.entry_requirements
        }
    }
    
}
