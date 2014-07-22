//
//  StoreDetailViewController.h
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"

@interface StoreDetailViewController : UIViewController
{
    Store *store;
    IBOutlet UILabel *storeNameLabel;
    IBOutlet UIButton *selectStoreBtn;
    
}
@property(nonatomic, readwrite) Store *store;
@property (strong, nonatomic) IBOutlet UIButton *selectStoreBtn;
- (IBAction)selectStoreClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *storeNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *streetNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end
