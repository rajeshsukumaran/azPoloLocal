//
//  DBManager.m
//
//  Created by Cognizant Chennai on 7/1/13.
//
//

#import "DBManager.h"

@implementation DBManager


static FMDatabase *masterDB;
static FMResultSet *resultDB;

 

+(id)sharedDBManager
{
    static DBManager *sharedDBInstance=nil;
    
    if(sharedDBInstance==nil)
    {
        sharedDBInstance=[[self alloc]init];
        

    }
    
    return sharedDBInstance;
}

-(void)createDataBase {
    NSString *strDBName;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir = [documentPaths objectAtIndex:0];
    strDBName = [documentDir stringByAppendingPathComponent:DB_Name];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:strDBName];
    if(success) return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_Name];
    
    NSError *error;
    if(![fileManager copyItemAtPath:databasePathFromApp toPath:strDBName error:&error]) {
    }
}
-(void)openDataBase {
    NSString *strDBName;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    strDBName = [documentDir stringByAppendingPathComponent:DB_Name];
    masterDB=[FMDatabase databaseWithPath:strDBName];
    [masterDB open];
}


-(BOOL)checkExist:(NSString*)strQuery
{
    resultDB=[masterDB executeQuery:strQuery];
    if(![resultDB next])
    {
        [resultDB close];
        return NO;
    }
    [resultDB close];
    return YES;
}

-(NSMutableArray*)returnRecords:(NSString*)strQuery
{
    
    NSMutableArray *objects=[[NSMutableArray alloc]init];
    resultDB=[masterDB executeQuery:strQuery];
    
    while([resultDB next])
    {
        NSDictionary *availableRecords=[resultDB resultDictionary];

        NSMutableDictionary *keyValues=[[NSMutableDictionary alloc]init];

        for(NSString *key in availableRecords.allKeys)
        {
            [keyValues setObject:[availableRecords objectForKey:key] forKey:key];
        }
        
        [objects addObject:keyValues];
    }
    [resultDB close];

    
    return objects;
}
-(NSString*)returnValue:(NSString*)strQuery columnname:(NSString*)strColumn
{
    
    NSString *returnValue=@"";
    resultDB=[masterDB executeQuery:strQuery];
    if([resultDB next])
    {
        returnValue=[resultDB stringForColumn:strColumn];
    }
    [resultDB close];

    return returnValue;
}
-(void)executeQuery:(NSString*)strQuery
{
    [masterDB executeUpdate:strQuery];
}


@end
