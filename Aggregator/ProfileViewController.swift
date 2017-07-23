//
//  ProfileViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 3/21/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import MXParallaxHeader
import IQDropDownTextField
import Alamofire
import SwiftyJSON
import SwiftMessages
import KCFloatingActionButton
import SDWebImage

class ProfileViewController: UIViewController, MXParallaxHeaderDelegate, UITextViewDelegate, UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet var Floaty: KCFloatingActionButton!
    @IBOutlet var nameLbl: UITextField!
    
    @IBOutlet var textViewHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet var emailHeaderXcontraints: NSLayoutConstraint!
    
    @IBOutlet var phoneNumberLbl: UITextField!
    
    
    @IBOutlet var emailLbl: UITextField!
    
    @IBOutlet var birthdayLbl: IQDropDownTextField!
    
    
    @IBOutlet var referenceView: UIView!
    @IBOutlet var genderLbl: IQDropDownTextField!
    
    @IBOutlet var headerImageView: CustomImageView!
    
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var headerViewNameLbl: UILabel!
    
    @IBOutlet var headerViewEmailLbl: UILabel!
    @IBOutlet var higestDegreeObtainedLbl: IQDropDownTextField!
    
    
    @IBOutlet var countryOfStudyLbl: IQDropDownTextField!
    
    
    @IBOutlet var englishProficiencyLbl: IQDropDownTextField!
    
    
    @IBOutlet var workExperienceLbl: UITextField!
    
    
    
    
    
    @IBOutlet var workAccomplishmentTextView: UITextView!
    
    
    
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var cityLbl: UITextField!
    
    @IBOutlet var streetNameLbl: UITextField!
    @IBOutlet var stateLbl: IQDropDownTextField!
    @IBOutlet var countryLbl: IQDropDownTextField!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var JoinNowBtn: UIButton!
    let picker = UIImagePickerController()
    let updateMessage = SwiftMessages()
    
    @IBOutlet var signoutBtn: UIButton!
    
    var countryList : [String:String] = [ : ]
    var englishProficiencyList : [String:String] = [ : ]
    var studyLevelList : [String:String] = [ : ]
    var statesList : [String:String] = [ : ]
    
    var isAllDataFetched = false
    
    var txtFieldTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
        picker.delegate = self
        
        
        //Create toolbar
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneFromPicker(button:)))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        nameLbl.inputAccessoryView = toolBar
        phoneNumberLbl.inputAccessoryView = toolBar
        emailLbl.inputAccessoryView = toolBar
        birthdayLbl.inputAccessoryView = toolBar
        genderLbl.inputAccessoryView = toolBar
        
        higestDegreeObtainedLbl.inputAccessoryView = toolBar
        
        countryOfStudyLbl.inputAccessoryView = toolBar
        englishProficiencyLbl.inputAccessoryView = toolBar
        workExperienceLbl.inputAccessoryView = toolBar
        workAccomplishmentTextView.inputAccessoryView = toolBar
        
        countryLbl.inputAccessoryView = toolBar
        stateLbl.inputAccessoryView = toolBar
        cityLbl.inputAccessoryView = toolBar
        streetNameLbl.inputAccessoryView = toolBar
        
        // Disable userInteraction initially
        self.disableUserInteraction()
        
        
        
    }
    
    func enableUserInteraction() -> Void {
        
        
        for views in self.scrollView.subviews
        {
            for items in views.subviews
            {
                if items is UITextField || items is UITextView
                {
                    
                    
                    if items.tag != 3 && items is UITextField
                        
                    {
                        let txtFld = items as! UITextField
                        txtFld.setBottomBorder()
                        txtFld.isUserInteractionEnabled = true
                        
                    }
                        
                    else if items is UITextView
                    {
                        let txtView = items as! UITextView
                        txtView.isUserInteractionEnabled = true
                    }
                    
                    
                }
                
            }
        }
        
        self.view.endEditing(true)
        
    }
    
    func disableUserInteraction() -> Void {
        
        
        
        
        
        for views in self.scrollView.subviews
        {
            for items in views.subviews
            {
                if items  is UITextView
                {
                    
                    items.isUserInteractionEnabled = false
                    
                    
                }
                
                if items is UITextField
                {
                    let txtfld = items as! UITextField
                    txtfld.removeBottomBorder()
                    txtfld.isUserInteractionEnabled = false
                    
                    
                }
                
            }
        }
        
        self.view.endEditing(true)
        
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Floaty.close()
        
        
        if Floaty.items.count >= 4
        {
            Floaty.removeItem(index: 0)
            Floaty.removeItem(index: 0)
            Floaty.removeItem(index: 0)
            Floaty.removeItem(index: 0)
        }
        
        Floaty.close()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.scrollView.scrollToTop()
        
        let decodedUserinfo = self.getUserInfo()
        
        if !decodedUserinfo.access_token.isBlank
        {
            
            
            
            scrollView.parallaxHeader.view = headerView
            scrollView.parallaxHeader.height = 230
            scrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
            scrollView.parallaxHeader.minimumHeight = 70
            scrollView.parallaxHeader.delegate = self
            scrollView.isDirectionalLockEnabled = true
            scrollView.delegate = self
            view.addSubview(scrollView)
            
            fetchDataToShow(token: decodedUserinfo.access_token)
            Floaty.isHidden = false
            scrollView.isHidden = false
            // ADD ITEMS TO FLOATY BUTTON
            
            Floaty.addItem("Edit area of interest", icon: #imageLiteral(resourceName: "edit"),handler: { item in
                
                let s = UIStoryboard(name: "Main", bundle: nil)
                let a = s.instantiateViewController(withIdentifier: "areaVCID") as! areaOfInterestViewController
                a.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(a, animated: true, completion: nil)
                
                
                self.Floaty.close()
            })
            
            Floaty.addItem("Edit details", icon: #imageLiteral(resourceName: "edit"),handler: { item in
                
                self.editBtnClicked()
                
                
                self.Floaty.close()
            })
            
            Floaty.addItem("Change password", icon:  #imageLiteral(resourceName: "lock"),handler: { item in
                
                
            })
            
            
            Floaty.addItem("Signout", icon: #imageLiteral(resourceName: "signOut"),handler: { item in
                
                self.signoutBtnClicked()
                
                
                
                self.Floaty.close()
            })
            
            
            
            
            
            self.view.addSubview(Floaty)
            
            disableUserInteraction()
            
            
        }
            
        else
        {
            scrollView.isHidden = true
            Floaty.isHidden = true
            JoinNowBtn.isHidden = false
            //lbl.isHidden = true
        }
        
        
        
        
    }
    
    // MARK: - Parallax header delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.width > UIScreen.main.bounds.size.width {
            scrollView.contentSize.width = UIScreen.main.bounds.size.width
        }
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        
        
        
        var scale =  parallaxHeader.progress
        let alphaValue = max(0, scale)
        scale = max(0.5, scale)
        
        
        
        for subviews in headerView.subviews
        {
            
            if subviews.tag == 1
            {
                
                let transform = CGAffineTransform(scaleX: scale, y: scale)
                subviews.alpha = alphaValue
                
                subviews.transform = transform
                
                
                
                
            }
            
            
            
            
            if subviews.tag == 2
            {
                
                emailHeaderXcontraints.constant = scale * 10
                
                
                
                
            }
            
            
            
        }
    }
    
    
    func nullToString(value : AnyObject!) -> String! {
        if value is NSNull {
            return ""
        } else {
            return  (NSString(format: "%@", value as! CVarArg)as String)
        }
    }
    
    //MARK: CUSTOMIZEUI
    
    func customizeUI(userProfileDetails : UserProfileDetails)
    {
        
        self.headerImageView.sd_setImage(with: URL.init(string: userProfileDetails.profileImageLink))
        self.backImageView.sd_setImage(with: URL.init(string: userProfileDetails.profileImageLink))
        
        DispatchQueue.main.async {
            
            self.headerViewNameLbl.text = userProfileDetails.first_name + " " + userProfileDetails.last_name
            self.headerViewEmailLbl.text =  userProfileDetails.email_address
            
            
            self.headerImageView.setShowActivityIndicator(true)
            
            
            
            
            
            let blurEffect : UIBlurEffect!
            
            if #available(iOS 10.0, *) {
                blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            } else {
                blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            }
            //  let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            
            
            let effectView = UIVisualEffectView.init(effect: blurEffect)
            effectView.frame = self.view.frame
            
            for views in self.backImageView.subviews
            {
                if views is UIVisualEffectView
                {
                    views.removeFromSuperview()
                }
            }
            
            self.backImageView.insertSubview(effectView, at: 0)
            //self.backImageView.addSubview(effectView)
            
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.addOrUpdateProfilePic))
            self.headerImageView.isUserInteractionEnabled = true
            self.headerImageView.addGestureRecognizer(tapGestureRecognizer)
            
            self.nameLbl.text = userProfileDetails.first_name + " " + userProfileDetails.last_name
            self.phoneNumberLbl.text = userProfileDetails.phone
            self.emailLbl.text = userProfileDetails.email_address
            self.workAccomplishmentTextView.text = userProfileDetails.notes
            self.workExperienceLbl.text = userProfileDetails.work_experience
            
            
            self.genderLbl.setSelectedItem(userProfileDetails.gender, animated: true)
            self.countryOfStudyLbl.setSelectedItem(userProfileDetails.country_of_study_name, animated: true)
            self.englishProficiencyLbl.setSelectedItem(userProfileDetails.english_proficiency_name, animated: true)
            
            self.countryLbl.setSelectedItem(userProfileDetails.country, animated: true)
            self.stateLbl.setSelectedItem(userProfileDetails.state, animated: true)
            self.cityLbl.text = userProfileDetails.city
            self.streetNameLbl.text = userProfileDetails.street_address
            self.higestDegreeObtainedLbl.setSelectedItem(userProfileDetails.highest_degree_name, animated: true)
            
            //Set date in label using formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            let date = dateFormatter.date(from: userProfileDetails.date_of_birth)
            
            self.birthdayLbl.dropDownMode = .datePicker
            self.birthdayLbl.minimumDate = dateFormatter.date(from: "01/01/1900")
            self.birthdayLbl.maximumDate =  Date()
            self.birthdayLbl.dateFormatter = dateFormatter
            self.birthdayLbl.setDate(date, animated: true)
            
            
        }
        
        
        
        
        // Fixing height of Textview
        
        let fixedWidth = self.workAccomplishmentTextView.frame.size.width
        
        workAccomplishmentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let newSize = workAccomplishmentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        var newFrame = workAccomplishmentTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        workAccomplishmentTextView.frame = newFrame;
        textViewHeightConstraints.constant = newSize.height
        
        
        
        
        higestDegreeObtainedLbl.optionalItemText = "Select your highest obtained degree"
        higestDegreeObtainedLbl.itemList = Array(studyLevelList.keys)
        
        countryLbl.optionalItemText = "Select your native country"
        countryLbl.itemList = Array(countryList.keys).sorted()
        
        countryOfStudyLbl.optionalItemText = "Select your country of study"
        countryOfStudyLbl.itemList = Array(countryList.keys).sorted()
        
        englishProficiencyLbl.optionalItemText = "Select your englist proficiency level"
        englishProficiencyLbl.itemList = Array(englishProficiencyList.keys)
        
        genderLbl.optionalItemText = "Select your gender"
        genderLbl.itemList = ["Male", "Female", "Others"]
        
        
    }
    
    
    func addOrUpdateProfilePic() -> Void
    {
        let optionMenu = UIAlertController(title: nil, message: "ADD/UPDATE YOUR PROFILE PICTURE", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            
            let picfromCameraAction = UIAlertAction(title: "Take a picture", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                
                self.picker.allowsEditing = true
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present( self.picker,animated: true,completion: nil)
                
                
                
            })
            
            
            optionMenu.addAction(picfromCameraAction)
            
        }
        
        
        let picFromGalleryAction = UIAlertAction(title: "Choose from gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
            
            
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
        })
        
        
        
        
        optionMenu.addAction(picFromGalleryAction)
        
        optionMenu.addAction(cancelAction)
        
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            //        self.profilePicImageView.image = chosenImage
            //        self.profilePicImageView.contentMode = .scaleAspectFill
            //self.headerImageView.image = chosenImage
            
            self.uploadImage(image: chosenImage)
            
        }
        
        
        dismiss(animated:true, completion: nil)
        
    }
    
    
    
    
    //MARK: Text view and text fields delegates
    
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
        textViewHeightConstraints.constant = newSize.height
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isBlank {
            textViewHeightConstraints.constant = 25
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.changeBottomBorderColor()
        
        
        if textField.tag == 106
        {
            if let e = countryLbl.selectedItem
            {
                let id = countryList[e]
                
                
                
                let decodedUserinfo = self.getUserInfo()
                
                if !decodedUserinfo.access_token.isBlank
                {
                    
                    fetchState(token: decodedUserinfo.access_token, countryID: id!)
                    
                }
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.setBottomBorder()
    }
    
    
    
    //MARK: NETWORK CALLS
    
    func uploadImage(image: UIImage) -> Void {
        
        var token = ""
        let decodedUserinfo = self.getUserInfo()
        
        if !decodedUserinfo.access_token.isBlank
        {
            token = decodedUserinfo.access_token
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        
        
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        //  let parameters = ["file": "UploadedImage"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "UploadedImage",fileName: "file.jpg", mimeType: "image/jpg")
            //            for (key, value) in parameters {
            //                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            //            }
        } , to:"http://192.168.1.11:8081/api/Main/UploadProfilePicture" , headers: headers){
            
            (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value!)
                    self.fetchProfile(token: token , isFromAreaOfInterest: false)
                }
                
                
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func fetchDataToShow(token : String){
        
        
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
        statusHud.configureTheme(.success)
        statusHud.id = "statusHud"
        statusHud.configureContent(title: "", body: "PROCESSING YOUR DATA")
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .automatic
        con.dimMode = .color(color: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7), interactive: false)
        
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "profile_parameters",
            "data": [
                
                ["flag":"S"]
                
                
            ]
        ]
        
        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
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
                            
                            for countries in 0...cl.count - 1
                            {
                                
                                let c = cl[countries] as! [String : AnyObject]
                                
                                self.countryList[ c["country_name"] as! String ] =  self.nullToString(value: c["country_id"])
                                
                                
                                
                                
                            }
                        }
                        
                        if let englishP = data["ENGLISH_PROFICIENCY"].arrayObject
                        {
                            
                            for item in 0...englishP.count - 1
                            {
                                
                                let c = englishP[item] as! [String : AnyObject]
                                
                                self.englishProficiencyList[c["proficiency_name"] as! String]  =   c["proficiency_id"] as? String
                                
                                
                                
                                
                            }
                        }
                        
                        if let studyLevels = data["STUDY_LEVEL"].arrayObject
                        {
                            
                            for item in 0...studyLevels.count - 1
                            {
                                
                                let c = studyLevels[item] as! [String : AnyObject]
                                
                                self.studyLevelList[c["study_level_name"] as! String]  =   c["study_level_id"] as? String
                                
                                
                                
                                
                            }
                        }
                        
                        self.isAllDataFetched = true
                        
                        
                        self.fetchProfile(token: token , isFromAreaOfInterest: false)
                        
                        
                        
                    }
                        
                    else
                    {
                        if status["MESSAGE"] as! String == "SESSION EXPIRED"
                        {
                            statusHud.configureTheme(.error)
                            statusHud.configureContent(title: "", body: status["MESSAGE"] as! String + ". PLEASE LOGIN")
                            self.catchSessionExpire()
                            
                            
                        }
                            
                        else
                        {
                            
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
    
    
    func fetchState(token : String, countryID : String) -> Void {
        
        
        
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "country_state",
            "data": [
                
                ["flag":"S",
                 "Country_id": countryID,
                 "table_name":"COUNTRY_STATE"
                ]
                
                
            ]
        ]
        
        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
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
                        self.statesList.removeAll()
                        if let cl = data["COUNTRY_STATE"].arrayObject
                        {
                            if cl.count > 0
                            {
                                
                                
                                for states in 0...cl.count - 1
                                {
                                    
                                    let c = cl[states] as! [String : AnyObject]
                                    
                                    self.statesList[ c["state_name"] as! String ] =  self.nullToString(value: c["state_id"])
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                self.stateLbl.itemList = Array(self.statesList.keys).sorted()
                            }
                            
                        }
                        
                    }
                        
                    else
                    {
                        if status["MESSAGE"] as! String == "SESSION EXPIRED"
                        {
                            self.catchSessionExpire()
                            
                            
                        }
                            
                        else
                        {
                            //                            statusHud.configureTheme(.error)
                            //                            statusHud.configureContent(title: "", body: status["MESSAGE"] as! String)
                        }
                        
                        
                        
                    }
                }
                
                
            case .failure(let error):
                print(error)
                if let err = error as? URLError, err.code == .notConnectedToInternet{
                    // no internet connection
                    
                    //                    statusHud.configureTheme(.error)
                    //                    statusHud.configureContent(title: "" , body: error.localizedDescription)
                    
                    
                }
                
                
                
            }
            
            //            SwiftMessages.show(config: con, view: statusHud)
            
            
            
            
        }
        
        
    }
    
    
    func fetchProfile(token : String , isFromAreaOfInterest : Bool) -> Void {
        
        
        
        
        
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
            
            "actionname": "user_profile",
            "data": [
                
                ["flag":"S"]
                
                
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
                            let userInfo = ui[0] as! [String: AnyObject]
                            
                            let userProfile = UserProfileDetails.init(firstName: self.nullToString(value: userInfo["first_name"])!,
                                                                      lastName: self.nullToString(value: userInfo["last_name"])!,
                                                                      email_address: self.nullToString(value: userInfo["email_address"])!,
                                                                      date_of_birth: self.nullToString(value: userInfo["date_of_birth"])!,
                                                                      gender: self.nullToString(value: userInfo["gender"])!,
                                                                      highest_degree_name: self.nullToString(value: userInfo["highest_degree_name"])!,
                                                                      english_proficiency_name: self.nullToString(value: userInfo["english_proficiency_name"])!,
                                                                      country_of_study_name: self.nullToString(value: userInfo["country_of_study_name"])!,
                                                                      work_experience: self.nullToString(value: userInfo["work_experience"])!,
                                                                      notes: self.nullToString(value: userInfo["notes"])!,
                                                                      state:  self.nullToString(value: userInfo["state_name"])!,
                                                                      country: self.nullToString(value: userInfo["country_name"])!,
                                                                      city: self.nullToString(value: userInfo["city"])!,
                                                                      street_address: self.nullToString(value: userInfo["street_address"])!,
                                                                      phone: self.nullToString(value: userInfo["phone1"])!,
                                                                      profileImageLink: self.nullToString(value: userInfo["user_image"])! )
                            
                            
                            
                            if !isFromAreaOfInterest{
                            self.customizeUI(userProfileDetails: userProfile)
                            }
                            
                            
                                                            
                            statusHud.configureContent(title: "", body: "FETCHING COMPLETE!")
                        }
                        
                        if let uia = data["USER_INTEREST_AREA"].arrayObject
                        {
                            
                            areaOfInterestArray.removeAll()
                            let resultDicts = uia as! [[String:AnyObject]]
                            
                            for dict in resultDicts
                            {
                                
                                let aoi = AreaOfInterest.init(facultyName: dict["faculty_name"] as! String, facultyId: dict["faculty_id"] as! Int ,checkStatus:  dict["check_status"] as! Int )
                                
                                
                                areaOfInterestArray.append(aoi)
                            }
                        }
                        
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
    
    
    func editProfile(token : String) -> Void {
        
        
        
        
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
        statusHud.configureTheme(.success)
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        statusHud.configureContent(title: "", body: "Saving. Please wait!")
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .automatic
        con.dimMode = .gray(interactive: false)
        
        
        
        //COLLECT DATA FROM EVERYWHERE
        
        let name = self.nameLbl.text
        let selectedName = name?.components(separatedBy: " ")
        let selectedFirstName = selectedName?.first
        let selectedLastName = selectedName?.last
        
        var selectedGender = ""
        var selectedBirthDay = ""
        
        var selectedHighestDegree = ""
        var selectedCountryOfStudy = ""
        var selectedEnglishProficiency = ""
        let selectedWorkExperience = self.workExperienceLbl.text
        let selectedNotes = self.workAccomplishmentTextView.text
        
        var selectedCountry = ""
        var selectedState = ""
        let selectedCity = cityLbl.text
        let selectedStreet = streetNameLbl.text
        let selectedImageLink = "http://192.168.1.11:8081/images/teampicture.png"
        
        
        
        
        
        selectedBirthDay = birthdayLbl.selectedItem!
        
        
        
        
        if let gender = genderLbl.selectedItem
        {
            selectedGender = gender
        }
        
        if let h = higestDegreeObtainedLbl.selectedItem
        {
            let id = studyLevelList[h]
            
            selectedHighestDegree = id!
            
            
        }
        
        
        
        if let c = countryOfStudyLbl.selectedItem
        {
            let id = countryList[c]
            
            selectedCountryOfStudy = id!
            
        }
        
        
        
        if let e = englishProficiencyLbl.selectedItem
        {
            let id = englishProficiencyList[e]
            
            selectedEnglishProficiency = id!
            
            
        }
        
        
        
        if let e = countryLbl.selectedItem
        {
            let id = countryList[e]
            
            selectedCountry = id!
            
            let decodedUserinfo = self.getUserInfo()
            
            if !decodedUserinfo.access_token.isBlank
            {
                
                fetchState(token: decodedUserinfo.access_token, countryID: selectedCountry)
                
            }
        }
        
        
        
        if let e = stateLbl.selectedItem
        {
            let id = statesList[e]
            
            selectedState = id!
            
            
        }
        
        
        
        
        
        
        let updatedUserData = UserProfileDetails(firstName: selectedFirstName!,
                                                 lastName: selectedLastName!,
                                                 email_address: emailLbl.text!,
                                                 date_of_birth: selectedBirthDay,
                                                 gender: selectedGender,
                                                 highest_degree_name: selectedHighestDegree,
                                                 english_proficiency_name: selectedEnglishProficiency,
                                                 country_of_study_name: selectedCountryOfStudy,
                                                 work_experience: selectedWorkExperience!,
                                                 notes: selectedNotes!,
                                                 state : selectedState,
                                                 country: selectedCountry,
                                                 city: selectedCity!,
                                                 street_address: selectedStreet!,
                                                 phone: phoneNumberLbl.text!,
                                                 profileImageLink : selectedImageLink)
        
        
        
        
        
        
        
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "user_profile",
            "data": [
                
                ["flag":"I",
                 "first_name":updatedUserData.first_name ,
                 "last_name":updatedUserData.last_name,
                 "phone1":updatedUserData.phone,
                 "date_of_birth":updatedUserData.date_of_birth,
                 "gender":updatedUserData.gender,
                 "highest_degree":updatedUserData.highest_degree_name,
                 "country_of_study":updatedUserData.country_of_study_name,
                 "notes":updatedUserData.notes,
                 "english_proficiency":updatedUserData.english_proficiency_name,
                 "work_experience":updatedUserData.work_experience,
                 "country_id":updatedUserData.country,
                 "state":updatedUserData.state,
                 "city":updatedUserData.state,
                 "street_address":updatedUserData.street_address
                    
                    
                ]
                
                
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
                        
                        statusHud.configureTheme(.success)
                        statusHud.configureContent(title: "", body: status["MESSAGE"] as! String )
                        self.updateMessage.hideAll()
                        self.fetchProfile(token: token , isFromAreaOfInterest:  false)
                        
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
                            SwiftMessages.hide(id: "statusHud")
                            
                            
                            
                            SwiftMessages.show(config: con, view: statusHud)
                            self.editBtnClicked()
                            
                            
                            
                            
                            
                        }
                        
                        
                        
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
                
                
                
            }
            
            
            
            
            
            
        }
        
        
    }
    
    
    
    //MARK: CLICK BUTTON EVENTS
    
    
    
    func editBtnClicked() {
        
        
        
        
        
        let view : EditConfirmationView = try! SwiftMessages.viewFromNib()
       
        view.configureDropShadow()
        view.saveDetailAction = {_ in
            
            self.disableUserInteraction()
            let decodedUserinfo = self.getUserInfo()
            
            if !decodedUserinfo.access_token.isBlank
            {
                
                self.editProfile(token: decodedUserinfo.access_token)
                
            }
        }
        
        view.cancelAction = {
            
            self.updateMessage.hide()
            let decodedUserinfo = self.getUserInfo()
            
            if !decodedUserinfo.access_token.isBlank
            {
                
                self.fetchProfile(token: decodedUserinfo.access_token ,isFromAreaOfInterest: false)
                
            }
            
            self.disableUserInteraction()
            
            
        }
        
        
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .none
        
        
        
        
        self.updateMessage.show(config: config, view: view)
        
        
        self.enableUserInteraction()
        
    }
    
    
    func signoutBtnClicked() {
        
        scrollView.isHidden = true
        Floaty.isHidden = true
        
        self.catchSessionExpire()
    }
    
    func doneFromPicker(button: UIBarButtonItem) -> Void
    {
        
        
        self.view.endEditing(true)
        
        
    }
    
    
    @IBAction func joinNowBtnClicked(_ sender: Any)
    {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Loginvcid") as! LoginViewController
        
        let navController = UINavigationController(rootViewController: loginViewController)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
}
