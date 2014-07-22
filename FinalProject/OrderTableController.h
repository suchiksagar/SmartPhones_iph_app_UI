//
//  OrderTableController.h
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableController : UITableViewController
{
    NSMutableArray *savedItemsArray;
    NSMutableArray *storeIdArray;
    NSSet *mySet;
    NSArray *myArray;
    Boolean isFiltered;
    NSMutableArray *filteredItemList;
}
@property(nonatomic, retain)NSMutableArray *savedItemsArray;
@property(nonatomic, retain)NSMutableArray *filteredItemList;
@property(nonatomic, retain)NSMutableArray *storeIdArray;
@property(nonatomic, retain)NSSet *mySet;
@property(nonatomic, retain)NSArray *myArray;
@end
