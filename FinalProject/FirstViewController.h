//
//  FirstViewController.h
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"

@interface FirstViewController : UIViewController <UITextFieldDelegate>
{
    OrderItem *orderItem;
}
@property (strong, nonatomic) IBOutlet UITextField *prodNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *qtyTextField;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UITextField *storenameTextField;
@property (strong, nonatomic) OrderItem *orderItem;
@end
