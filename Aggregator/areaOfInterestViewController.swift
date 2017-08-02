//
//  areaOfInterestViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 6/19/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class areaOfInterestViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout {

   
    @IBOutlet var collectionView: UICollectionView?
    var sizingCell = LabelCollectionViewCell()
    let columnNum: CGFloat = 1 //use number of columns instead of a static maximum cell width
    var cellWidth: CGFloat = 0
    fileprivate var cellSizeCache = NSCache<AnyObject, AnyObject>()
    @IBAction func closeBtnClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        let nib = UINib(nibName: "LabelCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "labelCell")
       
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
           
         
        }
        

        self.collectionView?.reloadData()
     
        

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areaOfInterestArray.count 
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as! LabelCollectionViewCell
        
        cell.configureWithIndexPath(indexPath, LabelData: areaOfInterestArray[indexPath.row].facultyName, showTick : areaOfInterestArray[indexPath.row].checkStatus)
      
       
        
        return cell
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       
            
            // If fitted size was computed in the past for this cell, return it from cache
        if let size = cellSizeCache.object(forKey: indexPath as AnyObject) as? NSValue {
            return size.cgSizeValue
        }
            
            // Get a configured prototype cell
            let cell = LabelCollectionViewCell.fromNib()
            
        
            let size = cell?.contentView.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
        
            cellSizeCache.setObject(NSValue(cgSize: size!), forKey: indexPath as AnyObject)
        
            return (size)!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let id = areaOfInterestArray[indexPath.row].facultyId
        
        let decodedUserinfo = self.getUserInfo()
        
        if !decodedUserinfo.access_token.isBlank
        {
            
            self.updateAOI(id: String(id), token: decodedUserinfo.access_token, indexpath: indexPath)
            
            
           
            
            
                    }
        
        
  
                
        
    }
    
    func updateAOI(id : String , token : String , indexpath : IndexPath) -> Void {
    
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "user_interest_area",
            "data": [
                
                ["flag": "I"],
                 ["checked_only": "Y"],
                ["area_of_interest": id],
                
            ]
        ]
        
        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
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
                    

                    if let uia = data["USER_INTEREST_AREA"].arrayObject
                    {
                        
                        areaOfInterestArray.removeAll()
                        let resultDicts = uia as! [[String:AnyObject]]
                        
                        for dict in resultDicts
                        {
                            
                            let aoi = AreaOfInterest.init(facultyName: dict["faculty_name"] as! String, facultyId: dict["faculty_id"] as! Int ,checkStatus:  dict["check_status"] as! Int )
                            
                            
                            areaOfInterestArray.append(aoi)
                        }
                        
                        let cell = self.collectionView?.cellForItem(at: indexpath) as! LabelCollectionViewCell
                        cell.configureWithIndexPath(indexpath, LabelData: areaOfInterestArray[indexpath.row].facultyName, showTick: areaOfInterestArray[indexpath.row].checkStatus)
                        //self.collectionView?.reloadData()
                    }

                    
                }
                    
                else
                {
                    let errorMsg = status["MESSAGE"] as! String
                    
                    let alert = UIAlertController(title: "", message: errorMsg, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            
            
            
        }
        
        
    }
    
   

  
}
