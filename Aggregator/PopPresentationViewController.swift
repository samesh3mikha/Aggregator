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

var popUpArray = [PopupViewData]()
class PopPresentationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var TableView: UITableView!
    var buttonIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.delegate = self
        self.TableView.dataSource = self
        
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
            actionName = "user_course_wish"
            expectedKey = "WISHLIST"
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
                        
                        
                        if let responseArray = data[expectedKey].arrayObject
                        {
                            
                            
                            
                            let popData = responseArray as! [[String:AnyObject]]
                            
                            
                            for dict in popData
                            {
                                var shortCmnt = ""
                                
                                if self.buttonIndex == 2
                                {
                                 shortCmnt = "\(dict["shortcomment"]!)"
                                }
                                
                                else
                                {
                                    shortCmnt = ""
                                }
                                
                                let e = PopupViewData.init(courseID: "\(dict["institution_course_id"]!)" ,courseName: "\(dict["course_name"]!)", logo: "\(dict["institute_logo"]!)", shortComment: shortCmnt )
                                popUpArray.append(e)
                            }
                            
                            self.TableView.reloadData()
                            
                            
                            
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
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //SwiftMessages.hideAll()
        if buttonIndex == 3 {
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "bookmark&wishlistid")! as! BookMark_WishTableViewCell
            //set the data here
            cell.courseNameLbl.text = popUpArray[indexPath.row].courseName
            cell.logoImageview.sd_setImage(with: URL.init(string: popUpArray[indexPath.row].logo), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            return cell
            
            
            
            
        }
        else {
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "enquiryid")! as! EnquiryTableViewCell
            
            cell.courseNameLbl.text = popUpArray[indexPath.row].courseName
            
            cell.logoImageView.sd_setImage(with: URL.init(string: popUpArray[indexPath.row].logo), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            //set the data here
            return cell
        }
        
    }
    
    
    
    
    
}
