//
//  StoreProductOrderController.m
//  FinalProject
//
//  Created by KshirasagarS on 12/5/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "StoreProductOrderController.h"
#import "ConnectionInfo.h"

@interface StoreProductOrderController ()

@end

@implementation StoreProductOrderController
@synthesize storeOrderItem,orderTotalTextField;
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
    
    //Background & images etc..//
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
    
    [self setTitle:@"Pay Now"];

    //
    
    
    orderTotalTextField.enabled=NO;
    
    if(storeOrderItem.count>0)
    {
    NSLog(@"The size of the array is %d",[storeOrderItem count]);
    
    
    
    NSMutableArray *itDelArray= [[NSMutableArray alloc]init];
    for(OrderItem *o in storeOrderItem)
    {
        if(!o.scannedFlag)
        {
            [itDelArray addObject:o];
            
        }
    }
    
    for(OrderItem *o in itDelArray)
    {
    [storeOrderItem removeObject:o];
    }
    [itDelArray removeAllObjects];
    
        if(storeOrderItem.count>0)
        {
            double ordTot=0.0;
            for(OrderItem *ot in storeOrderItem)
            {
                ordTot= ordTot+ot.orderItemPrice;
            }
            self.orderTotalTextField.text=[NSString stringWithFormat:@"%f",ordTot];
        }
        else
        {
        self.orderTotalTextField.text=@"0";
        }
        

    }
    else
        {
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
    return [storeOrderItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
        
    }
    
    // Configure the cell...
    OrderItem *oitm= [storeOrderItem objectAtIndex:indexPath.row];
    cell.textLabel.text=oitm.productName;
    return cell;
    
    // Configure the cell...
    
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

// YOU MIGHT WANNA REMOVE THIS METHOD TO SEE IF WE CAN MAKE THE SELECTION NON WORKABLE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)placeOrderClicked:(id)sender {
    
    if(storeOrderItem.count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty List" message:@"Please add items/scan your cart"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *orderDictionary= [[NSMutableDictionary alloc]init];
    NSMutableDictionary *productMap=[[NSMutableDictionary alloc]init];
    
    for(OrderItem *item in storeOrderItem)
    {
        [productMap setObject:[NSString stringWithFormat:@"%d",item.quantity] forKey:[NSString stringWithFormat:@"%d",item.productId]];
    }
    
    //
    
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
    
    //
    
    [orderDictionary setObject:[myDictionary objectForKey:@"userName"] forKey:@"userName"];
    [orderDictionary setObject:productMap forKey:@"productMap"];
    [orderDictionary setObject:[NSString stringWithFormat:@"%ld",[[storeOrderItem objectAtIndex:0] storeZip]] forKey:@"storeZip"];
    
    //SENDING REQUEST TO THE SERVER === PLACING THE ORDER
    
    NSError *jsonError = nil;
    NSData *jsonObject = [NSJSONSerialization dataWithJSONObject:orderDictionary options:0 error:&jsonError];
    if (!jsonError) {
        NSMutableData *postBody = [[NSMutableData alloc] initWithData:jsonObject];
        //[postBody appendData:jsonObject];
        
        
        NSString *reqParam=[NSString stringWithFormat:@"placeOrder"];
        NSLog(@"%@",reqParam);
        connInfo= [[ConnectionInfo alloc] initWithFinalPiece:reqParam];
        NSMutableURLRequest *request=[connInfo getMeTheRequestObject];
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
    if([resp isEqualToString:@"Order Created"])
    {
        NSLog(@"Order Created Yewhoo..!!!!");
        self.orderTotalTextField.text=@"";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Order placed successfully"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
        
        //PERFORM OTHER CLEAN UP OPERATIONS SUCH AS CLEAR THE ARRAY AND REMOVE THE ITEMS FROM THE USER FILE ETC<><><>
        
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
        
        NSMutableArray *savedOrder= [myDictionary valueForKey:@"savedOrder"];
        NSMutableArray *itemDeleteArray= [[NSMutableArray alloc] init];
        
        for(OrderItem *otm in savedOrder)
        {
            for(OrderItem *o in storeOrderItem)
            {
                if([o.productName isEqualToString:otm.productName])
                {
                    [itemDeleteArray addObject:otm];
                    
                }
            }
            
        }
        for(OrderItem *o in itemDeleteArray)
        {
            [savedOrder removeObject:o];
        }
        [storeOrderItem removeAllObjects];
    [myDictionary setObject:savedOrder forKey:@"savedOrder"];
        NSLog(@"Thc count of the saved order now is:%d",[savedOrder count]);
    
    [NSKeyedArchiver archiveRootObject:myDictionary toFile:userFile];
    NSMutableData *data1 = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data1];
    
    [archiver encodeObject: myDictionary  forKey:@"DicKey"];
    
    [archiver finishEncoding];
    
    [data1 writeToFile:userFile atomically:YES];
        ///////////
    
        [self.tableView reloadData];
    }
    else{
        UIAlertView *errorView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not place the order at this time" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
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
