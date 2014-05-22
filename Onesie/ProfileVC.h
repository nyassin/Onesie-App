//
//  ProfileVC.h
//  Onesie
//
//  Created by Laurent Rivard on 5/21/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileVC : UIViewController <FBLoginViewDelegate>


@property (strong, nonatomic) IBOutlet UISwitch *onOffSwitch;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIButton *logoutBtn;

-(IBAction)logoutBtnClicked:(id)sender;

- (IBAction) onOffSwitchAction: (id) sender;


@end
