//
//  UniversityViewController.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/19/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import SwiftMessages
import CoreLocation


class UniversityViewController: UIViewController,MKMapViewDelegate {
    var detailArray = [SearchDeatils]()
    
    var  myId: String = ""
    var Ditems = [String]()
    var universityName: String = ""
    var CourseName : String = ""
    var collegeid: String = ""
    var courseid: String = ""
    
    @IBOutlet weak var BackGroundUniImage: UIImageView!
    
    @IBOutlet weak var UniImageView: UIImageView!
    
    @IBOutlet weak var uniNameLabel: UILabel!
    @IBOutlet weak var addressNameLbl: UILabel!
    
    @IBOutlet weak var PhonenoLbl: UILabel!
    @IBOutlet weak var uniEmailLbl: UILabel!
    @IBOutlet weak var globeurlLbl: UILabel!
    @IBOutlet weak var uniTypeLbl: UILabel!
    @IBOutlet weak var uniLevelLbl: UILabel!
    @IBOutlet weak var uniAboutLbl: UILabel!
    @IBOutlet weak var UniMapView: MKMapView!
    
    
    
    @IBAction func EnquiryNowBtn(_ sender: Any) {
        
        
        let EnquiryViewController = self.storyboard?.instantiateViewController(withIdentifier: "EnquiryFormViewController") as! EnquiryFormViewController
        
        self.navigationController?.pushViewController(EnquiryViewController, animated: true)
      
           EnquiryViewController.universityName = self.uniNameLabel.text!
       
           EnquiryViewController.CourseName = self.CourseName
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UniMapView.delegate = self
        self.navigationController?.navigationBar.isHidden = false
      
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUniversityDetail(token : "", universityID : ""  )
        self.navigationItem.title = "University Details"
        BackGroundUniImage.sd_setImage(with: URL.init(string: ""), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func customizeUI(universityDetails : SearchDeatils)
    {
        
     self.UniImageView.sd_setImage(with: URL.init(string: universityDetails.institute_logo))
       self.BackGroundUniImage.sd_setImage(with: URL.init(string: universityDetails.institute_image))
       
        DispatchQueue.main.async {
            
           self.CourseName = universityDetails.course_name
            self.uniNameLabel.text = universityDetails.institute_name
            self.addressNameLbl.text = universityDetails.institute_full_address + "" + universityDetails.country
            self.uniLevelLbl.text = universityDetails.study_level_name
             self.uniTypeLbl.text = universityDetails.institution_type
            self.uniEmailLbl.text =  universityDetails.email_address
            self.uniAboutLbl.text = universityDetails.about_us
            self.PhonenoLbl.text = universityDetails.phone
            self.globeurlLbl.text = universityDetails.website
            self.UniImageView.setShowActivityIndicator(true)
           
            let lon = Double(universityDetails.gps_longitude)
            let lat = Double(universityDetails.gps_lattitude)
            if( lat > -89 && lat < 89 && lon > -179 && lon < 179 ){
            let UniversityLat:CLLocationDegrees = CLLocationDegrees(Double(lat))
            let universityLong:CLLocationDegrees = CLLocationDegrees(Double(lon))
            
            let universityCoordinate = CLLocationCoordinate2D(latitude: UniversityLat, longitude: universityLong)
            
            //**Span**//
            let latDelta =  0.01
            let longDelta =  0.01
            
            let universitySpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            
           let universityRegion = MKCoordinateRegion(center: universityCoordinate, span: universitySpan)
            
           self.UniMapView.setRegion(universityRegion, animated: true )
            
            let UniversityAnnotation = MKPointAnnotation()
            UniversityAnnotation.title = "UniversityLocation"
            
            UniversityAnnotation.coordinate = universityCoordinate
            self.UniMapView.addAnnotation(UniversityAnnotation)
              
                
            
            }
            


            
            
            
            
            
            
            let blurEffect : UIBlurEffect!
            
            if #available(iOS 10.0, *) {
                blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            } else {
                blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            }
             _ = UIVibrancyEffect(blurEffect: blurEffect)
            
            
            let effectView = UIVisualEffectView.init(effect: blurEffect)
            effectView.frame = self.BackGroundUniImage.frame
            
//            for views in self.BackGroundUniImage.subviews
//            {
//                if views is UIVisualEffectView
//                {
//                    views.removeFromSuperview()
//                }
//            }
            self.BackGroundUniImage.insertSubview(effectView, at: 0)
            self.UniImageView.addSubview(effectView)
            

            self.BackGroundUniImage.addSubview(effectView)
            
            
            
     }
        
        
        }
        

    func fetchUniversityDetail(token : String, universityID : String ) -> Void {
       
            
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
            let universityID = myId
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
                
                ["flag":"E",
                 "Institution_course_id": universityID,
                 
                 
                ]
                
                
            ]
        ]
        
        
        Alamofire.request(baseUrl + "Unauthorizedata", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                let data = JSON(value)
                if let responseArray = data["rto-form"].arrayObject {
                    courseArray.removeAll()
                    autoSuggestionArray.removeAll()
                    allAutosuggestionArray.removeAll()
                    countryAutosuggestionArray.removeAll()
                    
                    let resultDicts = responseArray as! [[String:AnyObject]]
                    
                    for dict in resultDicts {
                        let dataParser = DataParser(dataDictionary: dict)                        
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
                        self.customizeUI(universityDetails: detail)
                        self.detailArray.append(detail)
                        
                        
                        
                        
                    }
//                    
                   
                    
                }
                
            case .failure(let error):
                print(error)
                
            }
            
            
            
        }
        

        
            
               
    }
    
    
//
    
        
        
        
        
        
    }






