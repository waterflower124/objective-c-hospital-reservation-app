//
//  WebServiceHelper.m
//  NavDemo
//
//  Created by ajeet singh on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebServiceHelper.h"

@implementation WebServiceHelper

@synthesize MethodName;
@synthesize MethodParameters;
@synthesize XMLNameSpace;
@synthesize XMLURLAddress;
@synthesize SOAPActionURL;
@synthesize MethodParametersAsString;
@synthesize MethodResult;
@synthesize ReturnStr;

@synthesize delegate;

@synthesize currentCall;


@synthesize myData;



- (void)initiateConnection
{
	
	[self setXMLNameSpace:@"http://tempuri.org/"];
    [self setXMLURLAddress:[@"" stringByAppendingFormat:@"%@%@",SERVER_URL,MethodName]];

	//The URL of the Webserver
	
    NSURL *myWebserverURL = [NSURL URLWithString:XMLURLAddress];
	NSLog(@"My Url:- %@",myWebserverURL);
    // Use the private method setAllowsAnyHTTPSCertificate:forHost:
    // to not validate the HTTPS certificate.  This is used if you are using a testing environment and have
    // a sample SSL certificate set up
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[myWebserverURL host]]; //TODO this can be used for testing only app will get rejected also remove this line before you submit to apple.
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myWebserverURL];
	[request setTimeoutInterval:239];
    // Add the Required WCF Header Values.  This is what the WCF service expects in the header.
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // [request addValue:self.SOAPActionURL forHTTPHeaderField:@"SOAPAction"];
	// Set the action to Post
    [request setHTTPMethod:@"GET"];
    // Set the body
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSData *postData = [MethodParametersAsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    [request addValue:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    
    
	
//	NSError *WSerror=nil;
//	NSURLResponse *WSresponse=nil;
//	// Call the xml service and return response into a MutableData object
//	NSMutableData *myMutableData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request returningResponse:&WSresponse error:&WSerror];
	
	myData =[[NSMutableData alloc] init];
    
    
	[NSURLConnection connectionWithRequest:request delegate:self];
	
	//NSLog(@"%@",[[NSString alloc] initWithData:myMutableData encoding:NSUTF8StringEncoding]);
	
	//[self setReturnStr:[[NSString alloc] initWithData:myMutableData encoding:NSASCIIStringEncoding]];
	/*if (WSerror) {
     if(delegate!=nil)
     {
     [delegate WebServiceHelper:self	didFinishWithResult:NO];
     }
     //NSLog(@"Connection Error: %@", [WSerror description], nil);
     }*/
	
    /*	if(xmlParser)
     {
     [xmlParser release];
     xmlParser = nil;
     }
     xmlParser = [[NSXMLParser alloc] initWithData: myMutableData];		
     [xmlParser setDelegate:self];
     [xmlParser setShouldResolveExternalEntities:NO];
     [xmlParser setShouldProcessNamespaces:NO];
     [xmlParser setShouldReportNamespacePrefixes:NO];
     [xmlParser parse];
     */	
	
    //	[self setReturnStr:[[[[ReturnStr componentsSeparatedByString:MethodResult] objectAtIndex:1] substringFromIndex:1] substringToIndex:[[[[ReturnStr componentsSeparatedByString:MethodResult] objectAtIndex:1] substringFromIndex:1] length]-2 ]];
	
	
} 

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[myData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
	/*
	
	if(xmlParser)
	{
		[xmlParser release];
		xmlParser = nil;
	}*/
    NSString *special = [[NSString alloc] initWithBytes:[myData bytes] length:[myData length] encoding:NSASCIIStringEncoding];
    NSString *general = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    
    if (general == nil)
        [self setReturnStr: special]; //[[NSString alloc] initWithData:[myData  encoding:NSUTF8StringEncoding ]];
    else
        [self setReturnStr: general];
    if ([self.MethodName isEqualToString:@"geocode/json"]) {
      //  NSLog(@"==============================\n%@",self.ReturnStr);
    }
    
   
	
	// Replace Special char.. 
	
	//[self setReturnStr:[[self ReturnStr] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
	//[self setReturnStr:[[self ReturnStr] stringByReplacingOccurrencesOfString:@"'" withString:@""]];
	
	
	if(delegate!=nil)
	{
		[delegate WebServiceHelper:self	didFinishWithResult:YES];
	}
	/*xmlParser = [[NSXMLParser alloc] initWithData: myData];		
	[xmlParser setDelegate:self];
	[xmlParser setShouldResolveExternalEntities:NO];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser parse];*/
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	
	//NSLog(@"%@",error);
	
	if(delegate!=nil)
	{
		[delegate WebServiceHelper:self	didFinishWithResult:YES];
	}
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //	NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	
	if(delegate!=nil)
	{
		[delegate WebServiceHelper:self	didFinishWithResult:NO];
	}
	/*
     NSString * errorString = [NSString stringWithFormat:@"Error (Error code %i )", [parseError code]];
     UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading data" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [errorAlert show];
     [errorAlert release];
	 */
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    //	NSLog(@"didStartElement");
	ReturnStrFound = ([elementName isEqualToString:MethodResult])?YES:NO;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//NSLog(@"foundCharacters");
	if(ReturnStrFound)
	{
		//[self setReturnStr:string];
          [self setReturnStr:[self.ReturnStr stringByAppendingString:string]];
        //	self.ReturnStr=string;
       // NSLog(@"%@",ReturnStr);
        
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
   
	//NSLog(@"didEndElement");
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	//NSLog(@"parserDidEndDocument");
	if(delegate!=nil)
	{
		[delegate WebServiceHelper:self	didFinishWithResult:YES];
	}
	
}

-(NSString *)getURLEncodedString:(NSString *)stringvalue{
	NSString * encodedString = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																				   NULL,
																				   ( CFStringRef)stringvalue,
																				   NULL,
																				   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				   kCFStringEncodingUTF8 ));
	return encodedString;
}


@end
