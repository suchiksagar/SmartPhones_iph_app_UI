//
//  StoreProductOrderController.h
//  FinalProject
//
//  Created by KshirasagarS on 12/5/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"
#import "ConnectionInfo.h"
@interface StoreProductOrderController : UITableViewController
{
    NSMutableArray *storeOrderItem;
    ConnectionInfo *connInfo;
    NSMutableData *data;
    NSDictionary *jsonOutput;
    IBOutlet UITextField *orderTotalTextField;
}
- (IBAction)placeOrderClicked:(id)sender;

@property(nonatomic,retain) NSMutableArray *storeOrderItem;
@property (strong, nonatomic) IBOutlet UITextField *orderTotalTextField;


@end
