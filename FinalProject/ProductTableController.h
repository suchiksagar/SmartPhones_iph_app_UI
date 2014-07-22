//
//  ProductTableController.h
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionInfo.h"

@interface ProductTableController : UITableViewController
{
    long selectedStoreId;
    NSArray *jsonOuput;
    NSMutableData *data;
    ConnectionInfo *connfo;
    NSMutableArray *filteredItemList;
    Boolean isFiltered;
    
}
@property(readwrite)long selectedStoreId;
@property(nonatomic,retain) NSMutableArray *filteredItemList;
@end
