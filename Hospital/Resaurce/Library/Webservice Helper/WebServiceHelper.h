//
//  WebServiceHelper.h
//  NavDemo
//
//  Created by ajeet singh on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol WebServiceHelperDelegate;

@interface WebServiceHelper : NSObject<NSXMLParserDelegate> {
	NSString *XMLNameSpace;
	NSString *XMLURLAddress;
	NSString *MethodName;
	NSString *SOAPActionURL;
	NSMutableDictionary *MethodParameters;
	NSMutableString *MethodParametersAsString;
	
	NSString *MethodResult;
	BOOL ReturnStrFound;
	NSString *ReturnStr;
	
	NSXMLParser *xmlParser;
	
	id<WebServiceHelperDelegate> delegate;
	
	NSString *currentCall;
    
	
	NSMutableData *myData;
	
}
@property(nonatomic, copy) NSString *XMLNameSpace;
@property(nonatomic, copy) NSString *XMLURLAddress;
@property(nonatomic, copy) NSString *MethodName;
@property(nonatomic, strong) NSMutableDictionary *MethodParameters;
@property(nonatomic, copy) NSString *SOAPActionURL;
@property(nonatomic, strong) NSMutableString *MethodParametersAsString;
@property(nonatomic,copy) NSString *MethodResult;
@property(nonatomic,copy) NSString *ReturnStr;

@property(nonatomic,strong) id<WebServiceHelperDelegate> delegate;

@property(nonatomic,copy) NSString *currentCall;

@property(nonatomic,strong) NSMutableData *myData;

-(void)initiateConnection;
-(NSString *)getURLEncodedString:(NSString *)stringvalue;
@end

@protocol WebServiceHelperDelegate
-(void)WebServiceHelper:(WebServiceHelper *)editor didFinishWithResult:(BOOL)result;
@end