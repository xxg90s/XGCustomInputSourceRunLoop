//
//  ViewController.m
//  XGCustomInputSourceRunLoop
//
//  Created by xxg90s on 2022/4/19.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del fireInputSource];
}

@end
