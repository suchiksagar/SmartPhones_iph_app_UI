//
//  SignUpViewController.h
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionInfo.h"

@interface SignUpViewController : UIViewController
{
    NSDictionary *jsonInput;
    NSMutableData *data;
    NSDictionary *jsonOutput;
    ConnectionInfo *connfo;
}

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
- (IBAction)signUpButtonClicked:(id)sender;

- (IBAction)cancelButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;


@property (strong, nonatomic) IBOutlet UINavigationItem *navigationitem;

@end
