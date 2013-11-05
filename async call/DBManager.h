//
//  DBManager.h
//
//  Created by Cognizant Chennai on 7/1/13.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import <sqlite3.h>
@interface DBManager : NSObject


{
    DBManager *sharedDBManager;
    
    
}

+(id)sharedDBManager;
-(void)createDataBase;
-(void)openDataBase;
-(void)executeQuery:(NSString*)strQuery;
-(NSString*)returnValue:(NSString*)strQuery columnname:(NSString*)strColumn;
-(BOOL)checkExist:(NSString*)strQuery;
-(NSMutableArray*)returnRecords:(NSString*)strQuery;

@end
