//
//  ProductDetailViewController.m
//  FinalProject
//
//  Created by KshirasagarS on 12/3/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "OrderItem.h"
#import "Utilities.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController
@synthesize prodDetailLabel;
@synthesize ourStepper;

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
    
    //Images & Colouring//
    
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
    
    [self setTitle:@"Product Info"];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(logoutClicked)];
    
    
    
    [logoutButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton setTintColor:[Utilities colorWithRGBA:0x590000FF]];
    
    [self.toolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    [self.toolbar setBackgroundColor:[UIColor clearColor]];
    

    
    ///
    
    [ourStepper setHidden:NO];
    self.prodDetailLabel.text=self.product.productName;
    self.ourStepper.minimumValue = 0;
    self.ourStepper.maximumValue = 100;
    self.ourStepper.stepValue = 1;
    self.ourStepper.wraps = NO;
    self.ourStepper.autorepeat = YES;
    self.ourStepper.continuous = YES;
    self.stepperValue.text = [NSString stringWithFormat:@"%f", ourStepper.value];
    self.priceLabel.text=[NSString stringWithFormat:@"%f",self.product.productPrice];
    self.availLabel.text=[NSString stringWithFormat:@"%d", self.product.availability];
    self.priceLabel.enabled=NO;
    self.availLabel.enabled=NO;
    self.prodDetailLabel.enabled=NO;
    self.stepperValue.enabled=NO;
	// Do any additional setup after loading the view.
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperValChanged:(id)sender {
    double stepperValue = ourStepper.value;
    self.stepperValue.text = [NSString stringWithFormat:@"%f", ourStepper.value];
}
- (IBAction)addToCartButton:(id)sender {
    int qty=[self.stepperValue.text integerValue];
    if(qty>0 && self.product.availability>0)
    {
        
        OrderItem *orderItem=[[OrderItem alloc]init];
        orderItem.productId=self.product.productId;
        orderItem.quantity=[self.stepperValue.text integerValue];
        orderItem.storeZip=self.product.storeZip;
        orderItem.orderItemPrice=([self.stepperValue.text integerValue] * self.product.productPrice);
        orderItem.productName=self.product.productName;
        orderItem.storeName=self.product.storeName;
        
        
      //// Write to File
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
            NSMutableArray *orderItemArray=[[NSMutableArray alloc]init];
            [orderItemArray addObject:orderItem];
            [myDictionary setObject:orderItemArray forKey:@"savedOrder"];
            
            NSLog(@"The value of the aray to be archived is: %d",[orderItemArray count]);
        }
        else
        {
        NSArray *allKeys = [myDictionary allKeys];
            Boolean flag=NO;
                for(NSString *strKey in allKeys)
                {
                    if([strKey isEqualToString:@"savedOrder"])
                    {
                        NSMutableArray *oIArray=[myDictionary objectForKey:@"savedOrder"];
                        NSLog(@"The value of the aray size retrieved is: %d",[oIArray count]);
                        //look for the existence of this product
                        BOOL arrFlag=NO;
                        for(OrderItem *item in oIArray)
                        {
                            if(item.productId==orderItem.productId)
                            {
                                item.quantity=orderItem.quantity+item.quantity;
                                item.orderItemPrice=item.orderItemPrice+orderItem.orderItemPrice;
                                arrFlag=YES;
                            }
                        }
                        if(!arrFlag)
                        {
                        [oIArray addObject:orderItem];
                        }
                         NSLog(@"The value of the aray to be archived is: %d",[oIArray count]);
                        [myDictionary setObject:oIArray forKey:@"savedOrder"];
                        flag=YES;
                        
                    }
                    else{}
                 }
    
            if(!flag)
            {
        NSMutableArray *orderItemArray=[[NSMutableArray alloc]init];
        [orderItemArray addObject:orderItem];
        [myDictionary setObject:orderItemArray forKey:@"savedOrder"];
                NSLog(@"The value of the aray to be archived is: %d",[orderItemArray count]);
            }
        
        }
        /// NOW ENCODE THE DICTIONARY BACK TO THE FILE
        [NSKeyedArchiver archiveRootObject:myDictionary toFile:userFile];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        [archiver encodeObject: myDictionary  forKey:@"DicKey"];
        
        [archiver finishEncoding];
        
        [data writeToFile:userFile atomically:YES];
        UIAlertView *errorView=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Product added to cart" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [errorView show];
        //// 
    }
    else
    {
    UIAlertView *errorView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please correct the quantity/low stock" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    }
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
        [self performSegueWithIdentifier:@"prodDetLogoutSegue" sender:self];
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
