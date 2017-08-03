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
import IQDropDownTextField


var areaOfInterestArray = [AreaOfInterest]()
var userinfo : UserInfo!


class RegistrationViewController: UIViewController {
    var countryList : [String:String] = [ : ]
    var selectedCountry = ""
   

    @IBOutlet var HolderView: UIView!
    @IBOutlet var confirmPasswordLbl: CustomTxtField!
    @IBOutlet var passwordLbl: CustomTxtField!
    @IBOutlet var emailLbl: CustomTxtField!
    @IBOutlet var nameLbl: CustomTxtField!
    @IBOutlet weak var lastnameLbl: CustomTxtField!
    @IBOutlet weak var selectCountry: IQDropDownTextField!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Registration"
        navigationController?.navigationBar.isHidden = false
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneFromPicker(button:)))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        selectCountry.inputAccessoryView = toolBar
        fetchCountrytoShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
        
        let ui = UserDefaults.standard.string(forKey: "Kaccess_token")
        if ui != nil
        {
            _ = self.navigationController?.popToRootViewController(animated: false)
        }
    }
    

    @IBAction func closeButtonClicked(_ sender: Any) {
       _ = navigationController?.popViewController(animated: true)
    }
    
     @IBAction func registerNowBtnClicked(_ sender: Any) {
        
        let statusHud = MessageView.viewFromNib(layout: .CardView)
        
        statusHud.configureTheme(.success)
        statusHud.id = "statusHud"
        statusHud.button?.isHidden = true
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .automatic
        con.dimMode = .gray(interactive: false)
        con.eventListeners.append() { event in
        var isValidEmail = false
            if case .willShow = event { self.view.endEditing(true)}
        }
        
        if ((emailLbl.text?.isEmail)! && !(nameLbl.text?.isBlank)!) {
            if((passwordLbl.text?.isValidPassword)! && passwordLbl.text == confirmPasswordLbl.text) {
                print("password match successful")
                registerTheUser()
            } else if((passwordLbl.text?.isValidPassword)! && passwordLbl.text != confirmPasswordLbl.text) {
                statusHud.configureTheme(.warning)
                statusHud.configureContent(title: "", body: "Password doesn't match")
                SwiftMessages.show(config: con, view: statusHud)
            } else if(!(passwordLbl.text?.isValidPassword)! ) {
                statusHud.configureTheme(.warning)
                statusHud.configureContent(title: "", body: "Password not in correct format")
                SwiftMessages.show(config: con, view: statusHud)
                print("Password not in correct format")
            }else if !self.validate(YourEMailAddress: emailLbl.text!)
            {
                print("email invalid")
                statusHud.configureTheme(.warning)
                statusHud.configureContent(title: "", body: "please enter valid emailaddress")
                SwiftMessages.show(config: con, view: statusHud)
            }
            

            
         else {
                
            print("register unsuccessful")
            statusHud.configureTheme(.warning)
            statusHud.configureContent(title: "", body: "register unsuccessful")
            SwiftMessages.show(config: con, view: statusHud)
        }
    }
    
    }
    
    
    
    
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }
    
    func registerTheUser() {
        if selectCountry.selectedItem!.isBlank{
            return
        }
        
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
       
        selectedCountry = selectCountry.selectedItem!
        if let c = selectCountry.selectedItem
        {
            let id = countryList[c]
            
            selectedCountry = id!
            print(selectedCountry)
            
        }

        
        
        let params : Parameters = [
            
            "actionname": "user_registration",
            "data": [
            
                ["flag": "I",
                "user_type_id": "3",
                "first_name":nameLbl.text!,
                "last_name" : lastnameLbl.text!,
                "password": passwordLbl.text!,
                "user_country" : selectedCountry,
                "base_url" : baaseUrlRegistr,
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
                    con.duration = .seconds(seconds: 5)
                    statusHud.configureTheme(.success)
                    statusHud.configureContent(title: "Thanks For Signing Up", body: "You will shortly receive an email asking you to confirm your email address.Please check spam folders & add Edu Connect to your contact list to ensure delivery of emails.Please click the confirmation link in the email to confirm your new account.")
                    let _ = self.navigationController?.popViewController(animated: true)
                    
                }
                
                else
                {
                    let errorMsg = status["MESSAGE"] as! String
                    statusHud.configureTheme(.error)
                    statusHud.configureContent(title: "Error", body: errorMsg )
                    
                    
                    
                }
            }
            SwiftMessages.show(config: con, view: statusHud)
        }
        
        
    }
    
    func doneFromPicker(button: UIBarButtonItem) -> Void
    {
        
        
        self.view.endEditing(true)
        
        
    }
    


    
    
    func nullToString(value : AnyObject!) -> String! {
        if value is NSNull {
            return ""
        } else {
            return  (NSString(format: "%@", value as! CVarArg)as String)
        }
    }

    
    
    func fetchCountrytoShow() -> Void {
        
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
        statusHud.configureTheme(.success)
        statusHud.id = "statusHud"
        statusHud.configureContent(title: "", body: "Fetching country data.")
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .automatic
        con.dimMode = .color(color: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7), interactive: false)
        
        if let country = selectCountry.selectedItem
        {
            let id = countryList[country]
            
            selectedCountry = id!
            
        }
        

        let headers: HTTPHeaders = [
           // "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "select_items",
           
            "data": [
                ["flag":"S",
                "type":"COUNTRY",
                "table_name":"COUNTRY_LIST",
               ]
                
                
            ]
        ]
        
        
        Alamofire.request(baseUrl + "UnauthorizeData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                
                
                let data = JSON(value)
                
                
                if let responseStatus = data["STATUS"].arrayObject
                {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let s = status["STATUS"] as! String
                    
                    if s == "SUCCESS"
                    {
                        
                        
                        if let cl = data["COUNTRY_LIST"].arrayObject
                        {
                            
                            self.selectCountry.optionalItemText = "Select your country"
                            for countries in 0...cl.count - 1
                            {
                                
                                let c = cl[countries] as! [String : AnyObject]
                                
                                self.countryList[ c["country_name"] as! String ] =  self.nullToString(value: c["country_id"])
                                
                                    print(self.countryList)
                               
                            }
                            let sortedCountryList = Array(self.countryList.keys).sorted()
                            self.selectCountry.itemList = sortedCountryList
//                            let defaultIndex = sortedCountryList.index(where: { (countryName) -> Bool in
//                                countryName.localizedLowercase  == "australia" 
//                            })
//                            if defaultIndex != nil {
//                                self.selectCountry.selectedRow = 13
//                            }

                        }

                    
       }

    
        }
                else
                {
                    
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
