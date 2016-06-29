//
//  DatabaseManager.h
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/27/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Speech.h"

@interface DatabaseManager : NSObject

+( DatabaseManager* _Nonnull ) sharedInstance;

- (instancetype _Nullable) init __attribute__((unavailable("Must use [DatabaseManager sharedInstance] instead.")));

@property (nonatomic,retain) NSArray<Speech* >* _Nonnull speeches;

@end
