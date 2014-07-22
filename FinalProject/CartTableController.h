//
//  CartTableController.h
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableController : UITableViewController
{
    NSMutableArray *cartItemsArray;
    NSMutableArray *filteredItemList;
    Boolean isFiltered;
}
@property(nonatomic,retain) NSMutableArray *cartItemsArray;
@property(nonatomic,retain) NSMutableArray *filteredItemList;

@end
