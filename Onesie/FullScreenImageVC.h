//
//  FullScreenImageVC.h
//  Onesie
//
//  Created by Laurent Rivard on 5/22/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenImageVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *passedImg;
@end
