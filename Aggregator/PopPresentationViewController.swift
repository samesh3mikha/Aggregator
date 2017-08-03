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
                            e = PopupViewData.init(courseID: "\(dict["favorite_search_id"]!)" ,courseName: searchWord, logo: "", shortComment: shortCmnt )
                        } else if weakself.buttonIndex == 2 {
                            shortCmnt = "\(dict["shortcomment"]!)"
                            e = PopupViewData.init(courseID: "\(dict["enquiry_id"]!)" ,courseName: "\(dict["course_name"]!)", logo: "\(dict["institute_logo"]!)", shortComment: shortCmnt )
                        } else if weakself.buttonIndex == 3 {
                            e = PopupViewData.init(courseID: "\(dict["institution_course_id"]!)" ,courseName: "\(dict["course_name"]!)", logo: "\(dict["institute_logo"]!)", shortComment: shortCmnt )
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

    
    
    //MARK: TABLEVIEW DELEGATE AND DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return popUpArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if buttonIndex == 1 {
            return 80
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if buttonIndex == 3 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "bookmark&wishlistid")! as! BookMark_WishTableViewCell
            cell.courseNameLbl.text = popUpArray[indexPath.row].courseName
            cell.logoImageview.sd_setImage(with: URL.init(string: popUpArray[indexPath.row].logo), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            return cell
        } else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "enquiryid")! as! EnquiryTableViewCell
            
            cell.courseNameLbl.text = popUpArray[indexPath.row].courseName
            cell.enquiryDetail.text = popUpArray[indexPath.row].shortComment
            
            print("COmment ==", popUpArray[indexPath.row].shortComment)
            if buttonIndex == 1 {
                cell.closeButton.isHidden = false
                cell.itemID = popUpArray[indexPath.row].courseID
                cell.deleteItemHandlerBlock = { [weak cell] in
                    self.deleteFavoriteSearch(favSearchID: (cell?.itemID)!)
                }
            } else {
                cell.closeButton.isHidden = true
            }
            cell.logoImageView.sd_setImage(with: URL.init(string: popUpArray[indexPath.row].logo), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            cell.selectionStyle = .none
            //set the data here
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if buttonIndex == 1 {
            var searchOption: SearchOption = .All
            if popUpArray[indexPath.row].shortComment == "By Course" {
                searchOption = .Course
            } else if popUpArray[indexPath.row].shortComment == "By University" {
                searchOption = .University
            } else if popUpArray[indexPath.row].shortComment == "By Location" {
                searchOption = .Location
            }
            if let handlerBlock = self.showSearchResultHandlerBlock {                        
                handlerBlock(searchOption.rawValue, popUpArray[indexPath.row].courseName)
                self.dismiss(animated: true, completion: nil)
            }
        } else if buttonIndex == 2 {
            if let handlerBlock = self.showEnquiryDetailsHandlerBlock {                        
                self.dismiss(animated: true, completion: {
                    handlerBlock(self.popUpArray[indexPath.row].courseID)
                })
            }
        } else if buttonIndex == 3 {
            if let handlerBlock = self.showBookmarkDetailsHandlerBlock {                        
                self.dismiss(animated: true, completion: {
                    handlerBlock(self.popUpArray[indexPath.row].courseID)
                })
            }
        }
    }
}
