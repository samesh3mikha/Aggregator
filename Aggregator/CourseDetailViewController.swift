//
//  CourseDetailViewController.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/21/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.


import UIKit
import SwiftMessages
import Alamofire
import SwiftyJSON


class CourseDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var courseNameLbl: UILabel!
    @IBOutlet weak var CourseDetailHeaderView: roundView!
    @IBOutlet weak var courseDetailLbl: UILabel!
    @IBOutlet weak var universityName: UILabel!
    @IBOutlet weak var CourseDetailTableview: UITableView!
    
    
       var collegeid: String = ""
       var courseName: String = ""
       var  myId: String = ""
       var detailArray = [SearchDeatils]()
       var subjectList = [SubjectDeatils]()
       var EntryReqLists = [EntryRequirementsDetails]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        CourseDetailTableview.delegate = self
        CourseDetailTableview.dataSource = self
        fetchCourseDetail(token: "", CourseID: "")
        self.navigationController?.navigationBar.isHidden = false
        CourseDetailTableview.rowHeight = UITableViewAutomaticDimension
        CourseDetailTableview.estimatedRowHeight = 75

         }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    @IBAction func EnquiryNowBtn(_ sender: Any) {
        
        let EnquiryViewController = self.storyboard?.instantiateViewController(withIdentifier: "EnquiryFormViewController") as! EnquiryFormViewController
        self.navigationController?.pushViewController(EnquiryViewController, animated: true)
         EnquiryViewController.CourseName = self.courseNameLbl.text!
         EnquiryViewController.universityName = self.universityName.text!
        
          }
    
    
    override func viewWillAppear(_ animated: Bool) {
    CourseDetailTableview.reloadData()
        self.navigationItem.title = "CourseDetails"
    }
    
    
    func fetchCourseDetail(token : String, CourseID : String ) -> Void {
        SwiftMessages.hideAll()
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        statusHud.configureTheme(.success)
        statusHud.id = "statusHud"
        var con = SwiftMessages.Config()
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 0.5)
        con.dimMode = .none
        //   let id = String(courseArray[sender.tag].course_id)!
        var token = ""
        let courseId = myId
        let decodedUserinfo = self.getUserInfo()
        if !decodedUserinfo.access_token.isBlank
        {
        token = "bearer " + decodedUserinfo.access_token
            
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "institution_course",
            "data": [
                [ "flag":"E", "Institution_course_id": courseId]
             ]
        ]
        
        Alamofire.request(baseUrl + "Unauthorizedata", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                let json = JSON(value)
                 var data = JSON(response.result.value!)
                print("data ==", data)
                
                if let responseArray = data["rto-form"].arrayObject
                {
                    courseArray.removeAll()
                    autoSuggestionArray.removeAll()
                    allAutosuggestionArray.removeAll()
                    countryAutosuggestionArray.removeAll()
                    
                    if let resultDicts = responseArray as? [[String:AnyObject]] {
                        if resultDicts.count > 0 {
                            let dict = resultDicts.first 
                            let dataParser = DataParser(dataDictionary: dict!)                        
                            let detail =  SearchDeatils.init(
                                institution_course_id:  dataParser.intFor(key: "institution_course_id"), 
                                course_id:              dataParser.intFor(key: "course_id"), 
                                course_name:            dataParser.stringFor(key: "course_name"),
                                institute_id:           dataParser.intFor(key: "institute_id"),
                                institute_name:         dataParser.stringFor(key: "institute_name"),
                                phone:                  dataParser.stringFor(key: "phone"),
                                institute_image:        dataParser.stringFor(key: "institute_image"),
                                institute_logo:         dataParser.stringFor(key: "institute_logo"),
                                gps_lattitude:          dataParser.intFor(key: "gps_lattitude"),
                                gps_longitude:          dataParser.intFor(key: "gps_longitude"),
                                email_address:          dataParser.stringFor(key: "email_address"), 
                                website:                dataParser.stringFor(key: "website"),
                                about_us:               dataParser.stringFor(key: "about_us"),
                                course_description:     dataParser.stringFor(key: "course_description"),
                                faculty_name:           dataParser.stringFor(key: "faculty_name"),
                                course_code:            dataParser.stringFor(key: "course_code"),
                                active:                 dataParser.boolFor(key: "active"), 
                                institute_full_address: dataParser.stringFor(key: "institute_full_address"),
                                study_level_name:       dataParser.stringFor(key: "study_level_name"),
                                country:                dataParser.stringFor(key: "country"),
                                institution_type:       dataParser.stringFor(key: "institution_type") 
                            )
                            self.detailArray.append(detail)
                            
                            self.courseNameLbl.text = detail.course_name
                            self.courseDetailLbl.text = detail.course_description
                            self.universityName.text = detail.institute_name
                            self.universityName.text = detail.course_name
                        }
                    }
                    
                }
                    
                    
                if let responseArray = data["INSTITUTION_COURSE_SUBJECT"].arrayObject
                     {
                        let resultDicts = responseArray as! [[String:AnyObject]]
                        
                        for dict in resultDicts
                        {

                        
                        let subjdetail = SubjectDeatils.init(subject_id: dict["subject_id"]! as! Int, subject_name: dict["subject_name"]! as! String)
                        
                            self.subjectList.append(subjdetail)
                            
                        }
                        print("self.subjectList --- ", self.subjectList)
                        
                    }
                            if  let responseArray = data["ENTRY_REQUIREMENTS"].arrayObject
                         {
                            let resultDicts = responseArray as! [[String:AnyObject]]
                            
                            for dict in resultDicts
                            {
                                let Entrydetail = EntryRequirementsDetails.init(entry_requirement_type: dict["entry_requirement_type"]! as! Int , ref_dtl_name: dict["ref_dtl_name"]! as! String , created_by1: dict["created_by1"]! as! String , active:  dict["active"]! as! Bool, created_by: dict["created_by"]! as! Int , institution_course_id: dict["institution_course_id"]! as! Int, created_on1: dict["created_on1"]! as! String  , entry_description: dict["entry_description"]! as! String , created_on: dict["created_on"]! as! String , ref_mst_id: dict["ref_mst_id"]! as! Int, entry_requirement_id: dict["entry_requirement_id"]! as! Int, COURSEREQUIREMENT: dict["COURSEREQUIREMENT"]! as! Int, entry_type_name: dict["entry_type_name"]! as! String, ref_dtl_id: dict["ref_dtl_id"]! as! Int, ref_dtl_code: dict["ref_dtl_code"]! as! String)
                                
                               self.EntryReqLists.append(Entrydetail)
                                    }
                   
                          print("self.EnquiryList --- ", self.EntryReqLists)
                    
                }
                
            case .failure(let error):
                print(error)
                
            }
              self.CourseDetailTableview.reloadData()
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if section == 0 {
            rowCount = subjectList.count
                 }
        if section == 1 {
            rowCount = EntryReqLists.count
            
        }
        return rowCount
            }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
                   return UITableViewAutomaticDimension
        

    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//                return UITableViewAutomaticDimension
//    }
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitles = ["SUBJECTS","Entry Requirements/Description"]
        if section < headerTitles.count {
            return headerTitles[section]
        }
        
        return nil
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailTableViewCell", for: indexPath) as! CourseDetailTableViewCell
        let row = indexPath.row
        let section = indexPath.section
       
        
        if section == 0
        {
            cell.label1.text = subjectList[indexPath.row].subject_name
            cell.label2.isHidden = true
            cell.label2.text = ""
            
        }
        else
        {
            if section == 1{
                cell.label1.text = EntryReqLists[indexPath.row].ref_dtl_name
                cell.label2.isHidden = false
                cell.label2.text = EntryReqLists[indexPath.row].entry_description
            }
        }
        
     return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = appGreenColor
        header.textLabel?.font = UIFont(name: Style.quicksand_medium, size: 15)!
       
    }
    
    
   }







    
    
    

   

