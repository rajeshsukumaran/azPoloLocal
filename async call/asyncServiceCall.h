//
//  asyncServiceCall.h
//  async call
//
//  Created by Kamal on 10/23/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol asyncCallProtocol <NSObject>

-(void)receivedResponse:(NSDictionary*)parsedResponse ;
-(void)failedStatus:(NSError *)error;

@end


@interface asyncServiceCall :NSObject<NSURLConnectionDelegate>
@property(strong,nonatomic)id<asyncCallProtocol>delegate;
-(void)makeTheServiceCall:(NSString *)url withPostData:(NSString *)postData;
-(NSDictionary *)parseJsonOnPlist:(NSString *)plistPath withServiceResponse:(NSMutableData *)responseData usingServiceName:(NSString *)serviceName;
-(NSDictionary *)parseJson:(NSDictionary *)ServiceResponse withDefinition:(NSDictionary *)definition keyForRecursion:(NSString *)key;
@end
