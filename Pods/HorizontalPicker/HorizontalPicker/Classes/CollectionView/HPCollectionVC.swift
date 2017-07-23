//
//  HPCollectionVC.swift
//  HorizontalPickerDemo
//
//  Created by Bernd Rabe on 13.12.15.
//  Copyright © 2015 RABE_IT Services. All rights reserved.
//

import UIKit

protocol HPCollectionVCProvider {
    func numberOfRowsInCollectionViewController (_ controller: HPCollectionVC) -> Int
    func collectionViewController (_ controller: HPCollectionVC, titleForRow row: Int) -> String
    func collectionViewController (_ controller: HPCollectionVC, didSelectRow row: Int)
}

class HPCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var provider: HPCollectionVCProvider?
    
    var maxElementWidth: CGFloat = 0.0
    var font: UIFont             = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
    var useTwoLineMode           = true
    var textColor                = UIColor.lightGray
    var selectedCellIndexPath    = IndexPath(item: 0, section: 0) {
        didSet {
            self.provider?.collectionViewController(self, didSelectRow: selectedCellIndexPath.row)
        }
    }
    
    
    // MARK: - Public API
    
    func selectedRow () -> Int {
        return selectedCellIndexPath.row
    }
    
    func selectRowAtIndex (_ index: Int, animated: Bool) {
        if let collectionView = collectionView {
            scrollToIndex(index, animated: animated)
            changeSelectionForCellAtIndexPath(IndexPath(item: index, section: 0), collectionView: collectionView)
        }
    }
    
    // MARK: - UICollectionViewDelegate/UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider?.numberOfRowsInCollectionViewController(self) ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseId = HPCollectionViewCellConstants.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! HPCollectionViewCell
        configureCollectionViewCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToIndex(indexPath.row, animated: true)
        selectedCellIndexPath = indexPath
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = provider?.collectionViewController(self, titleForRow: indexPath.row) ?? " "
        return sizeForText(text, maxSize: CGSize(width: maxElementWidth, height: collectionView.bounds.height))
    }
    
    // MARK: - UIScrollviewDelegate
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToPosition(scrollView)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            scrollToPosition(scrollView)
        }
    }
    
    func scrollToPosition(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView, let item = indexPathForCenterCellFromCollectionview(collectionView) {
            scrollToIndex(item.row, animated: true)
            changeSelectionForCellAtIndexPath(item, collectionView: collectionView)
        }
    }
    
    func indexPathForCenterCellFromCollectionview (_ collectionView: UICollectionView) -> IndexPath? {
        let point = collectionView.convert(collectionView.center, from: collectionView.superview)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return collectionView.indexPathsForVisibleItems.first }
        return indexPath
    }
    
    // MARK: - Helper
    
    func sizeForText (_ text: String, maxSize: CGSize) -> CGSize {
        var frame = (text as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: NSStringDrawingContext())
        frame = frame.integral
        frame.size.width += 16.0 // give it some room at both ends
        
        return frame.size
    }
    
    fileprivate func configureCollectionViewCell (_ cell: HPCollectionViewCell, atIndexPath indexPath: IndexPath) {
        if let provider = provider {
            cell.text = provider.collectionViewController(self, titleForRow: indexPath.row)
            cell.isSelected = selectedCellIndexPath == indexPath
            cell.delegate = self
        }
    }
    
    fileprivate func scrollToIndex (_ index: Int, animated: Bool) {
        let indexPath = IndexPath(item: index, section: 0)
        guard let cv = collectionView, let attributes = cv.layoutAttributesForItem(at: indexPath) else {
            return
        }
        
        let halfWidth = cv.frame.width / CGFloat(2.0)
        let offset = CGPoint(x: attributes.frame.midX - halfWidth, y: 0)
        cv.setContentOffset(offset, animated: animated)
    }
    
    fileprivate func changeSelectionForCellAtIndexPath (_ indexPath: IndexPath, collectionView: UICollectionView) {
        HorizontalPickerView.delay(0.1) { [unowned self] () -> () in
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            self.selectedCellIndexPath = indexPath
        }
    }
    
}

extension HPCollectionVC: HPCollectionViewCellDelegate {
    func useTwolineModeForCollectionViewCell(_ cvCell: HPCollectionViewCell) -> Bool {
        return useTwoLineMode
    }
    
    func fontForCollectionViewCell(_ cvCell: HPCollectionViewCell) -> UIFont {
        return font
    }
    
    func textColorForCollectionViewCell(_ cvCell: HPCollectionViewCell) -> UIColor {
        return textColor
    }
}


