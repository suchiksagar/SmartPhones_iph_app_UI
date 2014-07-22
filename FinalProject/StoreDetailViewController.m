//
//  StoreDetailViewController.m
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "ProductTableController.h"
#import "Utilities.h"



@implementation StoreDetailViewController
@synthesize store,storeNameTextField,streetNameTextField,zipTextField,toolbar;

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
    
    //IMAGES AND COLORING//
    
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
    
    [self setTitle:@"Store Info"];
    
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
    
    //
    
    
    
    storeNameLabel.text=store.storeName;
    [selectStoreBtn setHidden:NO];
    zipTextField.text=[NSString stringWithFormat:@"%ld",store.zipcode];
    streetNameTextField.text=store.street;
    storeNameTextField.text=store.storeName;
    
    storeNameTextField.enabled=NO;
    streetNameTextField.enabled=NO;
    zipTextField.enabled=NO;
    
        
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectStoreClicked:(id)sender {
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard1" bundle:nil];
    ProductTableController *prodVwCtlr = [mystoryboard instantiateViewControllerWithIdentifier:@"ProdVwCtlr"];
    prodVwCtlr.selectedStoreId=self.store.storeId;
    //self.searchBar.text = @"";
    //[self.searchBar resignFirstResponder];
    
    //TRYING TO WRITE TO FILE///
    
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
        NSLog(@"User din't seem to have logged in!!");
        [myDictionary setObject:[NSNumber numberWithLong:self.store.zipcode] forKey:@"selectedStore"];
    }
    else if([myDictionary objectForKey:@"selectedStore"])
    {
         NSLog(@"There is a prior store existing!!");
        [myDictionary setObject:[NSNumber numberWithLong:self.store.zipcode] forKey:@"selectedStore"];
    }
    else
    {
        NSLog(@"Yuo ahv never selected a store before!");
        [myDictionary setObject:[NSNumber numberWithLong:self.store.zipcode] forKey:@"selectedStore"];
    }
    
    NSLog(@"The value of the archived number is %@",[myDictionary valueForKey:@"selectedStore"]);
    
    [NSKeyedArchiver archiveRootObject:myDictionary toFile:userFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject: myDictionary  forKey:@"DicKey"];
    
    [archiver finishEncoding];
    
    [data writeToFile:userFile atomically:YES];
}

-(IBAction)logoutClicked
{
    NSLog(@"Logout Clicked");
    [self performSegueWithIdentifier:@"storeDetLogoutSegue" sender:self];
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
