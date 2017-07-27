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

var popUpArray = [PopupViewData]()
class PopPresentationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var buttonIndex = 1
    var showSearchResultHandlerBlock: ShowSearchResultHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let pref = UserDefaults.standard
        if let decoded = pref.object(forKey: "userinfo")
            
        {
            let decodedUserinfo = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! UserInfo
            if !decodedUserinfo.access_token.isBlank
            {
                
                
                
                fetchPopData(token: decodedUserinfo.access_token)
                
                
                
            }
        }
        
        
        
        
    }
    
    //MARK: Network
    
    
    func fetchPopData(token : String) -> Void {
        
        popUpArray.removeAll()
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        statusHud.configureContent(title: "", body: "Fetching your data! Please wait..")
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 1)
        con.dimMode = .none
        
        
        
        SwiftMessages.show(config: con, view: statusHud)
        
        
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
        
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": actionName,
            "data": [
                
                ["flag": flag]
                
                
            ]
        ]
        
        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                
                
                let data = JSON(response.result.value!)
                
                if let responseStatus = data["STATUS"].arrayObject
                {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let s = status["STATUS"] as! String
                    
                    if s == "SUCCESS"
                    {
                        //self.dismiss(animated: false, completion: nil)
                        if let responseArray = data[expectedKey].arrayObject {
                            let popData = responseArray as! [[String:AnyObject]]
                            for dict in popData {
                                var shortCmnt = ""
                                if self.buttonIndex == 2 {
                                    shortCmnt = "\(dict["shortcomment"]!)"
                                } else {
                                    shortCmnt = ""
                                }
                                var e: PopupViewData? = nil
                                if self.buttonIndex == 1 {
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
                                } else {
                                    e = PopupViewData.init(courseID: "\(dict["institution_course_id"]!)" ,courseName: "\(dict["course_name"]!)", logo: "\(dict["institute_logo"]!)", shortComment: shortCmnt )
                                }
                                popUpArray.append(e!)
                            }
                            self.tableView.reloadData()
                        }
                        
                    }
                        
                    else
                    {
                        
                        if status["MESSAGE"] as! String == "SESSION EXPIRED"
                        {
                            self.catchSessionExpire()
                            statusHud.configureTheme(.error)
                            statusHud.configureContent(title: "", body: status["MESSAGE"] as! String + ". PLEASE LOGIN")
                            self.dismissModalStack(animated: true, completion: nil)
                            
                        }
                        
                        else {
                        statusHud.configureTheme(.error)
                        statusHud.configureContent(title: "" , body: status["MESSAGE"] as! String)
                        
                        }
                    }
                }
                
                
            case .failure(let error):
                if let err = error as? URLError, err.code == .notConnectedToInternet{
                    // no internet connection
                    
                    statusHud.configureTheme(.error)
                    statusHud.configureContent(title: "" , body: error.localizedDescription)
                    self.removeFromParentViewController()
                    
                    
                } else {
                    
                    
                                      
                }
                print(error)
                
            }
            
            
            
            
            
            
        }
        
        
        
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
            return 70
        }
        return 100
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //SwiftMessages.hideAll()
        if buttonIndex == 3 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "bookmark&wishlistid")! as! BookMark_WishTableViewCell
            //set the data here
            cell.courseNameLbl.text = popUpArray[indexPath.row].courseName
            cell.logoImageview.sd_setImage(with: URL.init(string: popUpArray[indexPath.row].logo), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            return cell
        } else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "enquiryid")! as! EnquiryTableViewCell
            
            cell.courseNameLbl.text = popUpArray[indexPath.row].courseName
            if buttonIndex == 1 {
                cell.enquiryDetail.text = popUpArray[indexPath.row].shortComment
                cell.itemID = popUpArray[indexPath.row].courseID
                cell.deleteItemHandlerBlock = { [weak cell] in
                    self.deleteFavoriteSearch(favSearchID: (cell?.itemID)!)
                }
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
            }
    }
    
    
    // Delete Favorite Search By ID
    func deleteFavoriteSearch(favSearchID: String) {
        var accessToken = ""
        let pref = UserDefaults.standard
        if let decoded = pref.object(forKey: "userinfo") {
            let decodedUserinfo = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! UserInfo
            if !decodedUserinfo.access_token.isBlank {
                accessToken = decodedUserinfo.access_token
            } else {
                return
            }
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
                ["flag": "D"],
                ["favorite_search_id": favSearchID]
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):                
                let data = JSON(value)
                if let responseStatus = data["STATUS"].arrayObject {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let s = status["STATUS"] as! String                    
                    if s == "SUCCESS" {
                        self.fetchPopData(token: accessToken)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
    
}
