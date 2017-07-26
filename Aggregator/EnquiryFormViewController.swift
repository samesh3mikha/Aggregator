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
    
    @IBOutlet weak var enquiryField: UITextView!
    
    @IBOutlet weak var callCheckBox: UIImageView!
    
    @IBOutlet weak var recUpdateCheckBox: UIImageView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
     fetchEnquiryInfo(token : "" )
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        fetchEnquiryInfo(token: "")
        self.navigationController?.navigationBar.barTintColor = appGreenColor
    }
    
    
    
    @IBAction func SubmitEnquiryFormBtn(_ sender: Any) {
        
          }
    
    
    
    func fetchEnquiryInfo(token : String ) -> Void {
        SwiftMessages.hideAll()
        
        
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
        statusHud.configureTheme(.success)
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 0.5)
        con.dimMode = .none
        
        var token = ""
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
            
            "actionname": "user_detail",
            "data": [
                
                ["flag":"E"
                
           ]]
]
        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                
                
                let data = JSON(value)
                print(data)
               
                
                if let responseStatus = data["rto-form"].arrayObject
                {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let s = status["STATUS"] as! String
                    if s == "SUCCESS"
                    {
                        statusHud.configureTheme(.success)
                        statusHud.configureContent(title: "", body: status["MESSAGE"] as! String )
                    
                    for dict in status
                        {
                            
                       //let  d = UserProfileDetails.init(firstName:["first_name"] as! String , lastName:  dict["first_name"]! as! String, email_address:  dict["first_name"]! as! String, date_of_birth:  dict["first_name"]! as! String, gender:  dict["first_name"]! as! String, highest_degree_name:  dict["first_name"]! as! String, english_proficiency_name:  dict["first_name"]! as! String, country_of_study_name:  dict["first_name"]! as! String, work_experience:  dict["first_name"]! as! String, notes:  dict["first_name"]! as! String, state:  dict["first_name"]! as! String, country:  dict["first_name"]! as! String, city:  dict["first_name"]! as! String, street_address:  dict["first_name"]! as! String, phone:  dict["first_name"]! as! String, profileImageLink:  dict["first_name"]! as! String)
                    
                     // self.detailArray.append(d)

                    }
                   
                        
                    }else
                        {
                            statusHud.configureTheme(.error)
                            statusHud.configureContent(title: "", body: status["MESSAGE"] as! String)
                            SwiftMessages.hide(id: "statusHud")
                            SwiftMessages.show(config: con, view: statusHud)
                          
                            
                           
                            
                            
                            
                        }
                        
                        
                        
                    }
                
                
                
            case .failure(let error):
                print(error)
                if let err = error as? URLError, err.code == .notConnectedToInternet{
                    // no internet connection
                    
                    statusHud.configureTheme(.error)
                    statusHud.configureContent(title: "" , body: error.localizedDescription)
                    
                    SwiftMessages.show(config: con, view: statusHud)
                }
                
                
                
            
            
            
            else {
                
                
                // other failures
                
            }
            print(error)
            
        }

        
        
        
        }
        
        
    }
    
    

    
            
    


   
}



