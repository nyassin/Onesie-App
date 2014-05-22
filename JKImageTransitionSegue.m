//
//  JKImageTransitionSegue.m
//  ImageTransition
//
//  Created by Joris Kluivers on 1/12/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKImageTransitionSegue.h"

@interface JKImageTransitionSegue ()
@property(readonly) UIImageView *transitionImageView;
@end

@implementation JKImageTransitionSegue {
	UIImageView *_transitionImageView;
}

- (id) initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
	if (self) {
		_unwinding = NO;
		_destinationRect = CGRectZero;
	}
	return self;
}

- (UIImageView *) transitionImageView {
	if (!_transitionImageView) {
		_transitionImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	}
	
	return _transitionImageView;
}

- (void) perform {
	UIWindow *mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
	
	CGRect sourceRectInWindow = [mainWindow convertRect:self.sourceRect fromView:((UIViewController *)self.sourceViewController).view];
	
	UIImageView *imageView = self.transitionImageView;
	imageView.image = self.transitionImage;
	imageView.frame = sourceRectInWindow;
	
	[mainWindow addSubview:imageView];
	
	CGRect dest = self.destinationRect;
	if (CGRectEqualToRect(dest, CGRectZero)) {
		
		CGSize transitionSize = self.transitionImage.size;
		CGRect screenBounds = [UIScreen mainScreen].bounds;
		
		CGFloat factor = fminf(
			CGRectGetWidth(screenBounds) / self.transitionImage.size.width,
			CGRectGetHeight(screenBounds) / self.transitionImage.size.height
		);
		
		dest.size = CGSizeMake(transitionSize.width * factor, transitionSize.height * factor);
		dest.origin = CGPointMake(
			roundf((CGRectGetWidth(screenBounds) - CGRectGetWidth(dest)) / 2.0f),
			roundf((CGRectGetHeight(screenBounds) - CGRectGetHeight(dest)) / 2.0f)
		);
	} else {
		UIView *sourceView = ((UIViewController *)self.sourceViewController).view;
		dest = [sourceView convertRect:dest toView:sourceView.window];
		
		// TODO: tmp fix for status bar
		dest.origin.y += 20.0f;
	}
	
	[UIView animateWithDuration:0.4f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
		
		imageView.frame = dest;
		
		if (self.unwinding) {
			[self.destinationViewController dismissViewControllerAnimated:YES completion:nil];
		} else {
			((UIViewController *)self.destinationViewController).modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
		}
	} completion:^(BOOL completed) {
		imageView.hidden = YES;
		[imageView removeFromSuperview];
	}];
}

@end
