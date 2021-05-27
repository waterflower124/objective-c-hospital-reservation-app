 //
//  SQLFile.m
//  MEDICINES
//
//  Created by R on 11/06/2015.
//  Copyright (c) 2015 Redixbit. All rights reserved.
//

#import "SQLFile.h"


@implementation SQLFile
@synthesize appd;
-(id)init
{
    if (self=[super init])
    {
        appd =(UIApplication *)[[UIApplication sharedApplication]delegate];
        strdbname  =[[NSString alloc]initWithString:appd.strdbpath];
        
    }
    return self;
}

-(BOOL)operationdb:(NSString *)str
{
    BOOL y=NO;
    
    if (sqlite3_open([strdbname UTF8String], &database)==SQLITE_OK)
    {
        NSString *strq =[NSString stringWithString:str];
        
        sqlite3_stmt *cstmt;
        
        NSLog(@"%@",strdbname);
//        NSInteger lastRowId = sqlite3_last_insert_rowid(@"DBMedicine1.sqlite");
//        
//        NSLog(@"%ld",(long)lastRowId);

        
        
        if (sqlite3_prepare_v2(database, [strq UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            sqlite3_step(cstmt);
            y=YES;
            
            long long lastRowId1 = sqlite3_last_insert_rowid(database);
            NSString *rowId = [NSString stringWithFormat:@"%d", (int)lastRowId1];
            NSLog(@"%@",rowId);
            
           
            self.appd=[[UIApplication sharedApplication] delegate];
//            appd.last_row_id=rowId;
//            
//            NSLog(@"%@",appd.last_row_id);
//            
//            AddMedicines *add=[[AddMedicines alloc]init];
//            add.str_rem_id=rowId;
            

        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
        
    }
    
    
    return y;
}

-(BOOL)updatedb:(NSString *)strupdate
{
    BOOL y=NO;
    if (sqlite3_open([strdbname UTF8String], &database) == SQLITE_OK)
    {
        NSString *strq =[NSString stringWithString:strupdate];
        
        sqlite3_stmt *cstmt;
       // sqlite3_bind_int(cstmt, 1,[NSString stringWithFormat:@"%d",med_id]);
        if (sqlite3_prepare_v2(database, [strq UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            sqlite3_step(cstmt);
            y=YES;
        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
    }
    return y;
}




-(NSMutableArray *)select_favou:(NSString *)strqr
{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    //   cls_medicine *cls_data =[cls_medicine new];
    
    if (sqlite3_open([strdbname UTF8String], &database)==SQLITE_OK)
    {
        NSString *userstr =[NSString stringWithString:strqr];
        sqlite3_stmt *cstmt;
        if(sqlite3_prepare_v2(database, [userstr UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(cstmt)==SQLITE_ROW)
            {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
                
                NSString *n=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,0)];
                [dic setValue:n forKey:@"id"];
                
                NSString *n0=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,1)];
                [dic setValue:n0 forKey:@"Services"];
                
                NSString *n1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,2)];
                [dic setValue:n1 forKey:@"Latitude"];
                
                NSString *n2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,3)];
                [dic setValue:n2 forKey:@"Longitude"];
                
                NSString *n3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,4)];
                [dic setValue:n3 forKey:@"Name"];
                
                NSString *n4=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,5)];
                [dic setValue:n4 forKey:@"Type"];
              //  NSLog(@"%@",dic);
                [marr addObject:dic];
            }
          //  NSLog(@"ARR =%@",marr);
        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
        
    }
    return marr;
}

                
@end
