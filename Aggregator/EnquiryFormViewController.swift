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

    @IBOutlet weak var firstNameLbl: UILabel!
   
    @IBOutlet weak var lastNameLbl: UILabel!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var phoneLbl: UILabel!
    
    @IBOutlet weak var courseLbl: UILabel!
    @IBOutlet weak var universityLbl: UILabel!
    
    @IBOutlet weak var radioBtnImage1: UIImageView!
    @IBOutlet weak var radiobtnImage2call: UIImageView!
    @IBOutlet weak var submitBtn: RoundButton!
    
    
    
     var checked = [Bool]()
     var CourseName: String = ""
     var universityName: String = ""
    var enquiryFormUserdetail = [UserEnquiryDetails]()
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
        
        
       
        
    }
    
    
    
    @IBAction func SubmitEnquiryFormBtn(_ sender: Any) {
        
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

                                            let enquiryUserDetail = UserEnquiryDetails.init(firstName: dict["first_name"]! as! String, lastName: dict["last_name"]! as! String, phone: dict["phone_number"]! as! String ,email_address: dict["email_address"]! as! String)
                                            
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

