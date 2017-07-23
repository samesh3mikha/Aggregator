//
//  CompareViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 3/21/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftMessages
import Alamofire

//let baseUrl = "http://202.129.251.174:8089/api/main/"
let baseUrl = "http://192.168.1.11:8089/api/main/"


class CompareViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var compareBtn: RoundButton!
    @IBOutlet var holderView: UIView!
    @IBOutlet var TableView: UITableView!
   var bookMarkArray = [Courses]()
    
    var selectedIDs = [String]()
   
    
    var checked = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    self.navigationController?.isNavigationBarHidden = true
       
           }
    
    
    // MARK:PassData
    
    @IBOutlet weak var ComaprLbl: UILabel!
    @IBAction func compareBtnClicked(_ sender: Any) {        
        if let compareDetail = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController{
        _ = UINavigationController(rootViewController: compareDetail)
            if self.TableView.indexPathsForSelectedRows != nil{
                let selectedIndexPaths = selectedIDs.joined(separator: ",")
                compareDetail.compareListId = selectedIndexPaths
                print("selectedIndexPaths -->", selectedIndexPaths)
            }
            self.navigationController?.pushViewController(compareDetail, animated: false)
        }
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        
       
               self.checked.removeAll()
        self.selectedIDs.removeAll()
       
        compareBtn.isUserInteractionEnabled = true
        compareBtn.alpha = 0.5
        
        let pref = UserDefaults.standard
        if let decoded = pref.object(forKey: "userinfo")
            
        {
            let decodedUserinfo = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! UserInfo
            if !decodedUserinfo.access_token.isBlank
            {
                
                
                
                fetchBookmark(token: decodedUserinfo.access_token)
                
                
                
            }
        }
    }
   
    
    //MARK: Network
    
    func fetchBookmark(token : String) -> Void {
        
        popUpArray.removeAll()
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        statusHud.configureContent(title: "", body: "Fetching your data! Please wait..")
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 1)
        con.dimMode = .none
        
        
        
        SwiftMessages.show(config: con, view: statusHud)
        
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "user_course_bookmark",
            "data": [
                
                ["flag": "S"]
                
                
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
                        
                        self.bookMarkArray.removeAll()
                        
                        
                        if let responseArray = data["BOOKMARKLIST"].arrayObject
                        {
                            
                            
                            
                            let popData = responseArray as! [[String:AnyObject]]
                            
                            
                            for dict in popData
                            {
                                
                                                              
                                
                                
                                let d = Courses.init(course_id: "\(dict["institution_course_id"]!)", courseName: "\(dict["course_name"]!)", instituteName: "\(dict["institute_name"]!)", studyLevel: "", country: "", institutionType: "", image: "\(dict["institute_logo"]!)", isWishlisted: false, isEnquired: false, isBookmarked: false)
                                self.bookMarkArray.append(d)
                            }
                            
                            
                            for  i in  0...self.bookMarkArray.count - 1
                            {
                                self.checked.insert(false, at: i)
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
                    
                    
                    // other failures
                    
                }
                print(error)
                
            }
            
            
            
            
            
            
        }
        
        
        
    }
    
    
     //MARK: TABLEVIEW DELEGATE AND DATASOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
            return bookMarkArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
            return 7
            
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCellID")! as! campareTableViewCell
        
        //CHECK FOR TICK MARK
        
        if !checked[indexPath.section] && checked.count > 0 {
            cell.tickImage.isHidden = true
        } else  {
            cell.tickImage.isHidden = false
        }

        
        cell.courseName.text = bookMarkArray[indexPath.section].courseName
        cell.uniName.text = bookMarkArray[indexPath.section].instituteName
        cell.locationName.text = bookMarkArray[indexPath.section].instituteName
        cell.uniLogoImageview.sd_setImage(with: URL.init(string: bookMarkArray[indexPath.section].image), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
        
            return cell
            
        
        
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectionLimit = 3
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 1)
        con.dimMode = .none

        
        
        let cell = tableView.cellForRow(at: indexPath) as! campareTableViewCell
        
      
                if let index = selectedIDs.index(of: bookMarkArray[indexPath.section].course_id)
                {
                    cell.tickImage.isHidden = true
                    selectedIDs.remove(at: index)
                    print(index)
                    checked[indexPath.section] = false
                    
                }
                
            
            else if (selectedIDs.count < selectionLimit){
                cell.tickImage.isHidden = false
                checked[indexPath.section] = true
                selectedIDs.append(bookMarkArray[indexPath.section].course_id)
            }
        
        else
        
                {
                    statusHud.configureTheme(.warning)
                    statusHud.configureContent(title: "", body: "Please select three or less courses to compare")
                    SwiftMessages.show(config: con, view: statusHud)
        
        }
        
        
        if (selectedIDs.count <= selectionLimit && selectedIDs.count > 1)
        {
            compareBtn.isUserInteractionEnabled = true
            compareBtn.alpha = 1
            
        }
        
        else
        {
            compareBtn.isUserInteractionEnabled = false
            compareBtn.alpha = 0.5
        }
        print(selectedIDs)
    
    }

    

    

}
