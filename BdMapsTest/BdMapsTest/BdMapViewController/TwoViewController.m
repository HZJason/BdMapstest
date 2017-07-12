//
//  TwoViewController.m
//  BdMapsTest
//
//  Created by 黄泽 on 2017/7/12.
//  Copyright © 2017年 黄泽. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pointLb;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pointLb.text = [NSString stringWithFormat:@"车场Id是%@",_parkingId];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
