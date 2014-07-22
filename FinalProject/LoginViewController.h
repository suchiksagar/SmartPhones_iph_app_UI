//
//  LoginViewController.h
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionInfo.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    NSDictionary *jsonOuput;
    NSMutableData *data;
    ConnectionInfo *connfo;
}
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)signUpButtonClicked:(id)sender;
- (IBAction)testButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end
