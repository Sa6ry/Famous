//
//  SpeechDetailTableViewController.h
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/28/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Speech.h"

@interface SpeechDetailTableViewController : UITableViewController <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatingLabel;

@property (nonatomic,strong) Speech* speech;

@end
