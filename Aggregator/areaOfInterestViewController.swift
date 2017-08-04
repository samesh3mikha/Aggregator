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
        

        
     
        

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
        
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
        let aoiID = areaOfInterestArray[indexPath.row].facultyId
        self.uodateAOI(aoiID: String(aoiID), indexPath: indexPath)
    }
    
    func uodateAOI(aoiID: String, indexPath: IndexPath) {
        let params : Parameters = [
            "actionname": "user_interest_area",
            "data": [
                ["flag": "I"],
                ["checked_only": "Y"],
                ["area_of_interest": aoiID],
            ]
        ]        
        DataSynchronizer.syncData(params: params, completionBlock: { [weak self] (isRequestASuccess, message, data) in
            guard let weakself = self else {
                return
            }
            if isRequestASuccess {
                areaOfInterestArray[indexPath.row].checkStatus = (areaOfInterestArray[indexPath.row].checkStatus == 0) ? 1 : 0
                if let cell = weakself.collectionView?.cellForItem(at: indexPath) as? LabelCollectionViewCell {
                    cell.configureWithIndexPath(indexPath, LabelData: areaOfInterestArray[indexPath.row].facultyName, showTick: areaOfInterestArray[indexPath.row].checkStatus)
                }
            } else {
                weakself.showStatusHUD(title: "Error!", details: message, theme: .error, duration: .seconds(seconds: 2))
            }
        })

    }
}
