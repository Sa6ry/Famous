//
//  DatabaseManager.m
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/27/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import "DatabaseManager.h"


@interface DatabaseManager()
@end

@implementation DatabaseManager


+(DatabaseManager*) sharedInstance
{
    static dispatch_once_t onceToken;
    static DatabaseManager *sharedObj = nil;
    dispatch_once(&onceToken, ^{
        sharedObj = [DatabaseManager alloc];
        [sharedObj prepareDatabase];
    });
    return sharedObj;
}

#pragma mark -


-(void) prepareDatabase
{
    // load the json file
    
    NSData* jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"database/speeches_list" ofType:@"json"]];
    
    NSMutableArray* jsonSpeeches = [NSJSONSerialization
                            JSONObjectWithData:jsonData
                            options:NSJSONReadingMutableContainers
                            error:nil];
    
    NSMutableArray<Speech*>* speechesArray = [NSMutableArray array];
    
    // convert it to an array of objects
    [jsonSpeeches enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [speechesArray addObject:[[Speech alloc] initWithDictionary:obj] ];
        
    }];
    
    // save non mutable copy
    self.speeches = [NSArray arrayWithArray:speechesArray];
}


@end
