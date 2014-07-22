//
//  SecondViewController.m
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "SecondViewController.h"
#import "OrderItem.h"
#import "Utilities.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize cartItemsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
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
    
    [self setTitle:@"Scan Items"];
    
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

    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{ 
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanClicked:(id)sender {
    
    //initialize the reader and provide some config instructions
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    [reader.scanner setSymbology: ZBAR_I25
                          config: ZBAR_CFG_ENABLE
                              to: 1];
    reader.readerView.zoom = 1.0; // define camera zoom property
    
    //show the scanning/camera mode
    [self presentModalViewController:reader animated:YES];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info {
    
    //this contains your result from the scan
    id results = [info objectForKey: ZBarReaderControllerResults];
    
    //create a symbol object to attach the response data to
    ZBarSymbol *symbol = nil;
    
    //add the symbol properties from the result
    //so you can access it
    for(symbol in results){
        
        //symbol.data holds the value
        NSString *upcString = symbol.data;
        
        //print to the console
        NSLog(@"the value of the scanned UPC is: %@",upcString);
        
        NSMutableString *message = [[NSMutableString alloc]
                                    initWithString: @"Scanned Barcode: "];
        
        [message appendString:[NSString stringWithFormat:@"%@ ",
                               upcString]];
        
        //Create UIAlertView alert
        UIAlertView  *successalert = [[UIAlertView alloc]
                               initWithTitle:@"Product Barcode" message: message delegate:self
                               cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        
        self.prodNameTextField.text = upcString;
        
        if(![self.prodNameTextField.text isEqualToString:@"value"])
        {
            //Process the saved order's order Item from here...
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
            
            if([myDictionary count]==0 || [myDictionary valueForKey:@"savedOrder"]==Nil ||([(NSMutableArray *)[myDictionary valueForKey:@"savedOrder"] count]==0))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Cart" message:@"Your cart is empty, please add items to the cart"
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            else
            {
                self.cartItemsArray= [myDictionary valueForKey:@"savedOrder"];
            }
        for(OrderItem *oi in self.cartItemsArray)
        {
            if([oi.productName isEqualToString:self.prodNameTextField.text])
            {
                oi.scannedFlag=YES;
                [successalert show];
                [successalert dismissWithClickedButtonIndex:0 animated:TRUE];
            }
        }
            [myDictionary setObject:self.cartItemsArray forKey:@"savedOrder"];
            
            [NSKeyedArchiver archiveRootObject:myDictionary toFile:userFile];
            NSMutableData *data = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            
            [archiver encodeObject: myDictionary  forKey:@"DicKey"];
            
            [archiver finishEncoding];
            
            [data writeToFile:userFile atomically:YES];
            ////
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Scan Failed" message:@"Couldn't scan the item!!"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
       // [successalert show];
        //After some time
       // [successalert dismissWithClickedButtonIndex:0 animated:TRUE];
        
        //make the reader view go away
        [reader dismissModalViewControllerAnimated: YES];
    }
    
}
-(IBAction)logoutClicked
{
    NSLog(@"Logout Clicked");
    [self performSegueWithIdentifier:@"scanLogoutSegue" sender:self]; NSFileManager *fileManager = [NSFileManager defaultManager];
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
