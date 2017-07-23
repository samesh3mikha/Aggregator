//
//  MainViewController.swift
//  page
//
//  Created by Websutra MAC 2 on 7/5/17.
//  Copyright © 2017 Websutra MAC 2. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages
import SwiftyJSON







//let baseUrl = "http://202.129.251.174:8089/api/main/"
class MainViewController: UIViewController {
    


    @IBOutlet weak var pagedContainerView: UIView!    
   // @IBOutlet weak var closeView: UIView!

    var compareListId = String()
    var arrayOfCourses = [BasicComparedatas]()
    var pageIndex:Int! = 0
    
       override func viewDidLoad() {
        super.viewDidLoad()      
        self.definesPresentationContext = true
        self.tabBarController?.tabBar.isHidden = true
        self.hidesBottomBarWhenPushed = true
        print("compareListId --", compareListId)
        print("arrayOfCourses --", arrayOfCourses)

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
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
       
    func fetchBookmark(token : String){
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        statusHud.configureContent(title: "", body: "Fetching your data! Please wait..")
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 1)
        con.dimMode = .none
        
        SwiftMessages.show(config: con, view: statusHud)
        SwiftMessages.hideAll()
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        let params : Parameters = [
            "actionname": "course_compare",
            "data": [
                ["flag": "S"],
                ["institution_course_id": compareListId],
            ]
        ]
        print("params -- ", params)
        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                case .success(let value):
                
                let data = JSON(value)
                print("data.count --", data.count)
                
                if let uia = data["COURSE_1"].arrayObject
                {
                    print("uia == ", uia)
                    let resultDicts = uia as! [[String:AnyObject]]
                    
                    for dict in resultDicts
                    {
                        
                                                    let d = BasicComparedatas.init(institution_course_id: "\(dict["institutecourseid"]!)", course_name: "\(dict["course_name"]!)", full_duration: "\(dict["institute_name"]!)", entry_requirements:  "\(dict["entry_requirements"]!)", fee_detail: "\(dict["fee_detail"]!)", course_structure: "\(dict["course_structure"]!)", redirect_institution: "\(dict["redirect_institution"]!)" , institute_name: "\(dict["institute_name"]!)", subjects: "\(dict["subjects"]!)", redirect_course:  "\(dict["redirect_course"]!)",is_international_student: false)
                            self.arrayOfCourses.append(d)
                        
                       
                            
                        
                    }
                    
//
                }
                
                if let uia = data["COURSE_2"].arrayObject
                    
                {
                    
                    
                    print(uia)
                    let resultDicts = uia as! [[String:AnyObject]]
                    
                    for dict in resultDicts
                    {
                        
                        let d = BasicComparedatas.init(institution_course_id: "\(dict["institutecourseid"]!)", course_name: "\(dict["course_name"]!)", full_duration: "\(dict["institute_name"]!)", entry_requirements:  "\(dict["entry_requirements"]!)", fee_detail: "\(dict["fee_detail"]!)", course_structure: "\(dict["course_structure"]!)", redirect_institution: "\(dict["redirect_institution"]!)" , institute_name: "\(dict["institute_name"]!)", subjects: "\(dict["subjects"]!)", redirect_course:  "\(dict["redirect_course"]!)",is_international_student: false)
                        self.arrayOfCourses.append(d)
                        print(self.arrayOfCourses)
                        
                        
                        
                        
                    }
                    
                    //
                }
                
                if let uia = data["COURSE_3"].arrayObject
                    
                {
                    
                    
                    print(uia)
                    let resultDicts = uia as! [[String:AnyObject]]
                    
                    for dict in resultDicts
                    {
                        
                        let d = BasicComparedatas.init(institution_course_id: "\(dict["institutecourseid"]!)", course_name: "\(dict["course_name"]!)", full_duration: "\(dict["institute_name"]!)", entry_requirements:  "\(dict["entry_requirements"]!)", fee_detail: "\(dict["fee_detail"]!)", course_structure: "\(dict["course_structure"]!)", redirect_institution: "\(dict["redirect_institution"]!)" , institute_name: "\(dict["institute_name"]!)", subjects: "\(dict["subjects"]!)", redirect_course:  "\(dict["redirect_course"]!)",is_international_student: false)
                        self.arrayOfCourses.append(d)
                        print(self.arrayOfCourses)
                     
                        
                        
                        
                        
                    }
                    
                    //
                }
                print("self.arrayOfCourses --", self.arrayOfCourses)

                if let responseStatus = data["STATUS"].arrayObject
                {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let s = status["STATUS"] as! String
                    
                    if s == "SUCCESS"
                    {
                        self.dismiss(animated: false, completion: nil)
                        statusHud.configureContent(title: "", body: "Fetching complete")
                        self.addChildVC()
                        
//                                             
                    }
                        
                    else
                    {
                        if status["MESSAGE"] as! String == "SESSION EXPIRED"
                        {
                            self.catchSessionExpire()
                            statusHud.configureTheme(.error)
                            statusHud.configureContent(title: "", body: status["MESSAGE"] as! String + ". PLEASE LOGIN")
                           
                        }
                            
                        else
                        {
                            statusHud.configureTheme(.error)
                            statusHud.configureContent(title: "", body: status["MESSAGE"] as! String)
                        }
                        
                        
                        
                    }
                }
                
                
            case .failure(let error):
                print(error)
                if let err = error as? URLError, err.code == .notConnectedToInternet{
                    // no internet connection
                    
                    statusHud.configureTheme(.error)
                    statusHud.configureContent(title: "" , body: error.localizedDescription)
                    
                    
                }
                
                
                
            }
            
            SwiftMessages.show(config: con, view: statusHud)
            
                     
            
            
        }
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    if segue.identifier == "segueToPageVC"{
        if let destVC = segue.destination as? PageViewController{
            destVC.compareListId = [self.compareListId]
            
            print(self.arrayOfCourses)
        destVC.arrayOfCourses = self.arrayOfCourses
       
                   }
        }
    

    
    }
    
    
    func addChildVC(){
        
        if let pageVC = self.storyboard?.instantiateViewController(withIdentifier: "pagecontrollerVCID") as? PageViewController{
            self.addChildViewController(pageVC)
            pageVC.arrayOfCourses = self.arrayOfCourses
            pageVC.compareListId = [self.compareListId]
            self.pagedContainerView.addSubview(pageVC.view)
            self.constrainViewEqual(holderView: self.pagedContainerView, view: pageVC.view)
            pageVC.didMove(toParentViewController: self)
        }
        
    }
    
    
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
    
    
    
    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
//    {
//        var index = (viewController as! TableViewController).pageIndex
//        
//        if (index == 0) || (index == NSNotFound) {
//            return nil
//        }
//        
//        index -= 1
//        
//        return viewControllerAtIndex(index: index)
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
//    {
//        var index = (viewController as! TableViewController).pageIndex
//        
//        if index == NSNotFound {
//            return nil
//        }
//        
//        index += 1
//        
//        if (index == self.arrayOfCourses.count) {
//            return nil
//        }
//        
//        return viewControllerAtIndex(index: index)
//    }
//    
//    func viewControllerAtIndex(index: Int) -> TableViewController?
//    {
//        if self.arrayOfCourses.count == 0 || index >= self.arrayOfCourses.count
//        {
//            return nil
//        }
//        
//        // Create a new view controller and pass suitable data.
//        let pageContentViewController = TableViewController()
//        pageContentViewController.pageIndex = index
//        currentIndex = index
//        
//        return pageContentViewController
//    }
//    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
//    {
//        return self.arrayOfCourses.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
//    {
//        return 0
//    }
//    
//    
//    
    

    
    

    
      }

