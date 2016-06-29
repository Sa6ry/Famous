//
//  SpeechCollectionViewCell.h
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/27/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface SpeechCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *byLabel;
@end
