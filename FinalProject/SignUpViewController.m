//
//  SignUpViewController.m
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize navigationitem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue-grad.jpg"]];
    
    self.tabBarController.tabBar.tintColor=[UIColor clearColor];
    
    //
    
    [self.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    
    self.searchDisplayController.searchBar.translucent = YES;
    self.searchDisplayController.searchBar.backgroundImage = [UIImage new];
    self.searchDisplayController.searchBar.scopeBarBackgroundImage = [UIImage new];
    
    [self setTitle:@"Sign Up"];
    
    [self.toolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    [self.toolbar setBackgroundColor:[UIColor clearColor]];
	// Do any additional setup after loading the view.
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


- (IBAction)signUpButtonClicked:(id)sender {
    if ([[firstNameTextField text] length] <=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty First Name" message:@"First Name is Null"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
                
    }
    else if ([[lastNameTextField text] length] <=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Last Name" message:@"Last Name is null"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
                
    }
    else if ([[userNameTextField text] length] <=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty User Name" message:@"User Name is null"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    else if ([[passwordTextField text] length] <=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Password" message:@"Password is null"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    //Now perform the server operation, upon success user creation move to login screen, its done by below method--
    
    jsonInput = @{ @"userName" : userNameTextField.text, @"firstName" : firstNameTextField.text, @"lastName" : lastNameTextField.text, @"password": passwordTextField.text};
    
    NSError *jsonError = nil;
    NSData *jsonObject = [NSJSONSerialization dataWithJSONObject:jsonInput options:0 error:&jsonError];
    if (!jsonError) {
        NSMutableData *postBody = [[NSMutableData alloc] initWithData:jsonObject];
        //[postBody appendData:jsonObject];
    
    
    NSString *reqParam=[NSString stringWithFormat:@"createCustomer"];
    NSLog(@"%@",reqParam);
    connfo= [[ConnectionInfo alloc] initWithFinalPiece:reqParam];
    NSMutableURLRequest *request=[connfo getMeTheRequestObject];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postBody length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postBody];
        
    NSURLConnection *connect=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connect)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not connect to internet"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    ///
    

}
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    data=[[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [data appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible= NO;
    
    jsonOutput= [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    
    
    
    NSString *resp=[jsonOutput objectForKey:@"success"];
    
    if([resp isEqualToString:@"User Created"])
    {
        [self performSegueWithIdentifier:@"pushSignUpSegue" sender:self];
    }
    else
    {
        UIAlertView *errorView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Wrong credentials Provided" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [errorView show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible= NO;
    }
    
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Couldn't connect to internet" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible= NO;
}

- (IBAction)cancelButtonClicked:(id)sender {
}
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationitem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor blackColor]; // Change to desired color
        
        self.navigationitem.titleView = titleView;
        
    }
    titleView.text = title;
    [titleView sizeToFit];
}

@end
