//
//  FirstViewController.m
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "FirstViewController.h"
#import "Utilities.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize orderItem;
@synthesize prodNameTextField;
@synthesize priceTextField;
@synthesize storenameTextField;
@synthesize qtyTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Background & images//
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue-grad.jpg"]];
    
    self.tabBarController.tabBar.tintColor=[UIColor clearColor];
    
    //
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.searchDisplayController.searchBar.translucent = YES;
    self.searchDisplayController.searchBar.backgroundImage = [UIImage new];
    self.searchDisplayController.searchBar.scopeBarBackgroundImage = [UIImage new];
    
    [self setTitle:@"Order Item"];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(logoutClicked)];
    
    
    
    [logoutButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton setTintColor:[Utilities colorWithRGBA:0x590000FF]];
    
 
    
    //
    
    prodNameTextField.text=orderItem.productName;
    priceTextField.text=[NSString stringWithFormat:@"%f",orderItem.orderItemPrice];
    storenameTextField.text=orderItem.storeName;
    qtyTextField.text=[NSString stringWithFormat:@"%d", orderItem.quantity];
    
    priceTextField.enabled=NO;
    storenameTextField.enabled=NO;
    qtyTextField.enabled=NO;
    prodNameTextField.enabled=NO;
	// Do any additional setup after loading the view, typically from a nib.
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldReturn:(UITextField *)sender {
    [sender resignFirstResponder];
}
- (IBAction)textFieldDidBeginEditing:(id)sender {
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    UIView *view = [sender superview];
    
    
    view.frame = CGRectMake(view.frame.origin.x, (view.frame.origin.y - 70.0), view.frame.size.width, view.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)textFieldDidEndEditing:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    UIView *view = [sender superview];
    
    view.frame = CGRectMake(view.frame.origin.x, (view.frame.origin.y + 70.0), view.frame.size.width, view.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)logoutClicked
{
    NSLog(@"Logout Clicked");
        [self performSegueWithIdentifier:@"cartDetLogoutSegue" sender:self];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *userFile = [documentsDirectory stringByAppendingPathComponent:@"userDataFile"];
    NSLog(@"%@",userFile);
    NSError *error;
    BOOL success =[fileManager removeItemAtPath:userFile error:&error];
    if (success) {
        NSLog(@"The file has been successfully deleted");
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }

}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor blackColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
        
    }
    titleView.text = title;
    [titleView sizeToFit];
}

@end
