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
    var  myId = [String]()
    var Ditems = [String]()
    
    
    
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
        

        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UniMapView.delegate = self
        self.navigationController?.navigationBar.isHidden = false
        myId = [myId.joined(separator: ",")]
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUniversityDetail(token : "", universityID : ""  )
        
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
             let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            
            
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
            var universityID = myId
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
                 "Institution_course_id": 2,
                 
                 
                ]
                
                
            ]
        ]
        
        
        Alamofire.request(baseUrl + "Unauthorizedata", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                let json = JSON(value)
                                
                
                let data = JSON(response.result.value!)
                print(data)
                
                if let responseArray = data["rto-form"].arrayObject
                {
                    
                    courseArray.removeAll()
                    autoSuggestionArray.removeAll()
                    allAutosuggestionArray.removeAll()
                    countryAutosuggestionArray.removeAll()
                    
                    let resultDicts = responseArray as! [[String:AnyObject]]
                    
                    for dict in resultDicts
                    {
                        let detail =  SearchDeatils.init(institution_course_id: dict["institution_course_id"]! as! Int , course_id: dict["course_id"]! as! Int , course_name: dict["course_name"]! as! String , institute_id: dict["institute_id"]! as! Int , institute_name: dict["institute_name"]! as! String , phone: dict["phone"]! as! String , institute_image: dict["institute_image"]! as! String , institute_logo: dict["institute_logo"]! as! String , gps_lattitude: dict["gps_lattitude"]! as! Int , gps_longitude: dict["gps_longitude"]! as! Int , email_address: dict["email_address"]! as! String , website: dict["website"]! as! String , about_us: dict["about_us"]! as! String , course_description: dict["course_description"]! as! String , faculty_name: dict["faculty_name"]! as! String , course_code: dict["course_code"]! as! String , active: dict["active"]! as! Bool, institute_full_address: dict["institute_full_address"]! as! String , study_level_name: dict["study_level_name"]! as! String , country: dict["country"]! as! String , institution_type: dict["institution_type"]! as! String )
                        
                       

                        
                        
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






