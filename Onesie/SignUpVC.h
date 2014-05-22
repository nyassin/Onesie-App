//
//  SignUpVC.h
//  Onesie
//
//  Created by Laurent Rivard on 5/21/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SignUpVC : UIViewController <FBLoginViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *loginWithFacebook;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


//-(IBAction)signUpBtn:(id)sender;
-(IBAction)changePageControl;

@end
