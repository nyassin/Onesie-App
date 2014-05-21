//
//  SignUpVC.m
//  Onesie
//
//  Created by Laurent Rivard on 5/21/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "SignUpVC.h"
#import <Parse/Parse.h>

@interface SignUpVC ()
@property (strong, nonatomic) IBOutlet FBLoginView *fbLoginView;

@end

@implementation SignUpVC

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
    // Do any additional setup after loading the view.
    
    //setting facebook permissions
    [_fbLoginView setReadPermissions:@[@"public_profile", @"email"]];
    [_fbLoginView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(IBAction)signUpBtn:(id)sender {
//    NSArray *perm = @[@"public_profile", @"email"];
//
//}

#pragma mark Facebook functions

// This method will be called when the user information has been fetched after login
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)FBUser {
    NSLog(@"user info : %@", FBUser);
    NSLog(@"id: %@", FBUser.objectID);
    [PFUser logInWithUsernameInBackground:FBUser.objectID password:FBUser.objectID
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"user already exists");
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"user does not exists. so sign him up");
                                            
                                            PFUser *newUser = [PFUser user];
                                            newUser.email = [FBUser objectForKey:@"email"];
                                            newUser.password = FBUser.objectID;
                                            newUser.username = FBUser.objectID;
                                            newUser[@"first_name"] = FBUser.first_name;
                                            newUser[@"last_name"] = FBUser.last_name;
                                            newUser[@"name"] = FBUser.name;
                                            
                                            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                if (!error) {
                                                    // Hooray! Let them use the app now.
                                                    NSLog(@"success! User has signed up");
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                } else {
                                                    NSString *errorString = [error userInfo][@"error"];
                                                    // Show the errorString somewhere and let the user try again.
                                                    NSLog(@"error signing up: %@", errorString);
                                                }
                                            }];

                                        }
                                    }];
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
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
