//
//  WebViewController.h
//  ViewContainerTest
//
//  Created by Ashish Awaghad on 2/7/13.
//  Copyright (c) 2013 Ashish Awaghad. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WebViewControllerDelegate;

@interface WebViewController : UIViewController


@property (nonatomic, weak) id <WebViewControllerDelegate> delegate;
@property (nonatomic, assign) float margin;
@property (nonatomic, strong) NSString *stringURL;
@property (nonatomic, assign) int stackIndex;
@property (nonatomic, assign) BOOL isFullScreen;
@property (assign, nonatomic) CGRect frameWhenCollapsed;

@end

@protocol WebViewControllerDelegate
@required
- (void) navBarDidTap:(UIPanGestureRecognizer *)panGesture inController:(UIViewController *)controller;
- (void) scrollViewScrolled:(UIScrollView *)webView inController:(UIViewController *)controller;
- (void) navBarDidPan:(UIPanGestureRecognizer *)panGesture inController:(UIViewController *)controller;

@end