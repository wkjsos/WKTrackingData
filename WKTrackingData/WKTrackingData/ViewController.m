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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    
    [tap addTarget:self action:@selector(tap)];
    
    self.sub.wk_trackingData = @{
        @"id" : @"4396",
        @"type" : @"event_type"
    };
    
    [self.sub addGestureRecognizer:tap];
    
    self.slider.wk_ignoreTracking = YES;
    
    kWKTrackingDataManager.uploadTrackingDataTrigger = ^(NSArray *trackingDataArray, void (^remove)(void)) {
        
        // do something
        
        // remove uploaded data
        remove();
    };
    
}

- (void)tap {
    NSLog(@"view tap");
}
- (IBAction)switchChange:(id)sender {
}

- (IBAction)buttonClick:(UIButton *) button {
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"cancle" otherButtonTitles:@"confirm", nil];
//    [alertView show];
//    return;

    UIViewController *topVC = [UIViewController wk_topViewController];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleDestructive handler:nil]];

    __block BOOL waitForBlock = YES;
    [topVC presentViewController:alertController animated:NO completion:^{
        waitForBlock = NO;
    }];
}

- (IBAction)segementChange:(id)sender {
}
- (IBAction)sliderChange:(id)sender {
}
- (IBAction)stepperChange:(id)sender {
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//
//}

#pragma mark - private method

- (void)test {
    [WKTrackingDataManager sharedTrackingDataManager].uploadTrackingDataTrigger = ^(NSArray *trackingDataArray, void (^remove)(void)) {
        NSLog(@"trackingDataArray");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            remove ? remove() : nil;
        });
    };
    
    for (int i = 0; i < 31; i++) {
        [[WKTrackingDataManager sharedTrackingDataManager] memeryCacheTrackingData:@{
            [NSString stringWithFormat:@"key:%@" , @(i)] : [NSString stringWithFormat:@"value:%@" , @(i)]
        }];
    }
}

@end
