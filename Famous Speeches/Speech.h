//
//  Speech.h
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/27/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Speech : NSObject

@property (nonatomic,readonly) NSString* _Nonnull name;
@property (nonatomic,readonly) NSString* _Nonnull by;
@property (nonatomic,readonly) NSString* _Nonnull date;
@property (nonatomic,readonly) UIImage* _Nonnull image;
@property (nonatomic,readonly) NSString* _Nonnull text;

- (instancetype _Nullable) init __attribute__((unavailable("Must use initWithDictionary: instead.")));
- (instancetype _Nullable) initWithDictionary:(NSDictionary* _Nonnull)data;

@end
