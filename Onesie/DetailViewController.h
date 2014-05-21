//
//  DetailViewController.h
//  Onesie
//
//  Created by Nuseir Yassin on 5/20/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) PFObject *detailItem;

@property (weak, nonatomic) PFObject *submission;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
