//  HorizontalPickerView.swift
//  HorizontalPickerDemo
//
//  Created by Bernd Rabe on 13.12.15.
//  Copyright © 2015 RABE_IT Services. All rights reserved.
//

import UIKit

/** Constants
 - pathCornerRadii: The corner radii used for the mask shape.
 - strokeColor: The color use for the shapeLayers' strokeColor
 - maxLabelWidthFactor: Defines the max width of one entry as percentage of the picker views width.
 */
struct HorizontalPickerViewConstants {
    static let pathCornerRadii              = CGSize(width: 10, height: 5)
    static let maxLabelWidthFactor: CGFloat = 0.5    // defines how man width space a single element can occupy as portion of the total width
    static let maxRotationAngle: Float      = -60.0  // elements are rotated around the y axis depending on the distance from the center
}

public protocol HorizontalPickerViewDataSource {
    func numberOfRowsInHorizontalPickerView (_ pickerView: HorizontalPickerView) -> Int
}

@objc public protocol HorizontalPickerViewDelegate {
    func horizontalPickerView (_ pickerView: HorizontalPickerView, titleForRow: Int) -> String
    func horizontalPickerView (_ pickerView: HorizontalPickerView, didSelectRow: Int)
    
    @objc optional func textFontForHorizontalPickerView (_ pickerView: HorizontalPickerView) -> UIFont
    @objc optional func textColorForHorizontalPickerView (_ pickerView: HorizontalPickerView) -> UIColor
    @objc optional func useTwoLineModeForHorizontalPickerView (_ pickerView: HorizontalPickerView) -> Bool
    @objc optional func pickerViewShouldMask (_ pickerView: HorizontalPickerView) -> Bool
}

/** A similar to UIPicker but horizontal picker view.
*/
open class HorizontalPickerView: UIView {
    
    // MARK: - Public API
    
    open var dataSource: HorizontalPickerViewDataSource?
    open var delegate: HorizontalPickerViewDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if dataSource != nil && delegate != nil {
            if isInitialized == false {
                isInitialized = true
                if let view = collectionController.collectionView {
                    view.frame = self.bounds
                    addSubview(view)
                }
            }
            
            if let view = collectionController.collectionView, let layout = collectionController.collectionViewLayout as? HPCollectionViewFlowlayout {
                layout.activeDistance   = floor(view.bounds.width / 2.0)
                layout.midX             = ceil(view.bounds.midX)
                if let numberOfElements = self.dataSource?.numberOfRowsInHorizontalPickerView(self) {
                    layout.lastElementIndex = numberOfElements - 1
                }
                
                collectionController.maxElementWidth = self.bounds.width * HorizontalPickerViewConstants.maxLabelWidthFactor
                
                if let firstElement = delegate?.horizontalPickerView(self, titleForRow: 0), let lastElement = delegate?.horizontalPickerView(self, titleForRow: layout.lastElementIndex) {
                    layout.sectionInset.left  = layout.midX - collectionController.sizeForText(firstElement, maxSize: view.bounds.size).width / CGFloat(2)
                    layout.sectionInset.right = layout.midX - collectionController.sizeForText(lastElement,  maxSize: view.bounds.size).width / CGFloat(2)
                }
                
                HorizontalPickerView.delay(0.1, completion: { () -> () in
                    view.selectItem(at: self.collectionController.selectedCellIndexPath, animated: false, scrollPosition: .centeredHorizontally)
                })
            }
            if delegate?.pickerViewShouldMask?(self) ?? false {
                layer.mask = shapeLayer
                shapeLayer.path = shapePathForFrame(bounds).cgPath
            }
        }
    }
    
    // MARK:
    
    open func selectedRow () -> Int {
        return collectionController.selectedCellIndexPath.row
    }
    
    open func selectRow (_ rowIndex: Int, animated: Bool) {
        collectionController.selectRowAtIndex(rowIndex, animated: animated)
    }
    
    open func reloadAll () {
        collectionController.collectionView?.reloadData()
    }
    
    // MARK: - Helper
    
    static func delay (_ duration: TimeInterval, completion:@escaping ()->() ) {
        DispatchQueue.main.asyncAfter( deadline: DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: completion)
    }
    
    // MARK: - Private Interface
    
    fileprivate var isInitialized = false
    
    fileprivate lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer           = CAShapeLayer()
        shapeLayer.frame         = self.bounds
        shapeLayer.contentsScale = UIScreen.main.scale
        
        return shapeLayer
    }()
    
    fileprivate lazy var collectionController: HPCollectionVC = {
        let layout = HPCollectionViewFlowlayout()
        let collectionController = HPCollectionVC(collectionViewLayout: layout)
        collectionController.provider               = self
        collectionController.maxElementWidth        = self.bounds.width * HorizontalPickerViewConstants.maxLabelWidthFactor
        collectionController.font                   = self.delegate?.textFontForHorizontalPickerView?(self) ?? UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        collectionController.textColor              = self.delegate?.textColorForHorizontalPickerView?(self) ?? UIColor.lightGray
        collectionController.useTwoLineMode         = self.delegate?.useTwoLineModeForHorizontalPickerView?(self) ?? false
        collectionController.collectionView?.register(HPCollectionViewCell.self, forCellWithReuseIdentifier: HPCollectionViewCellConstants.reuseIdentifier)
        collectionController.collectionView?.backgroundColor = UIColor.clear
        collectionController.collectionView?.showsHorizontalScrollIndicator = false
        collectionController.clearsSelectionOnViewWillAppear = false
        
        return collectionController
    }()
    
    fileprivate func setUp () {
        autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
    }
    
    fileprivate func shapePathForFrame(_ frame: CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: frame, byRoundingCorners: .allCorners, cornerRadii: HorizontalPickerViewConstants.pathCornerRadii)
    }
}

extension HorizontalPickerView: HPCollectionVCProvider {
    func numberOfRowsInCollectionViewController(_ controller: HPCollectionVC) -> Int {
        return self.dataSource?.numberOfRowsInHorizontalPickerView(self) ?? 0
    }
    
    func collectionViewController(_ controller: HPCollectionVC, didSelectRow row: Int) {
        self.delegate?.horizontalPickerView(self, didSelectRow: row)
    }
    
    func collectionViewController(_ controller: HPCollectionVC, titleForRow row: Int) -> String {
        return self.delegate?.horizontalPickerView(self, titleForRow: row) ?? ""
    }
}
