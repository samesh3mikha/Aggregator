//
//  LoginViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 3/21/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Alamofire
import SwiftyJSON
import SwiftMessages

class LoginViewController:  UIViewController{
    
    @IBOutlet var userNameTxtField: CustomTxtField!
    
    @IBOutlet var passwordTxtField: CustomTxtField!
    @IBOutlet var closeView: UIView!
    
    @IBOutlet var fbLoginBtn: UIButton!
    @IBOutlet var HolderView: UIView!
    
    
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        
        sendToServer()
        
    }
    
    
    
    
    
    @IBAction func registrationBtnClicked(_ sender: Any) {
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "registrationvcid") as! RegistrationViewController
        
        self.navigationController?.pushViewController(registerViewController, animated: true)
        
    }
    
    func CloseVcBtnClicked() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.HolderView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "patternBackground"))
        
        let closeTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.CloseVcBtnClicked))
        self.closeView.addGestureRecognizer(closeTap)
        
    }
    
    //MARK: Network Request and response
    
    
    
    func sendToServer() -> Void {
        
        
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        statusHud.configureContent(title: "", body: "Validating! Please wait..")
        statusHud.configureTheme(.warning)
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .automatic
        con.dimMode = .gray(interactive: false)
        con.eventListeners.append() { event in
            
            if case .willShow = event { self.view.endEditing(true)}
          
        }
        
        
        SwiftMessages.show(config: con, view: statusHud)
       
        
        let params : Parameters = [
            "actionname": "user_login",
            "data": [[
                "userName": userNameTxtField.text!,
                "password": passwordTxtField.text!
//                "sessiontime": 200000000
                ] ]
        ]
        print("params -->", params  )

        
        Alamofire.request(baseUrl + "Authenticate", method: .post, parameters: params, encoding: JSONEncoding.default , headers: nil).responseJSON { (response) in
            
           
            
            print("response -->", response)
            switch response.result
            {
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                let data = JSON(response.result.value!)
                
                if let responseStatus = data["STATUS"].arrayObject
                {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let s = status["STATUS"] as! String
                    
                    
                    let alertView = MessageView.viewFromNib(layout: .CardView)
                    alertView.button?.isHidden = true
                    
                    alertView.configureDropShadow()
                    
                    if s == "SUCCESS"
                    {
                        
                        
                        if let responseDict = data["TOKEN"].dictionaryObject
                        {
                            
                            userinfo = UserInfo.init(userName: responseDict["userName"] as! String, accessToken: responseDict["access_token"] as! String, isfirstTimeLogin: responseDict["first_time_login"] as! Bool)
                            
                            
                            
                            let pref = UserDefaults.standard
                            let encodedData : Data = NSKeyedArchiver.archivedData(withRootObject: userinfo)
                            pref.set(encodedData, forKey: "userinfo")
                            
                            pref.synchronize()
                            
                            if let resultDicts = responseDict["area_of_interest"] as? [[String:AnyObject]]
                            {
                                for dict in resultDicts
                                {
                                    
                                    let aoi = AreaOfInterest.init(facultyName: dict["faculty_name"] as! String, facultyId: dict["faculty_id"] as! Int,checkStatus: dict["check_status"] as! Int )
                                    
                                    
                                    areaOfInterestArray.append(aoi)
                                }
                            }
                            
                            
                            SwiftMessages.hideAll()
                            
                            alertView.configureTheme(.success)
                            alertView.configureContent(title: "Success", body: status["MESSAGE"] as! String)
                            
                            var config = SwiftMessages.Config()
                            
                            // Slide up from the bottom.
                            config.presentationStyle = .top
                            
                            // Display in a window at the specified window level: UIWindowLevelStatusBar
                            // displays over the status bar while UIWindowLevelNormal displays under.
                            config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                            
                            // Disable the default auto-hiding behavior.
                            config.duration = .seconds(seconds: 1)
                            
                            // Dim the background like a popover view. Hide when the background is tapped.
                            config.dimMode = .gray(interactive: true)
                            
                            // Disable the interactive pan-to-hide gesture.
                            config.interactiveHide = false
                            
                            // Specify a status bar style to if the message is displayed directly under the status bar.
                            config.preferredStatusBarStyle = .lightContent
                            
                            // Specify one or more event listeners to respond to show and hide events.
                            config.eventListeners.append() { event in
                                
                                if case .willShow = event { self.view.endEditing(true)}
                                if case .didHide = event {  self.dismiss(animated: true, completion: nil) }
                            }
                            
                            SwiftMessages.show(config: config, view: alertView)
                            
                            
                        }
                        
                    }
                        
                    else
                    {
                        
                        
                        
                        
                       
                        alertView.configureTheme(.error)
                        alertView.configureContent(title: "Error", body: status["MESSAGE"] as! String)
                        
                        var config = SwiftMessages.Config()
                        
                        // Slide up from the top.
                        config.presentationStyle = .top
                        
                        
                        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                        
                        config.duration = .seconds(seconds: 1)
                        
                        config.dimMode = .gray(interactive: true)
                        
                        
                        config.interactiveHide = false
                        
                        
                        config.preferredStatusBarStyle = .lightContent
                        
                        
                        config.eventListeners.append() { event in
                            
                            if case .willShow = event { self.view.endEditing(true)}
                        }
                        
                        
                        SwiftMessages.show(config: config, view: alertView)
                    }
                    
                }
                
                
                
                
            case .failure(let error):
                
                if let err = error as? URLError, err.code == .notConnectedToInternet{
                    // no internet connection
                    
                    statusHud.configureTheme(.error)
                    statusHud.configureContent(title: "" , body: error.localizedDescription)
                    
                 
                    
                    
                    
                    
                    
                } else {
                    
                    
                    statusHud.configureTheme(.error)
                    statusHud.configureContent(title: "" , body: error.localizedDescription)
                    SwiftMessages.show(config:SwiftMessages.defaultConfig , view: statusHud)


                }
                print(error)
                
            }
            

            
            
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        
      
       
    }
    
    
    
    
    func getDataFromFB() -> Void {
        let request = GraphRequest(graphPath: "me", parameters:
            ["fields":"email,name,picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        
        request.start { (URLResponse, result) in
            switch result
            {
            case .success(response: let responseData) :
                
                
                print(responseData.dictionaryValue!)
                break
                
            case .failed(let error):
                print(error)
                
                break
                
            }
        }
        
    }
    
    @IBAction func fbLoginBtnClicked(_ sender: Any) {
        
        
        let loginManager = LoginManager()
        
        loginManager.logIn([.publicProfile,.email], viewController: self)
        {
            result in
            
            
            switch result {
                
                
            case .success( _, _, _):
                
                self.getDataFromFB()
                break
                
            case .failed(let error):
                print(error)
                break
                
            case .cancelled():
                print("User Login Cancel")
                break
            }
            
            
        }
        
        
    }
}
