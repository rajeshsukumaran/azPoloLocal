//
//  dbExecute.m
//  async call
//
//  Created by Solomon on 04/11/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "dbExecute.h"
#import "DBManager.h"

@implementation dbExecute
-(void)insertIntoUserTable:(NSDictionary *)bundle
{
	NSDictionary *insertData=[[bundle objectForKey:@"GetAuthorisedUserDetailsResult"]objectForKey:@"ResultData" ];
	NSString *insertQuery=[[NSMutableString alloc] init];
	@try
	{
		insertQuery =[insertQuery stringByAppendingString:@"INSERT INTO tbleUser ("];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"dbList" ofType:@"plist"];
		NSDictionary *dbFields = [[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"tbleUser"];
		NSArray *keys=[dbFields allKeys];
		for(NSString *str in keys)
		{
			insertQuery =[insertQuery stringByAppendingString:str];
			insertQuery =[insertQuery stringByAppendingString:@","];
		}
		insertQuery =[insertQuery substringToIndex:([insertQuery length]-1)];
		insertQuery =[insertQuery stringByAppendingString:@") values ("];
		for(NSString *str in keys)
		{
			NSString *value=[insertData objectForKey:str];
			insertQuery =[insertQuery stringByAppendingFormat:@"\"%@\"",value];
			insertQuery =[insertQuery stringByAppendingString:@","];
		}
		insertQuery =[insertQuery substringToIndex:([insertQuery length]-1)];
		insertQuery =[insertQuery stringByAppendingString:@")"];
		DBManager *sharedDBManager;
		sharedDBManager=[DBManager sharedDBManager];
		[sharedDBManager openDataBase];
		[sharedDBManager executeQuery:insertQuery];

		
	}
	@catch (NSException *exception) {
		NSLog(@" error with exception reason: %@",[exception reason]);
	}


}
-(void)insertIntoSegmentTable:(NSDictionary *)bundle;
{
	NSString *insertQuery=[[NSMutableString alloc] init];
	@try {
		NSArray *insertData=[[[bundle objectForKey:@"GetAuthorisedUserDetailsResult"]objectForKey:@"ResultData" ] objectForKey:@"UserBrandsList"];
		insertQuery =[insertQuery stringByAppendingString:@"INSERT INTO tblBrands ("];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"dbList" ofType:@"plist"];
		NSDictionary *dbFields = [[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"tblBrands"];
		NSArray *keys=[dbFields allKeys];
		for(NSString *str in keys)
		{
			insertQuery =[insertQuery stringByAppendingString:str];
			insertQuery =[insertQuery stringByAppendingString:@","];
		}
		insertQuery =[insertQuery substringToIndex:([insertQuery length]-1)];
		insertQuery =[insertQuery stringByAppendingString:@") values "];

		for (int i=0; i<[insertData count]; i++) {
			insertQuery =[insertQuery stringByAppendingString:@"("];
			for(NSString *str in keys)
			{
				NSString *value=insertData[i][str];
				insertQuery =[insertQuery stringByAppendingFormat:@"\"%@\"",value];
				insertQuery =[insertQuery stringByAppendingString:@","];
			}
			insertQuery =[insertQuery substringToIndex:([insertQuery length]-1)];
			insertQuery =[insertQuery stringByAppendingString:@"),"];

		}
		insertQuery =[insertQuery substringToIndex:([insertQuery length]-1)];

		DBManager *sharedDBManager;
		sharedDBManager=[DBManager sharedDBManager];
		[sharedDBManager openDataBase];
		[sharedDBManager executeQuery:insertQuery];
	}
	@catch (NSException *exception) {
		NSLog(@" error with exception reason: %@",[exception reason]);
	}

	
}
@end
