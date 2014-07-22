//
//  LoginViewController.m
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userNameTextField;
@synthesize passwordTextField;

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
    
    [self.toolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    [self.toolbar setBackgroundColor:[UIColor clearColor]];
	// Do any additional setup after loading the view.
    
    // *****USE IT WHEN YOU WANNA CLEAR YOUR FILE, A CLEAN LOAD*******
/*
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
  
*/
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


- (IBAction)loginButtonClicked:(id)sender {
    if ([[userNameTextField text] length] <=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty User Name" message:@"User Name is Null"
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
    
    // Use this space to perform server authntication and based on server response process the login operation.
    NSString *un=userNameTextField.text;
    NSString *pw=passwordTextField.text;
    
    NSString *reqParam=[NSString stringWithFormat:@"isCustomerAuthenticated?x=%@&y=%@",un,pw];
    NSLog(@"%@",reqParam);
    connfo= [[ConnectionInfo alloc] initWithFinalPiece:reqParam];
    NSURLRequest *request=[connfo getMeTheRequestObject];
    NSURLConnection *connect=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connect)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not connect to internet"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    ////
   // [self performSegueWithIdentifier:@"pushToTabSegue" sender:self];
    
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
    
    jsonOuput= [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    
    
           
   NSString *resp=[jsonOuput objectForKey:@"auth"];
    
    if([resp isEqualToString:@"yes"])
    {
       // Write the username to the file
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *userFile = [documentsDirectory stringByAppendingPathComponent:@"userDataFile"];
        NSLog(@"%@",userFile);
        
        NSMutableData *theData;
        NSKeyedUnarchiver *decoder;
        
        NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
        
        theData = [NSData dataWithContentsOfFile:userFile];
        
        decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
        
        myDictionary = [[decoder decodeObjectForKey:@"DicKey"] mutableCopy];
        if([myDictionary count]==0)
        {
            NSLog(@"IN CASE A, NO FILE EXISTS");
            myDictionary = @{@"userName":userNameTextField.text};
            NSLog(@"user has been saved");
        }
        else
        {
            NSString *retrievedUser= [myDictionary objectForKey:@"userName"];
            if([retrievedUser isEqualToString:userNameTextField.text])
            {
                NSLog(@"IN CASE B, SAME USER");
             NSLog(@"Everything is fine with this user i.e %@, you may continue",retrievedUser);
             [[NSUserDefaults standardUserDefaults] setObject:userNameTextField.text forKey:@"userName"];
                
                
            }
             else
            {
                NSLog(@"IN CASE C, DIFFERENT USER");
                NSError *error;
                BOOL success =[fileManager removeItemAtPath:userFile error:&error];
             /*   userFile = [documentsDirectory stringByAppendingPathComponent:@"userDataFile"]; */
                myDictionary = @{@"userName":userNameTextField.text};
            }
        }
        
        [NSKeyedArchiver archiveRootObject:myDictionary toFile:userFile];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        [archiver encodeObject: myDictionary  forKey:@"DicKey"];
        
        [archiver finishEncoding];
        
        [data writeToFile:userFile atomically:YES];
        
       // ENDING THE FILE OPERATION SEQUENCE
    [self performSegueWithIdentifier:@"pushToTabSegue" sender:self];
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
- (IBAction)signUpButtonClicked:(id)sender {
}

- (IBAction)testButtonClicked:(id)sender {
 //    [self performSegueWithIdentifier:@"manualTestSeg" sender:self];
}
@end
