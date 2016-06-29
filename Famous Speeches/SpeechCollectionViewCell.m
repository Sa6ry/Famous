//
//  SpeechCollectionViewCell.m
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/27/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import "SpeechCollectionViewCell.h"

@interface SpeechCollectionViewCell()
@end

@implementation SpeechCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContent];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadContent];
    }
    return self;
}

// Load content from the xib file
-(void) loadContent {
    UIView *xibView = [[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class)
                                                                   owner:self
                                                                 options:nil].firstObject;
    xibView.frame = self.contentView.bounds;
    xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview: xibView];
}

@end
