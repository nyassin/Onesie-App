//
//  ProfileVC.h
//  Onesie
//
//  Created by Laurent Rivard on 5/21/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController


@property (strong, nonatomic) IBOutlet UISwitch *onOffSwitch;

- (IBAction) onOffSwitchAction: (id) sender;


@end
