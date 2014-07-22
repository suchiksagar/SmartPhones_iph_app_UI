//
//  ProductTableController.m
//  FinalProject
//
//  Created by Sucharith Kshirasagar on 11/24/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "ProductTableController.h"
#import "ProductDetailViewController.h"
#import "Product.h"
#import "Utilities.h"
@interface ProductTableController ()

@end

@implementation ProductTableController
@synthesize selectedStoreId;

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
   // self.selectedStoreId=1;
    
    ///Beautification//
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
    
    [self setTitle:@"Products"];

    //
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(logoutClicked)];
    
    [logoutButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem = logoutButton;
   [logoutButton setTintColor:[Utilities colorWithRGBA:0x590000FF]];
    
    
    ///
    //RETRIEVE THE VALUE OF THE SELECTED STORE
    
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
        self.selectedStoreId=2115;
    }
    else if (![myDictionary objectForKey:@"selectedStore"])
    {
        NSLog(@"Yuo ahv never selected a store before!");
        self.selectedStoreId=2115;
    }
    else
    {
        NSLog(@"There is a prior store existing!!");
        self.selectedStoreId= [[myDictionary valueForKey:@"selectedStore"] longValue];
    }
    ///
    NSLog(@"The value retrieved is%ld", selectedStoreId);
    [UIApplication sharedApplication].networkActivityIndicatorVisible= YES;
    NSString *reqParam=[NSString stringWithFormat:@"getProductCatalog?x=%ld",selectedStoreId];
    NSLog(@"%@",reqParam);
    connfo= [[ConnectionInfo alloc] initWithFinalPiece:reqParam];
    NSMutableURLRequest *request=[connfo getMeTheRequestObject];
    NSURLConnection *connect=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connect)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not connect to internet"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
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
    [self viewDidLoad];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
    
    NSLog(@"%d",jsonOuput.count);
    filteredItemList=[[NSMutableArray alloc] initWithArray:jsonOuput];
    [self.tableView reloadData];
    // NSDictionary *productLineItem=[jsonOuput objectAtIndex:0];
    // NSDictionary *p=[productLineItem objectForKey:@"product"];
    
    // uiTextView.text=[p objectForKey:@"productName"];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Couldn't connect to internet" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible= NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
    
    NSDictionary *productLineItem=[filteredItemList objectAtIndex:indexPath.row];
    NSDictionary *p=[productLineItem objectForKey:@"product"];
    
    cell.textLabel.text=[p objectForKey:@"productName"];
    //cell.textLabel.text = [store valueForKey:@"storeName"];
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    ProductDetailViewController *prodDetailVC = [mystoryboard instantiateViewControllerWithIdentifier:@"ProdDetVc"];
    //self.searchBar.text = @"";
    //[self.searchBar resignFirstResponder];
    NSDictionary *productLineItem=[filteredItemList objectAtIndex:[indexPath row]];
    NSDictionary *p=[productLineItem objectForKey:@"product"];
    Product *prod= [[Product alloc]init];
    prod.productName=[p valueForKey:@"productName"];
    prod.productPrice=[[p valueForKey:@"productPrice"] doubleValue];
    prod.availability=[[productLineItem valueForKey:@"avialability"] integerValue];
    
    NSDictionary *store=[productLineItem objectForKey:@"store"];
    prod.storeZip=[[store objectForKey:@"zipCode"] longValue];
    prod.storeName=[store objectForKey:@"storeName"];
    prod.productId=[[p valueForKey:@"id"] integerValue];
    NSLog(@"The value of the selected product id is %@", prod.productName);
    prodDetailVC.product=prod;
    [self.navigationController pushViewController:prodDetailVC animated:YES];

}



- (void)filterContentForSearchText:(NSString*)searchText
{
    if([searchText length] == 0)
    {
        isFiltered = FALSE;
        [filteredItemList removeAllObjects];
        [filteredItemList addObjectsFromArray:jsonOuput];
        
    }
    else{
        isFiltered = TRUE;
        [filteredItemList removeAllObjects];
        for(NSDictionary *it in jsonOuput){
            NSDictionary *p=[it objectForKey:@"product"];
            NSRange stringRange = [[p valueForKey:@"productName"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location !=NSNotFound){
                [filteredItemList addObject:it];
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
    [self performSegueWithIdentifier:@"prodLogoutSegue" sender:self];
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

