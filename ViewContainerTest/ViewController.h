//
//  ViewController.h
//  ViewContainerTest
//
//  Created by Ashish Awaghad on 2/7/13.
//  Copyright (c) 2013 Ashish Awaghad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@interface ViewController : UIViewController <WebViewControllerDelegate>

- (void) navBarDidPan:(UIPanGestureRecognizer *)panGesture inController:(UIViewController *)controller;
- (void) navBarDidTap:(UIPanGestureRecognizer *)panGesture inController:(UIViewController *)controller;
- (void) scrollViewScrolled:(UIScrollView *)webView inController:(UIViewController *)controller;
@end
