//
//  SpeechesCollectionViewController.h
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/27/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamousSpeeches-Swift.h"

@interface SpeechesCollectionViewController : UICollectionViewController < PhotoCollectionViewDelegate>

@property (nonatomic,readonly) UIImageView* selectedImageView;

@end
