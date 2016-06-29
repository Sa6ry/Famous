//
//  Speech.m
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/27/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import "Speech.h"

// ref: http://www.artofmanliness.com/2008/08/01/the-35-greatest-speeches-in-history/

@interface Speech()
@property (nonatomic,retain) NSDictionary* data;
@end

@implementation Speech

-(id) initWithDictionary:(NSDictionary*)data
{
    self = [super init];
    if(self)
    {
        self.data = data;
    }
    return self;
}

#pragma mark - Getters
-(NSString*) name
{
    return self.data[@"name"];
}

-(NSString*) by
{
    return self.data[@"by"];
}

-(NSString*) date
{
    return self.data[@"date"];
}

-(NSString*) text
{
    NSString* txtFile = self.data[@"file"];
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[@"database/speeches_txt" stringByAppendingPathComponent:txtFile.stringByDeletingPathExtension] ofType:txtFile.pathExtension] usedEncoding:0 error:nil];
}

-(UIImage*) image
{
    NSString* imageFile = self.data[@"image"];
    // load it from the resources
    return [UIImage imageNamed:imageFile];
}


@end
