//
//  FullScreenImageVC.m
//  Onesie
//
//  Created by Laurent Rivard on 5/22/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "FullScreenImageVC.h"

@interface FullScreenImageVC ()
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeBtnPressed:(id)sender;
@end

@implementation FullScreenImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageView.image = _passedImg;
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

- (IBAction)closeBtnPressed:(id)sender {
    
}
@end
