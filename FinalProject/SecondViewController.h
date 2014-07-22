//
//  SecondViewController.h
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface SecondViewController : UIViewController <ZBarReaderDelegate>
{
    NSMutableArray *cartItemsArray;
}
@property (strong, nonatomic) IBOutlet UILabel *prodNameTextField;
@property (strong, nonatomic)     NSMutableArray *cartItemsArray;
- (IBAction)scanClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end
