//
//  ViewController.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/2.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "ViewController.h"

#import "WKTrackingDataManager.h"

#import "UIViewController+Tracking.h"

@interface ViewController ()

<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *sub;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testUploadTrackingData];
    
    [self testIgnoreTracking];
    [self test_wk_trackingData];
    
    [self testTapGestureRecognizer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self testAlertAction];
}

#pragma mark - test method

- (void)testTapGestureRecognizer {
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tap)];
    [self.sub addGestureRecognizer:tap];
}

- (void)test_wk_trackingData {
    self.sub.wk_trackingData = @{
        @"id" : @"4396",
        @"type" : @"event_type"
    };
}

- (void)testIgnoreTracking {
    self.slider.wk_ignoreTracking = YES;
}

- (void)testAlertAction {
    UIViewController *topVC = [UIViewController wk_topViewController];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleDestructive handler:nil]];

    __block BOOL waitForBlock = YES;
    [topVC presentViewController:alertController animated:NO completion:^{
        waitForBlock = NO;
    }];
}

- (void)testAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"cancle" otherButtonTitles:@"confirm", nil];
    [alertView show];
}

- (void)testUploadTrackingData {
    kWKTrackingDataManager.uploadTrackingDataTrigger = ^(NSArray *trackingDataArray, void (^remove)(void)) {
        // do something
        
        // remove uploaded data
        remove();
    };
}

#pragma mark - event method

- (void)tap {
    NSLog(@"view tap");
}

@end
