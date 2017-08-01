//
//  RegistrationViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 3/21/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import SwiftMessages

var areaOfInterestArray = [AreaOfInterest]()
var userinfo : UserInfo!


class RegistrationViewController: UIViewController {

    @IBOutlet var HolderView: UIView!
    @IBOutlet var confirmPasswordLbl: CustomTxtField!
    
    @IBOutlet var passwordLbl: CustomTxtField!
    @IBOutlet var emailLbl: CustomTxtField!
    @IBOutlet var nameLbl: CustomTxtField!
    
    
    @IBAction func backBtn(_ sender: Any) {
        
       _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerNowBtnClicked(_ sender: Any) {
        
        
        if ((emailLbl.text?.isEmail)! && !(nameLbl.text?.isBlank)!)
        {
            if((passwordLbl.text?.isValidPassword)! && passwordLbl.text == confirmPasswordLbl.text)
            {
                 print("register successful")
                
                self.sendToServer()
            }
            
            else if((passwordLbl.text?.isValidPassword)! && passwordLbl.text != confirmPasswordLbl.text)
            {
               

            }
            
            else if(!(passwordLbl.text?.isValidPassword)! )
            {
                print("Password not in correct format")
            }
            
            
           
        }
        
        else
        
        {
            print("register unsuccessful")
        }
        
        
        
    }
    
    func sendToServer() -> Void {
        
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
        
        
        let name = self.nameLbl.text
        let selectedName = name?.components(separatedBy: " ")
        let selectedFirstName = selectedName?.first
        let selectedLastName = selectedName?.last
        
        
        let params : Parameters = [
            
            "actionname": "user_registration",
            "data": [
            
                ["flag": "I",
                "user_type_id": "3",
                "first_name": selectedFirstName,
                "last_name" : selectedLastName,
                "password": passwordLbl.text!,
                "email_address": emailLbl.text!]
            
            ]
        ]
        
        
        Alamofire.request(baseUrl + "Signup", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
           

            
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
                    statusHud.configureContent(title: "Thanks For Signing Up", body: "You will shortly receive an email asking you to confirm your email address.Please check spam folders & add Edu Connect to your contact list to ensure delivery of emails.Please click the confirmation link in the email to confirm your new account.")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       // self.HolderView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "patternBackground"))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        let ui = UserDefaults.standard.string(forKey: "Kaccess_token")
        if ui != nil
        {
            _ = self.navigationController?.popToRootViewController(animated: false)
        }
        
    }

    
}
