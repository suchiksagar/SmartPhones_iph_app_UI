//
//  ProductDetailViewController.h
//  FinalProject
//
//  Created by KshirasagarS on 12/3/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductDetailViewController : UIViewController <UITextFieldDelegate>
{
IBOutlet UITextField *prodDetailLabel;
    Product *product;
}
@property (strong, nonatomic) IBOutlet UIStepper *ourStepper;;
@property (strong, nonatomic) Product *product;
- (IBAction)stepperValChanged:(id)sender;

- (IBAction)addToCartButton:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *prodDetailLabel;

@property (strong, nonatomic) IBOutlet UITextField *stepperValue;
@property (strong, nonatomic) IBOutlet UITextField *availLabel;
@property (strong, nonatomic) IBOutlet UITextField *priceLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end
