//
//  asyncServiceCall.m
//  async call
//
//  Created by Rajesh on 10/23/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "asyncServiceCall.h"

@implementation asyncServiceCall
NSMutableData *_responseData;
@synthesize delegate;

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [_responseData setLength:0];
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
         
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSString * strData1= [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
   
    NSString *gblStr=[[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"sample" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *temp= [self parseJsonOnPlist:servicePlist withServiceResponse:[gblStr dataUsingEncoding:NSUTF8StringEncoding] usingServiceName:@"GetAuthorisedUserDetailsResult"];
    
    [delegate receivedResponse:temp];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [delegate failedStatus:error];
}


#pragma mark Json Parsing Method
-(NSDictionary *)parseJsonOnPlist:(NSString *)plistPath withServiceResponse:(NSMutableData *)responseData usingServiceName:(NSString *)serviceName
{
    NSMutableDictionary *dbWithServiceValues=[[NSMutableDictionary alloc]init];
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:plistPath ofType:@"plist"];
    NSDictionary *arrayFromFile = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

    dbWithServiceValues=[[self parseJson:json withDefinition:arrayFromFile keyForRecursion:@""] mutableCopy];
    
    NSDictionary *returnDictionary=[NSDictionary dictionaryWithDictionary:dbWithServiceValues];
    NSLog(@"parseJsonOnPlist return value %@",returnDictionary);
    return returnDictionary;
}

-(NSDictionary *)parseJson:(NSDictionary *)ServiceResponse withDefinition:(NSDictionary *)definition keyForRecursion:(NSString *)key
{
   
	
	NSMutableDictionary * returnMutableDictionary=[[NSMutableDictionary alloc]init ];
	BOOL emptycheck=FALSE;
	NSDictionary *returnDictionary;
	@try{
		NSArray *allkeys=[definition allKeys];
		for(NSString * str in allkeys){
			if([key isEqualToString:@""])
			{
				key=str;
			}
			if([ServiceResponse isKindOfClass:[NSArray class]])
			{
				emptycheck=TRUE;
			}
			else if ([ServiceResponse isKindOfClass:[NSDictionary class]])
			{
				
				
				emptycheck=TRUE;
			}
			else if ([ServiceResponse isKindOfClass:[NSString class]])
			{
				
					emptycheck=TRUE;
			}
			NSDictionary *definitionForKey=[definition objectForKey:str];
			if (emptycheck) {
				if([[ServiceResponse objectForKey:str]isKindOfClass:[NSDictionary class]] ||[[ServiceResponse objectForKey:str]isKindOfClass:[NSArray class]] ){
					NSDictionary *serviceResponseForKey=[ServiceResponse objectForKey:str];
					if ([[ServiceResponse objectForKey:str]isKindOfClass:[NSDictionary class]]) {
						NSMutableDictionary *temp;
						@try{
							if([[serviceResponseForKey objectForKey:str]isKindOfClass:[NSDictionary class]]==[[definitionForKey objectForKey:str]isKindOfClass:[NSDictionary class]])
							{
								@try {
									temp= [[self parseJson:serviceResponseForKey withDefinition:definitionForKey keyForRecursion:str] mutableCopy];
									if(temp)
										[returnMutableDictionary setValue:temp forKey:str];
									else
										[returnMutableDictionary setValue:@"" forKey:str];
									
								}
								@catch (NSException *exception) {
									NSLog(@"value not found error with exception reason: %@",[exception reason]);
								}
								
								
							}
						}
						@catch (NSException *exception)
						{
							NSLog(@"invalid arguements to method error with exception reason: %@",[exception reason]);
						}
					}
					else if ([[ServiceResponse objectForKey:str]isKindOfClass:[NSArray class]]) {
						NSMutableArray *internalArray=[[NSMutableArray alloc]init];
						NSArray *theArray=[ServiceResponse objectForKey:str];
						int theArrayCount=[theArray count];
						for(int i=0;	i<theArrayCount;i++)
						{
							NSMutableDictionary *internalDic=[[NSMutableDictionary alloc]init];
							for(NSString *itr in definitionForKey)
							{
								[internalDic setValue:theArray[i][[definitionForKey objectForKey:itr]] forKey:itr];
								if([[internalDic objectForKey:itr]isKindOfClass:[NSDictionary class]] )
								{
									NSMutableDictionary *temp;
									@try{
										if([[internalDic objectForKey:itr]isKindOfClass:[NSDictionary class]]==[[definitionForKey objectForKey:itr]isKindOfClass:[NSDictionary class]])
										{
											
											@try {
												temp= [[self parseJson:[internalDic objectForKey:itr] withDefinition:[definitionForKey objectForKey:itr] keyForRecursion:itr] mutableCopy];
												if(temp)
													[returnMutableDictionary setValue:temp forKey:str];
												else
													[returnMutableDictionary setValue:@"" forKey:str];
											}
											@catch (NSException *exception) {
												NSLog(@"value not found error with exception reason: %@",[exception reason]);
											}
											
											
										}
									}
									@catch (NSException *exception)
									{
										NSLog(@"invalid arguements to method error with exception reason: %@",[exception reason]);
									}
								}
							}
							[internalArray addObject:internalDic];
							[returnMutableDictionary setValue:internalArray forKey:str];
						}
					}
				}
				else if ([[ServiceResponse objectForKey:str]isKindOfClass:[NSString class]]||[[NSNumber numberWithInt:[[ServiceResponse objectForKey:str] intValue]] isKindOfClass:[NSNumber class]])
				{
					
					@try {
						NSString * value=[ServiceResponse objectForKey:[definition objectForKey:str]];
						if(value)
							[returnMutableDictionary setValue:value forKey:str];
						else
							[returnMutableDictionary setValue:@"" forKey:str];
					}
					@catch (NSException *exception) {
						NSLog(@"value not found error with exception reason: %@",[exception reason]);
					}
					
					NSString * value=[ServiceResponse objectForKey:[definition objectForKey:str]];
					
				}
				else
				{
					NSLog(@"something wrong");
				}
			}
		}
		returnDictionary=[NSDictionary dictionaryWithDictionary:returnMutableDictionary];
	}
	@catch (NSException *exception)
	{
		NSLog(@"method call failed with exception reason: %@",[exception reason]);
	}

	return returnDictionary;
	// return Nil;
}


#pragma mark make async service call

-(void)makeTheServiceCall:(NSString *)url withPostData:(NSString *)postData
{
   
    
    NSString *post = @" ";
    NSData *postDataParam = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postDataParam];

    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn)
    {
        _responseData = [NSMutableData data];

    }
}

@end
