//
//  ViewController.m
//  async call
//
//  Created by Rajesh on 10/23/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "dbExecute.h"


@interface ViewController ()
@property(strong)NSDictionary *gblParsedData;
@end

@implementation ViewController
@synthesize gblParsedData;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makemycallaction:(id)sender {
    asyncServiceCall *myCall=[[asyncServiceCall alloc] init];
    myCall.delegate=self;
    //[myCall makeTheServiceCall:@"http://news.google.com/?output=json" withPostData:@""];
    [myCall makeTheServiceCall:@"http://textuploader.com/dyqb/raw" withPostData:@""];
    DBManager *sharedDBManager;
    sharedDBManager=[DBManager sharedDBManager];
    [sharedDBManager createDataBase];
    [sharedDBManager openDataBase];
    //[sharedDBManager executeQuery:@"INSERT INTO tblBrands VALUES (1,'btm',0)"];

} 
-(void)receivedResponse:(NSDictionary*)parsedResponse
{
    NSLog(@"response from receivedResponse %@",parsedResponse);
    dbExecute *dbexe=[[dbExecute alloc]init ];
    [dbexe insertIntoUserTable:parsedResponse];
	[dbexe insertIntoSegmentTable:parsedResponse];
  
}

-(void)failedStatus:(NSError *)error
{
    NSLog(@"error from failedstatus %@",error);
}


@end
