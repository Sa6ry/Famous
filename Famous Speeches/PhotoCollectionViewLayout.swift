//
//  PhotoCollectionViewLayout.swift
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/29/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

import Foundation


import UIKit

// extend the delegate
@objc protocol PhotoCollectionViewDelegate : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, ratioForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    
    func collectionViewNoOfColumns(collectionView: UICollectionView) -> Int
    
    func collectionViewCellSpacing(collectionView: UICollectionView) -> Int
}

// the default values for the above protocal
extension PhotoCollectionViewDelegate {
    
    func collectionViewNoOfColumns(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionViewCellSpacing(collectionView: UICollectionView) -> Int {
        return 10
    }
}

class PhotoCollectionViewLayout: UICollectionViewLayout {
    
    var columnsHeight = Array<Int>()
    var cellItemsAttribute = Array<UICollectionViewLayoutAttributes>()
    
    var contentSize = CGSizeMake(0, 0)
    
    var collapseToIndex : NSIndexPath? = nil//NSIndexPath(forItem: 2, inSection: 0)
    
    var cellSpacing: CGFloat {
        get {
            return CGFloat(self.myCollectionViewDelegate.collectionViewCellSpacing(self.collectionView!))
        }
    }
    var myCollectionViewDelegate : PhotoCollectionViewDelegate {
        get {
            return  self.collectionView!.delegate as! PhotoCollectionViewDelegate
        }
    }
    
    var noOfColumns : Int {
        get {
            return self.myCollectionViewDelegate.collectionViewNoOfColumns(self.collectionView!)
        }
    }
    
    var bounds : CGRect {
        get {
            return self.collectionView!.bounds
        }
    }
    
    var noOfItems : Int {
        get {
            return self.collectionView!.numberOfItemsInSection(0)
        }
    }
    
    var shortestColumnIndex: Int {
        get {
            var min = Int.max
            var position = -1
            for (index,value) in self.columnsHeight.enumerate() {
                if value < min{
                    min = value
                    position = index
                }
            }
            return position
        }
    }
    
    var cellWidth: CGFloat {
        get {
            let allSpaces = CGFloat(self.noOfColumns+1)*self.cellSpacing
            return floor((self.bounds.size.width - allSpaces)/CGFloat(noOfColumns))
        }
    }
    
    var lastCellWidth : CGFloat {
        get {
            let allSpaces = CGFloat(self.noOfColumns+1)*self.cellSpacing
            return self.bounds.size.width - allSpaces - cellWidth * CGFloat(self.noOfColumns - 1)
        }
    }
    
    func initialize () {
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    required override init() {
        super.init()
        self.initialize()
    }
    
    
    override class func invalidationContextClass() -> AnyClass {
        return PhotoInvalidationContext.self
    }
    
    func computeCellItemsAttribute() {
        
        //Prepare data
        self.columnsHeight.removeAll()
        self.cellItemsAttribute.removeAll()
        self.contentSize = self.collectionView!.bounds.size
        
        // Starting value for columsn height is zero
        for _  in 0..<self.noOfColumns
        {
            self.columnsHeight.append(Int(self.cellSpacing)) // top hight
        }
        
        for i in 0..<self.noOfItems {
            
            // Update the column index
            let currentColumnIndex =  self.shortestColumnIndex
            
            let currentCellWidth = currentColumnIndex + 1 == self.noOfColumns ? lastCellWidth : cellWidth
            
            let suggestedSize = self.myCollectionViewDelegate.collectionView(self.collectionView!, layout: self, ratioForItemAtIndexPath: NSIndexPath(forRow: i, inSection: 0))
            
            let currentCellHeight = currentCellWidth * suggestedSize.height / suggestedSize.width
            
            
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forRow: i, inSection: 0))
            
            
            attribute.frame = CGRectMake(CGFloat(currentColumnIndex)*cellWidth + CGFloat(currentColumnIndex+1)*CGFloat(self.cellSpacing),
                                         CGFloat(self.columnsHeight[currentColumnIndex]) ,
                                         currentCellWidth,
                                         currentCellHeight)
            
            // update the current columns height
            columnsHeight[ currentColumnIndex ] = columnsHeight[ currentColumnIndex ] + Int( currentCellHeight) + Int(self.cellSpacing)
            
            // save this attribute
            self.cellItemsAttribute.append(attribute)
            
            // update the content size
            self.contentSize = CGRectUnion(CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), attribute.frame).size
            self.contentSize.height = self.contentSize.height + CGFloat(self.cellSpacing)
        }
    }
    
    override func prepareLayout() {
        
        super.prepareLayout()
        // Get the number of sectins
        self.computeCellItemsAttribute()
        
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let invalidationContext = super.invalidationContextForBoundsChange(newBounds) as! PhotoInvalidationContext
        
        guard let oldBounds = collectionView?.bounds else { return invalidationContext }
        guard oldBounds != newBounds else { return invalidationContext }
        
        let originChanged = !CGPointEqualToPoint(oldBounds.origin, newBounds.origin)
        let sizeChanged = !CGSizeEqualToSize(oldBounds.size, newBounds.size)
        
        if sizeChanged {
            invalidationContext.shouldInvalidateEverything = true
        } else {
            invalidationContext.shouldInvalidateEverything = false
        }
        
        if originChanged {
            invalidationContext.invalidateSectionHeaders = true
        }
        
        return invalidationContext
    }
    
    override func invalidateLayoutWithContext(context: UICollectionViewLayoutInvalidationContext) {
        let invalidationContext = context as! PhotoInvalidationContext
        
        guard invalidationContext.invalidateEverything || invalidationContext.invalidateSectionHeaders else { return }
        
        guard !invalidationContext.invalidateEverything else {
            super.invalidateLayoutWithContext(invalidationContext)
            return
        }
        
        super.invalidateLayoutWithContext(invalidationContext)
    }
    
    override func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cellItemsAttribute.filter({
            $0.indexPath == indexPath
        }).first
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return  self.cellItemsAttribute.filter({
            CGRectIntersectsRect(rect, $0.frame) || CGRectContainsRect(rect, $0.frame)
        })
    }
}