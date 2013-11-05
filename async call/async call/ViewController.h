//
//  ViewController.h
//  async call
//
//  Created by Rajesh on 10/23/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncServiceCall.h"
#import "DBManager.h"

@interface ViewController : UIViewController<asyncCallProtocol>

- (IBAction)makemycallaction:(id)sender;

@end
