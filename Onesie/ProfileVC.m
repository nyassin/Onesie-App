//
//  ProfileVC.m
//  Onesie
//
//  Created by Laurent Rivard on 5/21/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "ProfileVC.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
@interface ProfileVC ()
@property (strong, nonatomic) UIBarButtonItem *menuBtn;
@property (strong, nonatomic) IBOutlet FBLoginView *fbLoginView;
@end

@implementation ProfileVC

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

    _menuBtn = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.leftBarButtonItem = _menuBtn;
    
    //set up state of notification based on the database 
    NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
    if( [subscribedChannels indexOfObject:@"user"] != NSNotFound) {
        NSLog(@"SUBSCRIBED");
        [_onOffSwitch setOn:YES animated:YES];
    } else {
        NSLog(@"Not subscribed");
        [_onOffSwitch setOn:NO animated:YES];
    }

    
    //Change label with the user name
    
    _userName.text = [[PFUser currentUser] objectForKey:@"name"];
    //setting up drawer menu
    _menuBtn.target = self.revealViewController;
    _menuBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
}

-(IBAction)logoutBtnClicked:(id)sender {

    NSLog(@"hello");
    
    if (FBSession.activeSession.isOpen)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    [PFUser logOut];
    [self performSegueWithIdentifier:@"SignUpNotAnimated" sender:self];
}
-(void) logoutUser: (UITapGestureRecognizer *) sender {
    NSLog(@"trying to logout");
    [PFUser logOut];
    [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
}
-(IBAction)onOffSwitchAction:(id)sender {

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    
    if(_onOffSwitch.on) {
        // lights on
        NSLog(@"%@", [currentInstallation channels]);
        [currentInstallation addUniqueObject:@"user" forKey:@"channels"];
    }
    
    else {
        // lights off
          NSLog(@"IT'S OFF");
        [currentInstallation removeObject:@"user" forKey:@"channels"];
    }
    [currentInstallation saveInBackground];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
