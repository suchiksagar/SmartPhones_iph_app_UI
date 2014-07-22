//
//  CartTableController.m
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "CartTableController.h"
# import "OrderItem.h"
#import "FirstViewController.h"
#import "Utilities.h"
@interface CartTableController ()

@end

@implementation CartTableController
@synthesize cartItemsArray,filteredItemList;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
    self.searchDisplayController.searchBar.text=@"";
    
    /// Images & coloring//
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
    
    [self setTitle:@"Cart"];

    
    //
    
    
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(logoutClicked)];
    [logoutButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton setTintColor:[Utilities colorWithRGBA:0x590000FF]];
    
    
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
       self.searchDisplayController.searchBar.text=@"No Items in your cart";
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Cart" message:@"Your cart is empty, please add items to the cart"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show]; */
        NSLog(@"Cart is empty, please add items to cart");
        return;
    }
    else
    {
        self.cartItemsArray= [myDictionary valueForKey:@"savedOrder"];
        filteredItemList=[[NSMutableArray alloc] initWithArray:self.cartItemsArray];
    }

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self viewDidLoad];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self viewDidLoad];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cartItemsArray removeAllObjects];
    [filteredItemList removeAllObjects];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.cartItemsArray removeAllObjects];
    [filteredItemList removeAllObjects];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [filteredItemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }

    // Configure the cell...
    OrderItem *oitm= [filteredItemList objectAtIndex:indexPath.row];
    cell.textLabel.text=oitm.productName;
   // cell.detailTextLabel.text=oitm.storeName;
    return cell;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [cartItemsArray removeObjectAtIndex:indexPath.row];
        [filteredItemList removeObjectAtIndex:indexPath.row];
        //sync it back to the file//
        
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
        
        [myDictionary setObject:cartItemsArray forKey:@"savedOrder"];
        
        [NSKeyedArchiver archiveRootObject:myDictionary toFile:userFile];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        [archiver encodeObject: myDictionary  forKey:@"DicKey"];
        
        [archiver finishEncoding];
        
        [data writeToFile:userFile atomically:YES];
        
        //synched back succesfully
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard1" bundle:nil];
    FirstViewController *firstVC = [mystoryboard instantiateViewControllerWithIdentifier:@"CartViewDetailCtlr"];
    //self.searchBar.text = @"";
    //[self.searchBar resignFirstResponder];
    firstVC.orderItem=[filteredItemList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:firstVC animated:YES];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    if([searchText length] == 0)
    {
        isFiltered = FALSE;
        [filteredItemList removeAllObjects];
        [filteredItemList addObjectsFromArray:self.cartItemsArray];
        
    }
    else{
        isFiltered = TRUE;
        [filteredItemList removeAllObjects];
        for(OrderItem *i in cartItemsArray){
            NSRange stringRange = [[i productName] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location !=NSNotFound){
                [filteredItemList addObject:i];
            }
        }
        
    }
    [self.tableView reloadData];
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    
    return YES;
}


-(IBAction)logoutClicked
{
    NSLog(@"Logout Clicked");
    [self performSegueWithIdentifier:@"cartLogoutSegue" sender:self];
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
