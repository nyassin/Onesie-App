//
//  SignUpVC.h
//  Onesie
//
//  Created by Laurent Rivard on 5/21/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SignUpVC : UIViewController <FBLoginViewDelegate>
-(IBAction)signUpBtn:(id)sender;

@end
