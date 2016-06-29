//
//  MaxCountWordFinder.m
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/28/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import "MaxCountWordFinder.h"
#import <UIKit/UIKit.h>

@interface MaxCountWordFinder()
@property (nonatomic,strong) NSString* inputString;
@property (nonatomic,strong) NSSet* transitionWords;
@property (nonatomic,strong) NSSet* prepositions;
@end

@implementation MaxCountWordFinder

- (instancetype)initWithString:(NSString*) inputString
{
    self = [super init];
    if (self) {
        self.inputString = inputString;
    }
    
    
    return self;
}

// runs call backs in the caller queue
-(void) findMaxWordWithProgressMinStep:(float)progressMinStep progress:(void (^ __nullable)(float progress))progress completion:(void (^ __nullable)(NSString*  _Nullable maxWordString))completion;
{
    //[NSOperationQueue currentQueue];
    
    // ref http://nshipster.com/nslinguistictagger/
    // ref https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSLinguisticTagger_Class/
    
    // save the current queue
    NSOperationQueue* callerQeue = [NSOperationQueue currentQueue];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        
        NSMutableDictionary* wordCountDic = [NSMutableDictionary dictionary];
        __block NSUInteger maxWordCount = 0;
        __block NSString* maxWordString = nil;
        
        __block float nextProgressUpdate = 0;
        
        NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
        NSArray* schemes = [NSLinguisticTagger availableTagSchemesForLanguage:@"en"];
        NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:schemes options:options];
        [tagger setString:self.inputString];
        [tagger enumerateTagsInRange:NSMakeRange(0, self.inputString.length)
                              scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass
                             options:options
                          usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
                              
                              if([tag isEqualToString:NSLinguisticTagNoun] ||
                                 [tag isEqualToString:NSLinguisticTagPersonalName] ||
                                 [tag isEqualToString:NSLinguisticTagPlaceName] ||
                                 [tag isEqualToString:NSLinguisticTagOrganizationName]) {
                                  
                                  NSString* subString = [self.inputString substringWithRange:tokenRange];
                                  NSString* subStringLowerCase = subString.lowercaseString;
                                  
                                  ////////////////////////////////////////////////////////
                                  // 1- get the word count
                                  // 2- save the word in the dictioanry
                                  NSUInteger wordCount = [[wordCountDic valueForKey:subStringLowerCase] integerValue];
                                  wordCount = wordCount + 1;
                                  [wordCountDic setValue:@(wordCount) forKey:subStringLowerCase];
                                  if(maxWordCount <= wordCount) {
                                      maxWordString = subString;
                                  }
                                  maxWordCount = MAX(maxWordCount, wordCount);
                              }
                              
                              // update the progress
                              CGFloat currentProgress = MIN(1.0f, (float)(tokenRange.location+tokenRange.length) / self.inputString.length );
                              
                              if(progress && currentProgress >= nextProgressUpdate  ) {
                                  [callerQeue addOperationWithBlock:^{
                                      progress( currentProgress );
                                  }];
                              }
                              
                              nextProgressUpdate = currentProgress + progressMinStep;
                              
                          }];
        
        if(completion) {
            [callerQeue addOperationWithBlock:^{
                completion(maxWordString);
            }];
        }
        
    });
    
    
    
}

@end
