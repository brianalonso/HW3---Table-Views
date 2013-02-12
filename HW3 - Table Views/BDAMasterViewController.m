//
//  BDAMasterViewController.m
//  HW3 - Table Views
//
//  Created by Brian Alonso on 2/8/13.
//  Copyright (c) 2013 Brian Alonso. All rights reserved.
//

#import "BDAMasterViewController.h"
#import "DataAccessObject.h"
#import "BDADetailViewController.h"

#define MAIN_TABLEVIEW_TAG 1000

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";

@interface BDAMasterViewController () {
    DataAccessObject *dao;
    NSMutableDictionary *stateDict;
    NSMutableArray *filteredStateNames;
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) BDADetailViewController *detailViewController;
@property (copy, nonatomic) NSDictionary *names;
@property (copy, nonatomic) NSArray *keys;
@property (strong, nonatomic) UISearchDisplayController *searchController;

@end

@implementation BDAMasterViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = (id)[self.view viewWithTag:MAIN_TABLEVIEW_TAG];
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:SectionsTableIdentifier];
    
    filteredStateNames = [NSMutableArray array];
    
    // Build the searchbar and SearchDisplay controller
    UISearchBar *searchBar = [[UISearchBar alloc]
                              initWithFrame:CGRectMake(0, 0, 320, 44)];
    tableView.tableHeaderView = searchBar;
    self.searchController = [[UISearchDisplayController alloc]
                        initWithSearchBar:searchBar
                        contentsController:self];
   
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    
    // Scroll the search off the top
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
//    [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // Instantiate the Data Access object to read the pList
    if (dao == nil) {
        // Lazy loading of Data Access object
        dao = [[DataAccessObject alloc] initWithLibraryName:@"states"];
    }
    self.title = NSLocalizedString(@"States", @"States list");
    
    // Retrieve the array of keys from the Data access object
    self.names = [self configureSectionData];
    
    // Remove row selection highlight
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Initialization

- (NSDictionary *)configureSectionData {
    
    // Retrieve the set of letters 
    self.keys = [dao libraryKeys];
    
    stateDict = [NSMutableDictionary dictionaryWithCapacity:[self.keys count]];
    for (NSString *startingLetter in self.keys)
    {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithObjects: nil];
        for (NSUInteger index = 0; index < dao.libraryCount; index++) {
            NSString *stateName = [[dao libraryItemAtIndex:index] valueForKey:@"name"];
            if([stateName hasPrefix:startingLetter])
                [mutableArray addObject:stateName];
        }
        
        // Did we add any states for this letter ?
        if ([mutableArray count] > 0) {
            
            // Add the array of state names for the starting alphabetic character 
            [stateDict setObject:mutableArray forKey:startingLetter];
        }
        mutableArray = nil;
    }
    return [stateDict copy];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.detailViewController = nil;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == MAIN_TABLEVIEW_TAG) {
        return [self.keys count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == MAIN_TABLEVIEW_TAG) {
        NSString *key = self.keys[section];
        NSArray *nameSection = self.names[key];
        return [nameSection count];
    } else {
        return [filteredStateNames count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == MAIN_TABLEVIEW_TAG) {
        NSString *key = self.keys[section];
        NSArray *nameSection = self.names[key];
        if ([nameSection count] > 0) {
            // return section headers only if data within the section
            return [self.keys objectAtIndex:section];
        }
    }
    // Don't return a header title
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag == MAIN_TABLEVIEW_TAG) {
        // return the entire title section array
        return self.keys;
    }
    return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
    if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BDACellView" owner:self options:nil] lastObject];
            UINib *theNib = [UINib nibWithNibName:@"BDACellView" bundle:nil];
            cell = [[theNib instantiateWithOwner:self options:nil] lastObject];
    }
    
    // Configure the cell...
    UIImageView *cellFlag = (UIImageView *)[cell viewWithTag:200];
    UILabel *lblState = (UILabel *)[cell viewWithTag:100];
    UILabel *lblCaptial = (UILabel *)[cell viewWithTag:50];
    
    // Handle population of the main table view cell
    if (tableView.tag == MAIN_TABLEVIEW_TAG) {
        // Hide the disclosure indicators for the search
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        // Get the key for the section
        NSString *key = self.keys[indexPath.section];
        NSArray *nameSection = self.names[key];
        NSString *stateToShow = [nameSection objectAtIndex:indexPath.row];
      
        NSMutableString *strState = [[dao libraryItemForKey:stateToShow] valueForKey:@"name"];
        [lblState setText:strState];
        [lblCaptial setText:[[dao libraryItemForKey:stateToShow] valueForKey:@"capital"]];
        
        // load the small flag image
        cellFlag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-50.png", [strState stringByReplacingOccurrencesOfString:@" " withString:@"_" ]]];
    }
    else
    {
        // Handle the Search results cell value
        
        // Show the disclosure indicators for the search
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        // handle the search dataset
        NSString *stateToShow = filteredStateNames[indexPath.row];
        NSMutableString *strState = [[dao libraryItemForKey:stateToShow] valueForKey:@"name"];
        [lblState setText:strState];
        [lblCaptial setText:[[dao libraryItemForKey:stateToShow] valueForKey:@"capital"]];
        
        // load the small flag image
        cellFlag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-50.png", [strState stringByReplacingOccurrencesOfString:@" " withString:@"_" ]]];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Lazy Instantiation of the Detail view controller
    if (!self.detailViewController) {
        self.detailViewController = [[BDADetailViewController alloc] initWithNibName:@"BDADetailViewController" bundle:nil];
    }
    
    NSString *stateToShow;
    
    // Store the data access object in the detail item of the view controller
    //if (tableView == self.searchDisplayController.searchResultsTableView) {
    if (tableView.tag == MAIN_TABLEVIEW_TAG) {
        // Get the key for the section
        NSString *key = self.keys[indexPath.section];
        NSArray *nameSection = self.names[key];
        stateToShow = [nameSection objectAtIndex:indexPath.row];
    }
    else
    {
        // Handle the user's click on the search row
        stateToShow = filteredStateNames[indexPath.row];
    }
    
    self.detailViewController.detailItem = [dao libraryItemForKey:stateToShow];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Height for the table cell
    return 50;
}

#pragma mark -
#pragma mark Search Display Delegate Methods
- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:SectionsTableIdentifier];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [filteredStateNames removeAllObjects];
    if (searchString.length > 0) {
        NSPredicate *predicate =
        [NSPredicate
         predicateWithBlock:^BOOL(NSString *name, NSDictionary *b) {
             NSRange range = [name rangeOfString:searchString
                                         options:NSCaseInsensitiveSearch];
             return range.location != NSNotFound;
         }];
        for (NSString *key in self.keys) {
            NSArray *matches = [self.names[key]
                                filteredArrayUsingPredicate: predicate];
            [filteredStateNames addObjectsFromArray:matches];
        }
    }
    return YES;
}

#pragma mark - Autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
