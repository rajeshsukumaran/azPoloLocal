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
-(void)insertArrayIntoDBTable:(NSArray *)arrayBundle dbTableAs:(NSString *)tableName plistDicName:(NSString *)keyName;
{
	NSString *insertQuery=[[NSMutableString alloc] init];
	@try {
		NSArray *insertData=arrayBundle;
		insertQuery =[insertQuery stringByAppendingString:@"INSERT INTO "];
		insertQuery=[insertQuery stringByAppendingString:tableName];
		insertQuery=[insertQuery stringByAppendingString:@"("];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"dbList" ofType:@"plist"];
		NSDictionary *dbFields = [[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:keyName];
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
				if(value)
				{
					insertQuery =[insertQuery stringByAppendingFormat:@"\"%@\"",value];
					insertQuery =[insertQuery stringByAppendingString:@","];
				}
				else
				{
					NSLog(@"row skipped because null or empty value found");
				}
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
-(void)insertIntoSegmentTable:(NSDictionary *)bundle
{
	NSArray *argAray=[[[bundle objectForKey:@"GetAuthorisedUserDetailsResult"]objectForKey:@"ResultData" ] objectForKey:@"SegmentList"];
	[self insertArrayIntoDBTable:argAray dbTableAs:@"tblSegments" plistDicName:@"tblSegments"];
}
-(void)insertIntoBrandTable:(NSDictionary *)bundle
{
	NSArray *argAray=[[[bundle objectForKey:@"GetAuthorisedUserDetailsResult"]objectForKey:@"ResultData" ] objectForKey:@"UserBrandsList"];
	[self insertArrayIntoDBTable:argAray dbTableAs:@"tblBrands" plistDicName:@"tblBrands"];
}
@end
