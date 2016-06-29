//
//  MaxCountWordFinder.h
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/28/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaxCountWordFinder : NSObject

- (instancetype _Nullable) init __attribute__((unavailable("Must use initWithString: instead.")));

- (instancetype _Nullable)initWithString:(NSString* _Nonnull) inputString;

// runs call backs in the caller queue
-(void) findMaxWordWithProgressMinStep:(float)progressMinStep progress:(void (^ __nullable)(float progress))progress completion:(void (^ __nullable)(NSString*  _Nullable maxWordString))completion;

@end
