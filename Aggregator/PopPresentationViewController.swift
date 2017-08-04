 //
//  PopPresentationViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 5/25/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages

 public typealias ShowSearchResultHandler = (Int, String) -> Void
 public typealias ShowDetailsPageHandler = (String) -> Void

class PopPresentationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var popUpArray = [PopupViewData]()
    var buttonIndex = 1
    var showSearchResultHandlerBlock: ShowSearchResultHandler?
    var showEnquiryDetailsHandlerBlock: ShowDetailsPageHandler?
    var showBookmarkDetailsHandlerBlock: ShowDetailsPageHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        fetchPopData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Network
    func fetchPopData() {
        popUpArray = []
        showStatusHUD(title: "Syncing Data!", details: "Please wait..", theme: .success, duration: .seconds(seconds: 0.2))

        var actionName = ""
        var flag = ""
        var expectedKey = ""
        switch buttonIndex {
        case 1:
            actionName = "favorite_search"
            expectedKey = "FAVORITE_SEARCH"
            flag = "S"
        case 2:
            actionName = "user_course_enquiry"
            expectedKey = "ENQUIRYLIST"
            flag = "P"
        case 3:
            actionName = "user_course_bookmark"
            expectedKey = "BOOKMARKLIST"
            flag = "S"
        default:
            actionName = ""
        }
        let params : Parameters = [
            "actionname": actionName,
            "data": [
                ["flag": flag]
            ]
        ]
        DataSynchronizer.syncData(params: params, completionBlock: { [weak self] (isRequestASuccess, message, data) in
            guard let weakself = self else {
                return
            }
            if isRequestASuccess {
                if let responseArray = data[expectedKey].arrayObject {
                    let popData = responseArray as! [[String:AnyObject]]
                    for dict in popData {
                        var shortCmnt = ""
                        var e: PopupViewData? = nil
                        if weakself.buttonIndex == 1 {
                            var searchWord = ""
                            if let searchText = dict["course_name"] as? String {
                                if !searchText.isBlank {
                                    searchWord = searchText
                                    shortCmnt = "By Course"
                                }
                            } else if let searchText = dict["university_name"] as? String {
                                if !searchText.isBlank {
                                    searchWord = searchText
                                    shortCmnt = "By University"
                                }
                            } else if let searchText = dict["country_state"] as? String {
                                if !searchText.isBlank {
                                    searchWord = searchText
                                    shortCmnt = "By Location"
                                }
                            } else if let searchText = dict["search_text"] as? String {
                                if !searchText.isBlank {
                                    searchWord = searchText
                                    shortCmnt = "All results"
                                }
                            }
                            e = PopupViewData(
                                itemID: "\(dict["favorite_search_id"]!)",
                                title: searchWord, 
                                details: shortCmnt, 
                                imageUrl: ""
                            )
                        } else if weakself.buttonIndex == 2 {
                            e = PopupViewData(
                                itemID: "\(dict["enquiry_id"]!)",
                                title: "\(dict["course_name"]!)", 
                                details: "\(dict["shortcomment"]!)", 
                                imageUrl: "\(dict["institute_logo"]!)"
                            )
                        } else if weakself.buttonIndex == 3 {
                            e = PopupViewData(
                                itemID: "\(dict["institution_course_id"]!)",
                                title: "\(dict["course_name"]!)", 
                                details: "", 
                                imageUrl: "\(dict["institute_logo"]!)"
                            )
                        }
                        weakself.popUpArray.append(e!)
                    }
                    weakself.tableView.reloadData()
                }
            } else {
                weakself.showStatusHUD(title: "Error", details: message, theme: .error, duration: .seconds(seconds: 0.3))
            }
        })
    }
    
    // Delete Favorite Search By ID
    func deleteFavoriteSearch(favSearchID: String) {
        let params : Parameters = [
            "actionname": "favorite_search",
            "data": [
                ["flag": "D"],
                ["favorite_search_id": favSearchID]
            ]
        ]
        DataSynchronizer.syncData(params: params, completionBlock: { [weak self] (isRequestASuccess, message, data) in
            guard let weakself = self else {
                return
            }
            if isRequestASuccess {
                weakself.fetchPopData()
            } else {
                weakself.showStatusHUD(title: "Action failed", details: "Couldn't delete the item", theme: .info, duration: .automatic)
            }
        })
    }
    
    // Delete Bookmarh By ID
    func deleteBookmark(courseID: String) {
        let params : Parameters = [
            "actionname": "user_course_bookmark",
            "data": [
                ["flag": "D"],
                ["institution_course_id": courseID]
            ]
        ]
        DataSynchronizer.syncData(params: params, completionBlock: { [weak self] (isRequestASuccess, message, data) in
            guard let weakself = self else {
                return
            }
            if isRequestASuccess {
                weakself.fetchPopData()
            } else {
                weakself.showStatusHUD(title: "Action failed", details: "Couldn't delete the item", theme: .info, duration: .automatic)
            }
        })
    }
    
    
    
    //MARK: TABLEVIEW DELEGATE AND DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return popUpArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if buttonIndex == 1 || buttonIndex == 3 {
            return 80
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "BasicTableViewCell")! as! BasicTableViewCell

        let popData = popUpArray[indexPath.row]
        cell.itemID = popData.itemID
        cell.logoImageView.sd_setImage(with: URL.init(string: popData.imageUrl), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        cell.titleLabel.text = popData.title
        cell.detailsLabel.text = popData.details
        cell.closeButton.isHidden = false
        if buttonIndex == 1 {
            cell.deleteItemHandlerBlock = { [weak cell] in
                self.deleteFavoriteSearch(favSearchID: (cell?.itemID)!)
            }
        } else if buttonIndex == 2 {
            cell.closeButton.isHidden = true
        } else if buttonIndex == 3 {
            cell.detailsLabel.isHidden = true
            cell.deleteItemHandlerBlock = { [weak cell] in
                self.deleteBookmark(courseID: (cell?.itemID)!)
            }
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popData = popUpArray[indexPath.row]
        if buttonIndex == 1 {
            var searchOption: SearchOption = .All
            if popData.details == "By Course" {
                searchOption = .Course
            } else if popData.details == "By University" {
                searchOption = .University
            } else if popData.details == "By Location" {
                searchOption = .Location
            }
            if let handlerBlock = self.showSearchResultHandlerBlock {                        
                handlerBlock(searchOption.rawValue, popData.title)
                self.dismiss(animated: true, completion: nil)
            }
        } else if buttonIndex == 2 {
            if let handlerBlock = self.showEnquiryDetailsHandlerBlock {                        
                self.dismiss(animated: true, completion: {
                    handlerBlock(popData.itemID)
                })
            }
        } else if buttonIndex == 3 {
            if let handlerBlock = self.showBookmarkDetailsHandlerBlock {                        
                self.dismiss(animated: true, completion: {
                    handlerBlock(popData.itemID)
                })
            }
        }
    }
}
