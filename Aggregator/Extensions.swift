//
//  Extensions.swift
//  Aggregator
//
//  Created by pukar sharma on 3/30/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

extension UIView {
    
       
    func copyView() -> AnyObject
    {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as AnyObject
    }
    
    func roundCorners(_ corners:UIRectCorner , radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


extension UISegmentedControl {
    func setSegmentStyle() {
    
        let segmentGrayColor = UIColor.lightGray
      //  setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: segmentGrayColor), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName: UIFont(name: Style.quicksand_medium, size: 14)!
        ]
        setTitleTextAttributes(segAttributes as [NSObject : AnyObject], for: UIControlState.normal)
        let segAttributesExtra: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: Style.quicksand_medium, size: 14)!
        ]
        setTitleTextAttributes(segAttributesExtra as [NSObject : AnyObject], for: UIControlState.selected)
        selectedSegmentIndex = selectedCategoryIndex
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = segmentGrayColor.cgColor
        self.layer.masksToBounds = true
    
    
    
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}


public extension UIImageView {
    
    
    func addBlur(url : URL)
    {
        let beginImage = CIImage(contentsOf: url, options: nil)
        
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(5, forKey: kCIInputRadiusKey)
        blurfilter?.setValue(beginImage, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
       
        self.image = blurredImage
    }
    
    
}
public extension UIImage {
    
    
    
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}


extension UISearchBar
{
    func removeBackground() -> Void {
        
        
        for view in self.subviews.last!.subviews {
            if view.isKind(of: NSClassFromString("UISearchBarBackground")!)
            
            {
                view.removeFromSuperview()
            }
            
            
        }
    }
}

// MARK:- UIViewController Extension

private var vcExtionsionAssociationKey: UInt8 = 0

extension UIViewController {
    var overlayView: UIView! {
        get {
            return objc_getAssociatedObject(self, &vcExtionsionAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &vcExtionsionAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setupOverlay() {
        let parentView = self.view
        let overlay = UIView(frame: (parentView?.bounds)!)
        overlay.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        parentView?.addSubview(overlay)
        
        let views: [String: UIView] = ["parentView": parentView!, "overlay": overlay]
        
        parentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[overlay]|", options: [], metrics: nil, views: views))
        parentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[overlay]|", options: [], metrics: nil, views: views))
        overlay.alpha = 0.0
        self.overlayView = overlay
    }
    
    func addOverlay() {
        guard let overlay = overlayView else {
            return
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                overlay.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func removeOverlay() {
        guard let overlay = overlayView else {
            return
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                overlay.alpha = 0.0
            }, completion: { _ in
            })
        }
    }

    //Helper for HUDs
    func showStatusHUD(title: String, details: String, theme: Theme, duration: SwiftMessages.Duration) {
        let messageHud = MessageView.viewFromNib(layout: .StatusLine)
        messageHud.id = "statusHud"
        messageHud.configureContent(title: title, body: details)
        messageHud.configureTheme(theme)

        var hudConfiguration = SwiftMessages.Config()
        hudConfiguration.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        hudConfiguration.dimMode = .none
        hudConfiguration.duration = duration
        
        SwiftMessages.hideAll()
        SwiftMessages.show(config: hudConfiguration, view: messageHud)
    }
    
    func getUserInfo() -> UserInfo {
        
        let pref = UserDefaults.standard
        if let decoded = pref.object(forKey: "userinfo")
            
        {
            let decodedUserinfo = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! UserInfo
            
            return decodedUserinfo
        }
        
        else
        
        {
            let u = UserInfo(userName: "", accessToken: "", isfirstTimeLogin: false)
            return u
            
        }
        
        

        
    }
    
        func catchSessionExpire() {
            
            let pref = UserDefaults.standard
            pref.setValue(nil , forKey: "userinfo")
            
            
            pref.synchronize()
           
        }
    
        
        func dismissModalStack(animated: Bool, completion: (() -> Void)?) {
            let fullscreenSnapshot = UIApplication.shared.delegate?.window??.snapshotView(afterScreenUpdates: false)
            if !isBeingDismissed {
                var rootVc = presentingViewController
                while rootVc?.presentingViewController != nil {
                    rootVc = rootVc?.presentingViewController
                }
                let secondToLastVc = rootVc?.presentedViewController
                if fullscreenSnapshot != nil {
                    secondToLastVc?.view.addSubview(fullscreenSnapshot!)
                }
                secondToLastVc?.dismiss(animated: true, completion: {
                    rootVc?.dismiss(animated: true, completion: completion)
                })
            }
        }
    
        
    }
    
    
    
extension String {
    
    // urlencode
    var URLEncoded:String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharset = CharacterSet(charactersIn: unreservedChars)
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: unreservedCharset)
        return encodedString ?? self
    }
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.characters.count>=6 && self.characters.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
}

extension UITextField {
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func removeBottomBorder() -> Void {
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    func changeBottomBorderColor() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = Style.themeColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
