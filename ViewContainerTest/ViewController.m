//
//  ViewController.m
//  ViewContainerTest
//
//  Created by Ashish Awaghad on 2/7/13.
//  Copyright (c) 2013 Ashish Awaghad. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h" 

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, assign) float stackOriginY, heightOfEachTab, widthMargin, animationDuration;
@property (nonatomic, assign) int numOfTabs;
@property (nonatomic, strong) NSMutableArray *viewControllersArray;
@property (nonatomic, strong) NSArray *titles, *urlStrings;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.stackOriginY = 100;
    self.heightOfEachTab = 40;
    self.widthMargin = 3;
    self.numOfTabs = 5;
    self.animationDuration = 0.4;
    
    self.titles = @[@"Apple", @"Facebook", @"Twitter", @"Instagram", @"Google"];
    self.urlStrings = @[@"http://www.apple.com", @"http://www.facebook.com", @"http://www.twitter.com", @"http://www.instagram.com", @"http://www.google.com"];
    
    self.viewControllersArray = [[NSMutableArray alloc] init];
    for (int i=0; i<self.numOfTabs; i++) {
        WebViewController *webVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"WebViewController"];
        webVC.title = self.titles[i];
        webVC.stringURL = self.urlStrings[i];
        webVC.stackIndex = i;
        webVC.delegate = self;
        UINavigationController *con = [[UINavigationController alloc] initWithRootViewController:webVC];
        
        [self addChildViewController:con];
        [self.viewControllersArray addObject:con];
        [self.view addSubview:con.view];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self rearrangeSubViewControllersAnimated:false];
            
            for (int i=0; i<self.viewControllersArray.count; i++) {
                WebViewController *webVC = (WebViewController *)((UINavigationController *)[self.viewControllersArray objectAtIndex:i]).topViewController;
                webVC.frameWhenCollapsed = webVC.navigationController.view.frame;
            }
        });
    });
}

- (void) bringSubviewControllerToFront:(UIViewController *)controller animated:(BOOL)animated {
    WebViewController *webVCBeingMoved = (WebViewController *)controller;
    webVCBeingMoved.isFullScreen = YES;
    float duration = 0.0;
    
    if (animated) {
        duration = self.animationDuration;
    }
    
    for (int i=0; i<webVCBeingMoved.stackIndex; i++) {
        [UIView animateWithDuration:duration animations:^{
            UINavigationController *navCon = [self.viewControllersArray objectAtIndex:i];
            CGRect frame = self.view.bounds;
            frame.origin.y = self.view.bounds.size.height;
            navCon.view.frame = frame;
        }];
    }
    
    for (int i=webVCBeingMoved.stackIndex; i<=webVCBeingMoved.stackIndex; i++) {
        [UIView animateWithDuration:duration animations:^{
            UINavigationController *navCon = [self.viewControllersArray objectAtIndex:i];
            navCon.view.frame = self.view.bounds;
        }];
    }
    
    for (int i=webVCBeingMoved.stackIndex+1; i<self.viewControllersArray.count; i++) {
        [UIView animateWithDuration:duration animations:^{
            UINavigationController *navCon = [self.viewControllersArray objectAtIndex:i];
            CGRect frame = self.view.bounds;
            frame.origin.y = self.view.bounds.size.height;
            navCon.view.frame = frame;
        }];
    }
}

- (void) rearrangeSubViewControllersAnimated:(BOOL)animated {
    int i = 0;
    for (UIViewController *con in self.viewControllersArray) {
        float originX = (self.viewControllersArray.count-i)*self.widthMargin;
        
        float duration = 0.0;
        
        if (animated) {
            duration = self.animationDuration;
        }
        
        [UIView animateWithDuration:duration animations:^{
            con.view.frame = CGRectMake(originX, self.stackOriginY + i*self.heightOfEachTab, self.view.frame.size.width - 2*originX, self.view.frame.size.height);
        }];
        i++;
        
        ((WebViewController *) con.navigationController.topViewController).isFullScreen = false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) navBarDidTap:(UIPanGestureRecognizer *)panGesture inController:(UIViewController *)controller{
    WebViewController *webVC = (WebViewController *)controller;
    
    NSString *str = @"Before ";
    for (UINavigationController *con in self.viewControllersArray) {
        WebViewController *tmp = (WebViewController *)con.topViewController;
        str = [str stringByAppendingFormat:@"%d ", tmp.isFullScreen];
    }
    NSLog(@"%@", str);
    if (webVC.isFullScreen) {
        [self rearrangeSubViewControllersAnimated:YES];
        webVC.isFullScreen = false;
    }
    else {
        [self bringSubviewControllerToFront:controller animated:YES];
    }
    str = @"After ";
    for (UINavigationController *con in self.viewControllersArray) {
        WebViewController *tmp = (WebViewController *)con.topViewController;
        str = [str stringByAppendingFormat:@"%d ", tmp.isFullScreen];
    }
    
    NSLog(@"%@", str);
}

- (void) scrollViewScrolled:(UIScrollView *)webView inController:(UIViewController *)controller {
    WebViewController *webVC = (WebViewController *)controller;
    
    if (webVC.isFullScreen) {
        if (webView.contentOffset.y < 0) {
            
        }
    }
}

- (void) navBarDidPan:(UIPanGestureRecognizer *)panGesture inController:(UIViewController *)controller{
    CGPoint point = [panGesture locationInView:self.view];
    
    [self didPanToPoint:point inController:controller andState:panGesture.state];
}

- (void) didPanToPoint:(CGPoint)point inController:(UIViewController *)controller andState:(UIGestureRecognizerState)state{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    WebViewController *webVC = (WebViewController *)controller;
    float pointY = point.y - webVC.margin;
    
    if (!webVC.isFullScreen) {
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
            if (pointY > webVC.frameWhenCollapsed.origin.y) {
                for (int i=webVC.stackIndex; i<self.viewControllersArray.count;i++) {
                    UINavigationController *navCon = (UINavigationController *) [self.viewControllersArray objectAtIndex:i];
                    
                    [viewControllers addObject:navCon];
                }
            }
            else {
                [viewControllers addObject:webVC.navigationController];
            }
        }
        
        int i=0;
        for (UINavigationController *navCon in viewControllers) {
            CGRect frame = navCon.view.frame;
            frame.origin.y = pointY + i*self.heightOfEachTab;
            if (frame.origin.y < 0) {
                frame.origin.y = 0;
            }
            navCon.view.frame = frame;
            i++;
        }
        if (state == UIGestureRecognizerStateEnded) {
            if (pointY < webVC.frameWhenCollapsed.origin.y - self.heightOfEachTab) {
                [self bringSubviewControllerToFront:webVC animated:YES];
            }
            else {
                [self rearrangeSubViewControllersAnimated:YES];
            }
        }
    }
    else {
        float heightFactor = pointY / webVC.frameWhenCollapsed.origin.y;
        for (int i=0;i<=webVC.stackIndex;i++) {
            UINavigationController *navCon = [self.viewControllersArray objectAtIndex:i];
            CGRect frame = navCon.view.frame;
            WebViewController *webVCTmp = (WebViewController *)navCon.topViewController;
            frame.origin.y = pointY + (i-webVC.stackIndex)*self.heightOfEachTab*heightFactor;
            if (frame.origin.y < 0) {
                frame.origin.y = 0;
            }
            else if(i < webVC.stackIndex && (frame.origin.y > webVCTmp.frameWhenCollapsed.origin.y || heightFactor > 1.0)) {
                frame.origin.y = webVCTmp.frameWhenCollapsed.origin.y;
            }
            
            float originX = (self.viewControllersArray.count-i)*self.widthMargin;
            
            if (heightFactor < 1.0) {
                originX *=heightFactor;
            }
            
            frame.origin.x = originX;
            frame.size.width = self.view.frame.size.width - 2*originX;
            //NSLog(@"%d %d", i, webVCTmp.stackIndex);
            navCon.view.frame = frame;
        }
        if (state == UIGestureRecognizerStateEnded) {
            if (pointY < self.heightOfEachTab) {
                [self bringSubviewControllerToFront:webVC animated:YES];
            }
            else {
                [self rearrangeSubViewControllersAnimated:YES];
            }
        }
    }
}

@end
