//
//  JKImageTransitionSegue.h
//  ImageTransition
//
//  Created by Joris Kluivers on 1/12/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKImageTransitionSegue : UIStoryboardSegue

@property(assign) BOOL unwinding;

@property(assign) CGRect sourceRect;
@property(assign) CGRect destinationRect;

@property(strong) UIImage *transitionImage;

@end
