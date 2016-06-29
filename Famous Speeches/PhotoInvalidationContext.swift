//
//  PhotoInvalidationContext.swift
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/29/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

import UIKit


class PhotoInvalidationContext: UICollectionViewLayoutInvalidationContext {
    var invalidateSectionHeaders = false
    var shouldInvalidateEverything = true
    
    override var invalidateEverything: Bool {
        return shouldInvalidateEverything
    }
}

