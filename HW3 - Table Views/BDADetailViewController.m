//
//  BDADetailViewController.m
//  HW3 - Table Views
//
//  Created by Brian Alonso on 2/8/13.
//  Copyright (c) 2013 Brian Alonso. All rights reserved.
//

#import "BDADetailViewController.h"
#import "DataAccessObject.h"

@interface BDADetailViewController ()

- (void)configureView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BDADetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDictionary *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        // Get the state image
        NSMutableString *strState = [self.detailItem valueForKey:@"name"];
        
        // load the large flag image
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-200.png", [strState stringByReplacingOccurrencesOfString:@" " withString:@"_" ]]];
        
        self.title = [NSString stringWithFormat:@"%@ (%@)", strState, [self.detailItem valueForKey:@"abbreviation"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

#pragma mark - Detail Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Two data rows for the Cities section
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Cities";
    }
    return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    /*
     // Create custom cell from NIB file
     [tableView registerNib:[UINib nibWithNibName:@"BDACellView" bundle:nil] forCellReuseIdentifier:CellIdentifier];
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     */
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BDADetailCellView" owner:self options:nil] lastObject];
        UINib *theNib = [UINib nibWithNibName:@"BDADetailCellView" bundle:nil];
        cell = [[theNib instantiateWithOwner:self options:nil] lastObject];
    }
    
    // Configure the cell...
    UILabel *lblItem = (UILabel *)[cell viewWithTag:100];
    UILabel *lblValue = (UILabel *)[cell viewWithTag:50];
   
    switch (indexPath.section) {
        case 0:
            // Cities section
            if (indexPath.row == 0) {
                lblItem.text = @"Capital";
                lblValue.text = [self.detailItem valueForKey:@"capital"];
            }
            else {
                lblItem.text = @"Most Populous";
                lblValue.text = [self.detailItem valueForKey:@"populousCity"];
            }
            
            break;
            
        case 1:
            // Statehood section
            lblItem.text = @"Statehood";
            lblValue.text = [dateFormatter stringFromDate:[self.detailItem valueForKey:@"date"]];;
            break;
            
        case 2:
            // Population section
            lblItem.text = @"Population";
            lblValue.text = [numberFormatter stringFromNumber:[self.detailItem valueForKey:@"population"]];
            break;
            
        default:
            break;
    }
         
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dismiss this viewcontroller
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
@end
