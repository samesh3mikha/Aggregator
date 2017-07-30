//
//  SearchResultViewModel.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 7/25/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum SearchOption: Int {
    case All = 0, Course, University, Location
}

public typealias SaveSearchResultHandler = (Bool, String) -> Void

class SearchResultViewModel: NSObject {

    func saveSearch(searchword: String, option: SearchOption, completionBlock: @escaping SaveSearchResultHandler) {
        if searchword.isBlank {
            return
        }
        var searchData = [
            "search_text": "",
            "course_name": "",
            "university_name": "",
            "country_state": "",
            "flag": "I"
        ]
        switch option {
            case SearchOption.All:
                searchData["search_text"] = searchword
            case SearchOption.Course:
                searchData["course_name"] = searchword
            case SearchOption.University:
                searchData["university_name"] = searchword
            case SearchOption.Location:
                searchData["country_state"] = searchword
        }
        var data: [[String: String]] = []
        for (key, value) in searchData {
            data.append([key: value]) 
        }
        let params : Parameters = [
            "actionname": "favorite_search",
            "data": data
        ]
        DataSynchronizer.syncData(params: params, completionBlock: { (isRequestASuccess, message, data) in
            completionBlock(isRequestASuccess, message)
        })
    }
}
