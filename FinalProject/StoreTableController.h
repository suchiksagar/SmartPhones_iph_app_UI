//
//  StoreTableController.h
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionInfo.h"
#import "StoreDetailViewController.h"
@interface StoreTableController : UITableViewController
{
    NSArray *jsonOuput;
    NSMutableData *data;
    ConnectionInfo *connfo;
    StoreDetailViewController *storeViweController;
    NSMutableArray *filteredItemList;
    Boolean isFiltered;
}
@property(nonatomic,retain) NSMutableArray *filteredItemList;
@end
