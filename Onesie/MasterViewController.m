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

@interface MasterViewController ()
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        NSLog(@"user logged in");
    } else {
        // show the signup or login screen
        [self performSegueWithIdentifier:@"SignUpSegue" sender:self];

    }
    
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
    NSLog(@"query : %@", query);
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    NSLog(@"image url: %@", object[@"createdAt"]);
    
    static NSString *simpleTableIdentifier = @"submission";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
//    UIImageView *cellBackgroundImage = (UIImageView *)[cell viewWithTag:9];
//    //essentail code to make sure the image is displayed correctly
//    cellBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
//    cellBackgroundImage.clipsToBounds = YES;
    
    UILabel *title = (UILabel *)[cell viewWithTag:200];
    title.text = [object objectForKey:@"title"];
    
    UILabel *date = (UILabel *) [cell viewWithTag:400];
    date.text = [object objectForKey:@"date"];
    
    UIImageView *cellBackgroundImage = (UIImageView *)[cell viewWithTag:100];
//    cellBackgroundImage.frame = cell.frame;
    //essentail code to make sure the image is displayed correctly
    cellBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    cellBackgroundImage.clipsToBounds = YES;
    [object[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cellBackgroundImage.image = [UIImage imageWithData:data];
    }];
//    cellBackgroundImage.image = [UIImage imageWithData:object[@"image"]]//[UIImage imageNamed:@"onesie.jpg"];
    
//    cell.imageView.image = [UIImage imageNamed:@"onesie.jpg"];

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
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *submission = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:submission];
//        [[segue destinationViewController] setPassedImg:<#(UIImage *)#>]
    }
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"SignUpSegue" sender:self];

}
@end
