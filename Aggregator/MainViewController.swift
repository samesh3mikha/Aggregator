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
    @IBOutlet weak var compareingCountLabel: UILabel!
    @IBOutlet weak var pagedContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var bookmarkedCourseIDs = [String]()
    var arrayOfCourses = [BasicComparedatas]()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.definesPresentationContext = true
        self.tabBarController?.tabBar.isHidden = true
        self.hidesBottomBarWhenPushed = true
        self.compareingCountLabel.text = "Comparing \(self.bookmarkedCourseIDs.count) Courses."

        let accessToken = DataSynchronizer.getAccessToken()
        if !accessToken.isBlank {
            arrayOfCourses.removeAll()
            fetchBookmark(token: accessToken)
        }
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    func fetchBookmark(token : String) {
        showStatusHUD(title: "", details: "Fetching your data! Please wait..", theme: .success, duration: .seconds(seconds: 0.5))
                
        let params : Parameters = [
            "actionname": "course_compare",
            "data": [
                ["flag": "S"],
                ["institution_course_id": bookmarkedCourseIDs.joined(separator: ",")],
            ]
        ]
        
        DataSynchronizer.syncData(params: params, completionBlock: { [weak self] (isRequestASuccess, message, data) in
            guard let weakself = self else {
                return
            }
            if isRequestASuccess {
                if let responseArray = data["COURSE_1"].arrayObject as? [[String:AnyObject]] {
                    if responseArray.count > 0 {
                        weakself.addCourseData(data: responseArray.first!)
                    }
                }
                if let responseArray = data["COURSE_2"].arrayObject as? [[String:AnyObject]] {
                    if responseArray.count > 0 {
                        weakself.addCourseData(data: responseArray.first!)
                    }
                }
                if let responseArray = data["COURSE_3"].arrayObject as? [[String:AnyObject]] {
                    if responseArray.count > 0 {
                        weakself.addCourseData(data: responseArray.first!)
                    }
                }
                weakself.addChildVC()
            } else {
                weakself.showStatusHUD(title: "Error!", details: message, theme: .error, duration: .seconds(seconds: 2))
            }
        })        
    }
    
    func addCourseData(data: [String: AnyObject]) {
        let dataParser = DataParser(dataDictionary: data)
        let course = BasicComparedatas(
            institution_course_id:      dataParser.stringFor(key: "institutecourseid"), 
            course_name:                dataParser.stringFor(key: "course_name"), 
            full_duration:              dataParser.stringFor(key: "full_duration"), 
            entry_requirements:         dataParser.stringFor(key: "entry_requirements"), 
            fee_detail:                 dataParser.stringFor(key: "fee_detail"), 
            course_structure:           dataParser.stringFor(key: "course_structure"), 
            redirect_institution:       dataParser.stringFor(key: "redirect_institution"), 
            institute_name:             dataParser.stringFor(key: "institute_name"), 
            subjects:                   dataParser.stringFor(key: "subjects"), 
            redirect_course:            dataParser.stringFor(key: "redirect_course"), 
            is_international_student:   dataParser.boolFor(key: "is_international_student") ? true : false
        )
        arrayOfCourses.append(course)
    }
    
    
    func addChildVC(){
        if let pageVC = self.storyboard?.instantiateViewController(withIdentifier: "pagecontrollerVCID") as? PageViewController{
            addChildViewController(pageVC)
            pageVC.arrayOfCourses = arrayOfCourses
            pagedContainerView.addSubview(pageVC.view)
            constrainViewEqual(holderView: pagedContainerView, view: pageVC.view)
            pageVC.currentPageUpdaterBlock = { [weak self] (currentPage) in
                guard let weakself = self else {
                    return
                }
                weakself.pageControl.currentPage = currentPage
            }
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
    
}

