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

class CompareViewController: UIViewController, UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var compareBtn: RoundButton!
    @IBOutlet var holderView: UIView!
    @IBOutlet var TableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var ComaprLbl: UILabel!

    var bookMarkArray = [Courses]()
    var selectedIDs = [String]()
    var fetchingData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compareBtn.isUserInteractionEnabled = false
        compareBtn.alpha = 0.5
        self.tabBarController?.delegate = self
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            fetchData()
        }
    }
    
    func fetchData() {
        if fetchingData {
            return
        }
        holderView.isHidden = true
        TableView.isHidden = true
        backgroundImageView.isHidden = false
        let accessToken = DataSynchronizer.getAccessToken()
        if !accessToken.isBlank {
            backgroundImageView.isHidden = true
            holderView.isHidden = false
            TableView.isHidden = false
            selectedIDs.removeAll()
            fetchBookmark(token: accessToken)
        }
    }

    @IBAction func compareBtnClicked(_ sender: Any) {
        addChildVC()
    }

    func addChildVC(){
        if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            _ = UINavigationController(rootViewController: mainVC)
            if selectedIDs.count > 0 {
                mainVC.bookmarkedCourseIDs = selectedIDs
                self.navigationController?.pushViewController(mainVC, animated: false)
            }
        }
    }

    //MARK: Network
    
    func fetchBookmark(token : String) -> Void {
        fetchingData = true
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
            self.fetchingData = false
            switch response.result
            {
                
            case .success(let value):
                let json = JSON(value)
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
        if selectedIDs.contains(bookMarkArray[indexPath.section].course_id) {
            cell.tickImage.isHidden = false
        } else {
            cell.tickImage.isHidden = true
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
        
      
        if let index = selectedIDs.index(of: bookMarkArray[indexPath.section].course_id) {
            cell.tickImage.isHidden = true
            selectedIDs.remove(at: index)
        } else if (selectedIDs.count < selectionLimit) {
            cell.tickImage.isHidden = false
            selectedIDs.append(bookMarkArray[indexPath.section].course_id)
        } else {
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
        print("selectedIDs ---", selectedIDs)
        
    }

    

    

}
