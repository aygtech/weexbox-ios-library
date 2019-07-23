//
//  TwoViewController.m
//  WeexBoxExample
//
//  Created by Baird-weng on 2019/7/9.
//  Copyright © 2019 WeexBox. All rights reserved.
//

#import "TwoViewController.h"
#import "WeexBoxExample-Swift.h"
@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.purpleColor;
    NSLog(@"接收weex页面的参数===============%@",self.routerParams);
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
