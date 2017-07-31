//
//  EnquiryFormViewController.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/18/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages

class EnquiryFormViewController: UIViewController {

    @IBOutlet weak var emquiryText: UITextView!
    @IBOutlet weak var firstNameLbl: CustomBorderLabel!
   
    @IBOutlet weak var lastNameLbl: CustomBorderLabel!
    
    @IBOutlet weak var emailLbl: CustomBorderLabel!
    
    @IBOutlet weak var phoneLbl: CustomBorderLabel!
    
    @IBOutlet weak var courseLbl: CustomBorderLabel!
    @IBOutlet weak var universityLbl: CustomBorderLabel!
    
    @IBOutlet weak var radioBtnReceivecall: UIButton!
   
    @IBOutlet weak var submitBtn: RoundButton!
    @IBOutlet weak var radioBtnReceiveUpdates: UIButton!
    
    
    
     var checked = [Bool]()
     var CourseName: String = ""
     var universityName: String = ""
    var enquiryFormUserdetail = [EnquiryDetailsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
     fetchEnquiryInfo(token : "" )
        
           

        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        fetchEnquiryInfo(token: "")
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = appGreenColor
        self.navigationItem.title = "Enquiry Form"
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.backBarButtonItem?.title = "Back"
       self.navigationController?.navigationBar.topItem?.title = "Back"
        
        
    }
    
    
    
    
    
    
    @IBAction func receivecallRadioBtn(_ sender: Any) {
        
        
        
        
    }
    
    @IBAction func receivecallRadioBtnAction(_ sender: Any) {
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    @IBAction func SubmitEnquiryFormBtn(_ sender: Any) {
        
        sendEnquiryToServer()
        
        
          }
    
    func sendEnquiryToServer()-> Void{
    
    let statusHud = MessageView.viewFromNib(layout: .CardView)
    
    statusHud.configureTheme(.success)
    statusHud.id = "statusHud"
    statusHud.button?.isHidden = true
    var con = SwiftMessages.Config()
    
    con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
    con.duration = .automatic
    con.dimMode = .gray(interactive: false)
    con.eventListeners.append() { event in
    
    if case .willShow = event { self.view.endEditing(true)}
    
    
    }
    
    
        let enquiry = self.emquiryText.text
        let firstname  =  self.firstNameLbl.text
        let lastname = self.lastNameLbl.text
        let email = self.lastNameLbl.text
        let phone = self.lastNameLbl.text
    
    
    
    let params : Parameters = [
    
    "actionname": "enquiry",
    "data": [
    
    ["flag": "I",
    "institute_id": "1",
    "instution_course_id":"2",
        "first_name": firstname,
        "last_name": lastname,
        "email_address": email,
        "phone_number" : phone,
        "comments" : enquiry,
        "phone_call":"1",
        "update_received": "1"
]
    
    ]
    ]
    
    
    Alamofire.request(baseUrl + "Unauthorizedata", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
    
    
    
    
    switch response.result
    {
    
    case .success(let value):
    let json = JSON(value)
    print(json)
    case .failure(let error):
    print(error)
    
    }
    
    let data = JSON(response.result.value!)
    
    if let responseStatus = data["STATUS"].arrayObject
    {
    let status = responseStatus[0] as! [String: AnyObject]
    let s = status["STATUS"] as! String
    
    if s == "SUCCESS"
    {
    statusHud.configureContent(title: "Thanks For Enquiry ", body: "You will shortly receive email soon!")
    let _ = self.navigationController?.popViewController(animated: true)
    }
    
    else
    {
    let errorMsg = status["MESSAGE"] as! String
    statusHud.configureTheme(.error)
    statusHud.configureContent(title: "", body: errorMsg )
    
    }
    
    }
    SwiftMessages.show(config: con, view: statusHud)
    
    }
    
    
    }
    
    func fetchEnquiryInfo(token : String ) -> Void {
        
        
        var token = ""
        let decodedUserinfo = self.getUserInfo()
        
        if !decodedUserinfo.access_token.isBlank
        {
            token = decodedUserinfo.access_token
        }

                    let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
                    statusHud.configureTheme(.success)
                    statusHud.id = "statusHud"
                    statusHud.configureContent(title: "", body: "PROCESSING YOUR DATA")
                    var con = SwiftMessages.Config()
        
                    con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    con.duration = .automatic
                    con.dimMode = .gray(interactive: false)
                    
                    
                    
                    let headers: HTTPHeaders = [
                        "Authorization": "bearer " + token,
                        "Content-Type": "application/json"
                    ]
                    
                    let params : Parameters = [
                        
                        "actionname": "user_detail",
                        "data": [
                            
                            ["flag":"E"]
                            
                            
                        ]
                    ]
                    
                    
                    Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                        
                        switch response.result
                        {
                            
                        case .success(let value):
                            
                            
                            let data = JSON(value)
                            print(data)
                            
                            if let responseStatus = data["STATUS"].arrayObject
                            {
                                let status = responseStatus[0] as! [String: AnyObject]
                                let s = status["STATUS"] as! String
                                
                                if s == "SUCCESS"
                                {
                                    
                                    
                                    if let ui = data["rto-form"].arrayObject
                                    {
                                        let userInfo = ui as! [[String:AnyObject]]
                                        for dict in userInfo
                                        {
                                            let dataParser = DataParser(dataDictionary: dict)
                                            let enquiryUserDetail = EnquiryDetailsModel.init(
                                                firstName: dataParser.stringFor(key: "first_name"),
                                                lastName: dataParser.stringFor(key: "last_name"),
                                                phone: dataParser.stringFor(key: "phone_number"),
                                                email_address: dataParser.stringFor(key: "email_address")
                                            )
                                            self.enquiryFormUserdetail.append(enquiryUserDetail)
                                            self.firstNameLbl.text = enquiryUserDetail.first_name
                                            self.lastNameLbl.text = enquiryUserDetail.last_name
                                            self.phoneLbl.text = enquiryUserDetail.phone
                                            self.emailLbl.text = enquiryUserDetail.email_address
                                           self.courseLbl.text = self.CourseName
                                            self.universityLbl.text = self.universityName
                                           

                                            
                                        
                                        
                                        statusHud.configureContent(title: "", body: "FETCHING COMPLETE!")
                                    }

                                }
                                }                          else
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
    
    
                        
}

