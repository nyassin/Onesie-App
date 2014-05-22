//
//  DetailViewController.m
//  Onesie
//
//  Created by Nuseir Yassin on 5/20/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "DetailViewController.h"
#import "JKImageTransitionSegue.h"
#import "FullScreenImageVC.h"
@interface DetailViewController ()
- (void)configureView;
@property BOOL fullScreen;
//@property (strong, nonatomic) UIImageView *fullScreenImageView;

@property CGRect originalRect;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setSubmission:(PFObject *)newSubmission
{
    if (_detailItem != newSubmission) {
        _detailItem = newSubmission;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        _fullScreen = NO;
        _originalRect = _imageView.frame;
        self.title = self.detailItem[@"date"];
        self.detailDescriptionLabel.text = [_detailItem objectForKey:@"title"];
        _titleLbl.text = [_detailItem objectForKey:@"title"];
        _textView.text = [_detailItem objectForKey:@"body"];
        _imageView.image = _passedImg;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullScreen)];
//        tap.numberOfTapsRequired = 1;
//        [_imageView addGestureRecognizer:tap];
        
        //add long press to save image
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        longPress.minimumPressDuration = 1;
        [_imageView addGestureRecognizer:longPress];
        
//        _fullScreenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
//        _fullScreenImageView.image = _passedImg;
//        [self.view bringSubviewToFront:_fullScreenImageView];
////        [_fullScreenImageView setHidden:YES];
    }
}
-(void) longPressed: (UILongPressGestureRecognizer *) sender {
    NSLog(@"long press pressed");
    if(sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *saveAction = [[UIActionSheet alloc] initWithTitle:@"Save Image?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save to library", nil];
        [saveAction showInView:self.view];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        NSLog(@"save pressed");
        UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
    }
}
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        UIAlertView *saving = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops, something went wrong. \n Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [saving show];
    } else {
        UIAlertView *saving = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Congrats, the photo is now in your library" delegate:nil cancelButtonTitle:@"Great!" otherButtonTitles:nil];
        [saving show];
    }
}
/*
-(void) showFullScreen {
    NSLog(@"FULL SCREEN: %hhd", _fullScreen);
    NSLog(@"not doing anything in 1.0");
//    if(_fullScreen) {
//        [[[UIApplication sharedApplication] delegate].window addSubview:_imageView];
//        [UIView animateWithDuration:0.5 animations:^{
//            _imageView.frame = _originalRect;
//            
//        } completion:^(BOOL finished) {
//            _fullScreen = NO;
//        }];
//        [_fullScreenImageView setHidden:YES];
//    }
//    else {
//        [[[UIApplication sharedApplication] delegate].window addSubview:_imageView];
//        [UIView animateWithDuration:0.5 animations:^{
//            _imageView.frame = [[UIScreen mainScreen] bounds];
//            
//        } completion:^(BOOL finished) {
//            _fullScreen = YES;
//        }];
//        NSLog(@"not full screen");
//        _fullScreenImageView.image = _imageView.image;
//        [_fullScreenImageView setHidden:NO];
//        [self.view bringSubviewToFront:_fullScreenImageView];
//    }
//    [self.view bringSubviewToFront:_imageView];
//    [self performSegueWithIdentifier:@"FullScreenImageSegue" sender:self];
}
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}
/*
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if (![segue isKindOfClass:[JKImageTransitionSegue class]]) {
		return;
	}
	
	FullScreenImageVC *imageController = (FullScreenImageVC *)segue.destinationViewController;
	
	// provide destination with full image
	imageController.passedImg = _passedImg;
	
	// configure segue
//	UIButton *imageButton = (UIButton *)sender;
	JKImageTransitionSegue *imageSegue = (JKImageTransitionSegue *)segue;
//
	imageSegue.sourceRect = _imageView.frame;
	imageSegue.transitionImage = _imageView.image;
//
	_imageView.hidden = YES;
}

- (IBAction) unwindFromSegue:(UIStoryboardSegue *)segue
{
	
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
	JKImageTransitionSegue *imageTransition = [[JKImageTransitionSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
	imageTransition.unwinding = YES;
	imageTransition.transitionImage = self.imageView.image;
//
	CGRect sourceRect = ((FullScreenImageVC *)fromViewController).imageView.frame;
	sourceRect.origin.y -= ((FullScreenImageVC *)fromViewController).imageView.frame.origin.y;
	sourceRect.origin.x -= ((FullScreenImageVC *)fromViewController).imageView.frame.origin.x;
	imageTransition.sourceRect = sourceRect;
//
	imageTransition.destinationRect = self.imageView.frame;
//
	((FullScreenImageVC *)fromViewController).imageView.hidden = YES;
	
	return imageTransition;
} */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
