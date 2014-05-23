//
//  MasterViewController.m
//  Onesie
//
//  Created by Nuseir Yassin on 5/20/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "MasterViewController.h"
#import <Parse/Parse.h>
#import "DetailViewController.h"
#import "SWRevealViewController.h"


@interface MasterViewController ()
@property (strong, nonatomic) NSMutableArray *images;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    NSLog(@"USER: %@", [[PFUser currentUser] objectForKey:@"username"]);
    [super viewDidLoad];
    //setting up drawer menu
    _menuBtn.target = self.revealViewController;
    _menuBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    PFUser *currentUser = [PFUser currentUser];
    
//    [PFUser logOut];

    if (currentUser) {
        // do stuff with the user
        NSLog(@"user logged in");

    } else {
        // show the signup or login screen
        [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
    }
    _images = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Submissions";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"title";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.limit = 10;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"sent" equalTo:[NSNumber numberWithBool:YES]];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    static NSString *simpleTableIdentifier = @"first_submission";
    static NSString *simpleTableIdentifier2 = @"second_submission";
    
    UITableViewCell *cell;
    if(indexPath.row == 0)
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier2];
    if (cell == nil) {
        if(indexPath.row == 0)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier2];
    }

    NSLog(@"height %f", cell.frame.size.height );

    UILabel *title = (UILabel *)[cell viewWithTag:200];
    title.text = [object objectForKey:@"title"];
    
    UILabel *date = (UILabel *) [cell viewWithTag:400];
    date.text = [object objectForKey:@"date"];
    
    UIImageView *cellBackgroundImage = (UIImageView *)[cell viewWithTag:100];
    cellBackgroundImage.clipsToBounds = YES;


    //essentail code to make sure the image is displayed correctly
    cellBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [object[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cellBackgroundImage.image = [UIImage imageWithData:data];
        [_images addObject:cellBackgroundImage.image];
    }];


    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 250;
    }
    return 130;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{  
    
    if ([[segue identifier] isEqualToString:@"showDetail"] ||
        [[segue identifier] isEqualToString:@"showDetail2"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *submission = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:submission];
        [[segue destinationViewController] setPassedImg:[_images objectAtIndex:indexPath.row]];
    }
}

@end
