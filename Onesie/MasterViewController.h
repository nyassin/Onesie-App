//
//  MasterViewController.h
//  Onesie
//
//  Created by Nuseir Yassin on 5/20/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MasterViewController : PFQueryTableViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
- (IBAction)logout:(id)sender;

@end



//TODO
/*
 * 1-progressHUD
 * 2-store up to 5.
 * 3-make profile page
 *
 */