//
//  dbExecute.h
//  async call
//
//  Created by Solomon on 04/11/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dbExecute : NSObject
-(void)insertIntoUserTable:(NSDictionary *)bundle;
-(void)insertIntoSegmentTable:(NSDictionary *)bundle;
-(void)insertIntoBrandTable:(NSDictionary *)bundle;
-(void)insertArrayIntoDBTable:(NSArray *)arrayBundle dbTableAs:(NSString *)tableName plistDicName:(NSString *)keyName;


@end
