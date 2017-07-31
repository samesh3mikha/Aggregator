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

        let pref = UserDefaults.standard
        if let decoded = pref.object(forKey: "userinfo")
        {
            let decodedUserinfo = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! UserInfo
            if !decodedUserinfo.access_token.isBlank
            {
                self.arrayOfCourses.removeAll()
                fetchBookmark(token: decodedUserinfo.access_token)
            }
        }
        
//        mockData()
//        addChildVC()
    }
    
    func mockData() {
        let course1: [String: Any] =  [
            "sno": 1,
            "institutecourseid": 5,
            "course_name": "Advanced Diploma of Engineering",
            "institute_name": "Federation University Australia",
            "full_duration": "4 Year",
            "institute_logo": "http://192.168.1.11:8089/images/federationuniversitylogo.jpg",
            "course_code": "ADoE",
            "course_structure": "Full-time 2 years, Part-time 4 years\n\nNote: Programs may change as training packages are updated.",
            "is_international_student": "YES",
            "is_wish_list": 5,
            "redirect_institution": "InstitutionDetail?institute_id=1",
            "redirect_course": "SearchResultLanding?institutioncourseid=5",
            "fee_detail": "<ul> <li><strong>Fall</strong> <ul><li>AUD 525.00(Domestic)</li>  <li>AUD 1075.00(International)</li></ul></li> <li><strong>Spring</strong> <ul><li>AUD 5870.00(Domestic)</li>  <li>AUD 9090.00(International)</li></ul></li></ul>",
            "entry_requirements": "<ul><li> Australian Student visa application can be processed in 2 ways, Electronically (E-visa) & Manually (Paper base visa) under the guidance of experienced Australia immigration experts at EDWISE you can certainly bid adieu to all worrisome tasks involved in your visa procedure. \"Edwise are the E-visa lodgment agent and AAERI member\" \n\nWhere to Apply: If an Applicant wants to apply online, then e-visa is lodged directly from the Australian High Commission's online gateway which is assessed in Adelaide, Australia; If an Applicant wants to apply paper base visa then an applicant can submit their visa application at any of the VFS Application Centers available in 10 cities Process:\n\na.How many days prior a student can apply for visa.\nIt is adviced to file for Visa 3 months in Advance to avoid any delay\n\nb. Document Checklist The Documents required for Visa has to be in 5 sets \n1.Personal Details forms & Information\n2.All Academics - Originals \n3.All Financial Documents - Originals \n4.All Academic Documents - Notary Attested 5.\tAll financial documents - Notary Attested \n\nc.Visa Application Fees The Visa application fees currently are AUD $ 540. (Subject to change)\n\nd.Processing Time The processing time required by the high is 8-12 weeks English Ability Requirements IELTS is mandatory to obtain Australian Student Visa For more information you can meet the Visa counselor at Edwise branch. (Updated till 1st June 2010) <li>English - English for Academic Purposes (EAP) \n(Level 4): achieved. <li>Latest 2 Passport size photo must be uploaded. <li>Latest CV must be uploaded. <li>Pearson Test of English (PTE): \nOverall score of 42-49 (no section score less than 40) <li>Standard X Mark sheet, Standard XII Mark shee,t Bachelor Degree / Provisional Certificate with mark sheet . <li>TOEFL:Overall score of 55.\nSection scores no less than:\nListening: 9 \nSpeaking: 16\nReading: 10 \nWriting: 18 <li>University of Cambridge - Advanced\n\n\n\n\n\n(CAE): Total score of 47 VU</ul>",
            "subjects": "<ul><li> Computer Applications <li>Environmental issues <li>Management <li>Management <li>Management <li>Management <li>Management <li>Management <li>Management <li>Materials Science <li>Mathematics <li>Steel structures <li>Structural mechanics <li>Surveying <li>test1</ul>"
        ]
        
        let course2: [String: Any] =  [
            "sno": 2,
            "institutecourseid": 8,
            "course_name": "Digital Marketing Certificate",
            "institute_name": "Federation University Australia",
            "full_duration": "5 year",
            "institute_logo": "http://192.168.1.11:8089/images/federationuniversitylogo.jpg",
            "course_code": "DigiMarkt",
            "course_structure": "4 semesters:\n4 weeks of study, 8-10 hours/week",
            "is_international_student": "YES",
            "is_wish_list": 4,
            "redirect_institution": "InstitutionDetail?institute_id=1",
            "redirect_course": "SearchResultLanding?institutioncourseid=8",
            "fee_detail": "<ul></ul>",
            "entry_requirements": "<ul><li> English - English for Academic Purposes (EAP) (Level 4): achieved. <li>IELTS (Academic module): \nOverall score of 5.5 (no band less than 5.0) <li>Pearson Test of English (PTE): \nOverall score of 42-49 (no section score less than 40) <li>Standard X Mark sheet\nStandard XII Mark sheet\nBachelor Degree / Provisional Certificate with mark sheet <li>Student visa is valid till a month after the corse completion.\nCourse requirements must be satisfied and valid enrolment maintained.\nStudents may not work more than 20 hours per week while the course is in session.\nStudents must maintain health insurance while in Australia. <li>TOEFL:Overall score of 55.\nSection scores no less than:\nListening: 9 \nSpeaking: 16\nReading: 10 \nWriting: 18 <li>University of Cambridge - Advanced (CAE): Total score of 47 VU\n</ul>",
            "subjects": "<ul><li> Digital Analytics for Marketing Professionals: Marketing Analytics in Practice <li>Digital Analytics for Marketing Professionals: Marketing Analytics in Theory <li>Digital Marketing Capstone <li>Digital Marketing Channels: Planning <li>Digital Marketing Channels: The Landscape <li>Marketing in a Digital World</ul>"
        ]
        let course3: [String: Any] = [
            "sno": 3,
            "institutecourseid": 9,
            "course_name": "Diploma of Retail Leadership",
            "institute_name": "Federation University Australia",
            "full_duration": "3 years",
            "institute_logo": "http://192.168.1.11:8089/images/federationuniversitylogo.jpg",
            "course_code": "DipRetLead",
            "course_structure": "2 years course",
            "is_international_student": "YES",
            "is_wish_list": 2,
            "redirect_institution": "InstitutionDetail?institute_id=1",
            "redirect_course": "SearchResultLanding?institutioncourseid=9",
            "fee_detail": "<ul></ul>",
            "entry_requirements": "<ul><li> English - English for Academic Purposes (EAP) (Level 4): achieved. <li>Evidence of sufficient funds to cover tuition, travel and living costs. From July 2016, the amount you need to prove you have for living costs (separate from tuition and travel) is set at AU$19,830 (~US$15,170) for a year. If you have dependents (such as a spouse and children), you will also need to show evidence of being able to cover living costs for them, including school fees. Alternatively, you can show evidence that your spouse or parents are willing to support you and that they earn at least AU$60,000 (~US$45,850) a year. <li>IELTS (Academic module): Overall score of 5.5 (no band less than 5.0) <li>Pearson Test of English (PTE): \nOverall score of 42-49 (no section score less than 40) <li>Standard X Mark sheet\nStandard XII Mark sheet\nBachelor Degree / Provisional Certificate with mark shee <li>TOEFL:Overall score of 55.\nSection scores no less than:\nListening: 9 \nSpeaking: 16\nReading: 10 \nWriting: 18 <li>University of Cambridge - Advanced (CAE): Total score of 47 VU</ul>",
            "subjects": "<ul><li> LEADERSHIP <li>PROFESSIONAL DEVELOPMENT <li>RECRUITMENT <li>RETAIL PROFIT <li>STRATEGIC PLANNING</ul>"
        ]
        self.arrayOfCourses.append(basicCompareData(dict: course1))
        if Int(arc4random_uniform(2)) == 0 {
            self.arrayOfCourses.append(basicCompareData(dict: course2))
        } else {
            self.arrayOfCourses.append(basicCompareData(dict: course3))
        }
    }    
    
    func basicCompareData(dict: [String: Any]) -> BasicComparedatas {
        return BasicComparedatas.init(institution_course_id: "\(dict["institutecourseid"]!)", course_name: "\(dict["course_name"]!)", full_duration: "\(dict["institute_name"]!)", entry_requirements:  "\(dict["entry_requirements"]!)", fee_detail: "\(dict["fee_detail"]!)", course_structure: "\(dict["course_structure"]!)", redirect_institution: "\(dict["redirect_institution"]!)" , institute_name: "\(dict["institute_name"]!)", subjects: "\(dict["subjects"]!)", redirect_course:  "\(dict["redirect_course"]!)",is_international_student: false)
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
        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                case .success(let value):
                
                let data = JSON(value)
                
                if let uia = data["COURSE_1"].arrayObject
                {
                    let resultDicts = uia as! [[String:AnyObject]]
                    
                    for dict in resultDicts
                    {
                        let d = BasicComparedatas.init(institution_course_id: "\(dict["institutecourseid"]!)", course_name: "\(dict["course_name"]!)", full_duration: "\(dict["institute_name"]!)", entry_requirements:  "\(dict["entry_requirements"]!)", fee_detail: "\(dict["fee_detail"]!)", course_structure: "\(dict["course_structure"]!)", redirect_institution: "\(dict["redirect_institution"]!)" , institute_name: "\(dict["institute_name"]!)", subjects: "\(dict["subjects"]!)", redirect_course:  "\(dict["redirect_course"]!)",is_international_student: false)
                        self.arrayOfCourses.append(d)
                    }
                }
                
                if let uia = data["COURSE_2"].arrayObject
                    
                {
                    let resultDicts = uia as! [[String:AnyObject]]
                    
                    for dict in resultDicts
                    {
                        
                        let d = BasicComparedatas.init(institution_course_id: "\(dict["institutecourseid"]!)", course_name: "\(dict["course_name"]!)", full_duration: "\(dict["institute_name"]!)", entry_requirements:  "\(dict["entry_requirements"]!)", fee_detail: "\(dict["fee_detail"]!)", course_structure: "\(dict["course_structure"]!)", redirect_institution: "\(dict["redirect_institution"]!)" , institute_name: "\(dict["institute_name"]!)", subjects: "\(dict["subjects"]!)", redirect_course:  "\(dict["redirect_course"]!)",is_international_student: false)
                        self.arrayOfCourses.append(d)
                        
                        
                        
                        
                    }
                    
                    //
                }
                
                if let uia = data["COURSE_3"].arrayObject
                    
                {
                    
                    
                    let resultDicts = uia as! [[String:AnyObject]]
                    
                    for dict in resultDicts
                    {
                        
                        let d = BasicComparedatas.init(institution_course_id: "\(dict["institutecourseid"]!)", course_name: "\(dict["course_name"]!)", full_duration: "\(dict["institute_name"]!)", entry_requirements:  "\(dict["entry_requirements"]!)", fee_detail: "\(dict["fee_detail"]!)", course_structure: "\(dict["course_structure"]!)", redirect_institution: "\(dict["redirect_institution"]!)" , institute_name: "\(dict["institute_name"]!)", subjects: "\(dict["subjects"]!)", redirect_course:  "\(dict["redirect_course"]!)",is_international_student: false)
                        self.arrayOfCourses.append(d)
                     
                        
                        
                        
                        
                    }
                    
                    //
                }

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
            if segue.destination is PageViewController {
//                destVC.compareListId = [self.compareListId]
//                destVC.arrayOfCourses = self.arrayOfCourses           
            }
        }
    }
    
    
    func addChildVC(){
        if let pageVC = self.storyboard?.instantiateViewController(withIdentifier: "pagecontrollerVCID") as? PageViewController{
            self.addChildViewController(pageVC)
            pageVC.arrayOfCourses = self.arrayOfCourses
            pageVC.bookmarkedCourseIDs = [self.compareListId]
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

