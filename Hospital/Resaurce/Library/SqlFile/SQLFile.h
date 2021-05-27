//
//  SQLFile.h
//  MEDICINES
//
//  Created by R on 11/06/2015.
//  Copyright (c) 2015 Redixbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AppDelegate.h"


@interface SQLFile : NSObject
{
    sqlite3 *database;
    AppDelegate *appd;
    NSString *strdbname;
    
}

@property(strong,nonatomic)AppDelegate *appd;


-(BOOL)operationdb:(NSString *)str;
-(NSMutableArray *)select_favou:(NSString *)strqr;

@end
