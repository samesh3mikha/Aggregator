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

class SearchResultViewModel: NSObject {
    
    func saveSearch(searchword: String, option: SearchOption, accessToken: String) {
        if accessToken.isBlank || searchword.isBlank {
            return
        }
        let url = baseUrl + "Processdata"
        let accessKey = "bearer " + accessToken
        let headers: HTTPHeaders = [
            "Authorization":  accessKey,
            "Content-Type": "application/json"
        ]
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

        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let data = JSON(value)
                    print("data == >", data)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getFavoriteSearch(accessToken: String) -> [Any] {
        if accessToken.isBlank {
            return []
        }
        let url = baseUrl + "Processdata"
        let accessKey = "bearer " + accessToken
        let headers: HTTPHeaders = [
            "Authorization":  accessKey,
            "Content-Type": "application/json"
        ]
        let params : Parameters = [
            "actionname": "favorite_search",
            "data": [
                ["flag": "S"]
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let data = JSON(value)
                print("data == >", data)
            case .failure(let error):
                print(error)
            }
        }
        return []
    }
}
