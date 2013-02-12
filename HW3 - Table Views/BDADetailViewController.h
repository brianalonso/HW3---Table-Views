//
//  BDADetailViewController.h
//  HW3 - Table Views
//
//  Created by Brian Alonso on 2/8/13.
//  Copyright (c) 2013 Brian Alonso. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataAccessObject;

@interface BDADetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// Public Property
@property (strong, nonatomic) NSDictionary *detailItem;


@end
