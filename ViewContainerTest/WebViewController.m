//
//  WebViewController.m
//  ViewContainerTest
//
//  Created by Ashish Awaghad on 2/7/13.
//  Copyright (c) 2013 Ashish Awaghad. All rights reserved.
//

#import "WebViewController.h"
#import "ViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(navBarDidPan:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navBarDidTap:)];
    [self.navigationController.navigationBar addGestureRecognizer:panGesture];
    [self.navigationController.navigationBar addGestureRecognizer:tapGesture];
    [self.webView setBackgroundColor:[UIColor colorWithRed:self.stackIndex*30.0/255.0 green:self.stackIndex*50.0/255.0 blue:self.stackIndex*20.0/255.0 alpha:1.0]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.stringURL]]];
    self.isFullScreen = false;
    //self.title = [NSString stringWithFormat:@"%d", self.stackIndex];
}

- (void) viewWillAppear:(BOOL)animated {
    
}

- (void) viewDidAppear:(BOOL)animated {
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
}

- (void) viewDidDisappear:(BOOL)animated {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.delegate scrollViewScrolled:scrollView inController:self];
}

- (void) navBarDidTap:(UIPanGestureRecognizer *)panGesture {
    [self.delegate navBarDidTap:panGesture inController:self];
}

- (void) navBarDidPan:(UIPanGestureRecognizer *)panGesture {
    NSLog(@"DidPan: %d", self.stackIndex);
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [panGesture locationInView:self.navigationController.navigationBar];
        self.margin = point.y;
    }
    
    [self.delegate navBarDidPan:panGesture inController:self];
    
    if(panGesture.state == UIGestureRecognizerStateEnded) {
        self.margin = 0.0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
