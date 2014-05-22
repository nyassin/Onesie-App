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

-(void)viewWillAppear:(BOOL)animated {

    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage
                                                                       imageNamed:@"background_cloth.png"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self.view bringSubviewToFront:_pageControl];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //setting facebook permissions
    [_fbLoginView setReadPermissions:@[@"public_profile", @"email"]];
    [_fbLoginView setDelegate:self];
    

    UIImage *image1;
    UIImage *image2;
    UIImage *image3;
    
    if (self.view.frame.size.height > 480.0f) {
        image1 = [UIImage imageNamed:@"FirstScreen.jpg"];
        image2 = [UIImage imageNamed:@"SecondScreen.jpg"];
        image3 = [UIImage imageNamed:@"ThirdScreen.jpg"];
        
    } else {
        image1 = [UIImage imageNamed:@"tutorial-1"];
        image2 = [UIImage imageNamed:@"tutorial-2"];
        image3 = [UIImage imageNamed:@"tutorial-3"];
        
    }
    
    NSArray *pictures = [NSArray arrayWithObjects:image1, image2, image3, nil];
    for (int i = 0; i < pictures.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        subview.image = [pictures objectAtIndex:i];
        
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width
                                             * pictures.count, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    
    [self.view addSubview:_fbLoginView];
    [self.view bringSubviewToFront:_fbLoginView];
}

-(void)changePageControl {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width
    * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    NSLog(@"Did scroll!");
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2)
                     / pageWidth) + 1;
    self.pageControl.currentPage = page;
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
    
    NSString *token = [[PFInstallation currentInstallation] deviceToken];
    NSLog(@"%@", token);
    [PFUser logInWithUsernameInBackground:FBUser.objectID password:FBUser.objectID
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"user already exists");
                                            NSLog(@"user_id : %@", user);
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
//                                            newUser[@"deviceToken"] = token;
                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                            [defaults setObject:FBUser.objectID forKey:@"username"];
                                            [defaults synchronize];
                                            
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
