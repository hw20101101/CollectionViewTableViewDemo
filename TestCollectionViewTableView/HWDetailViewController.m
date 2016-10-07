//
//  HWDetailViewController.m
//  TestCollectionViewTableView
//
//  Created by hw on 2016/10/6.
//  Copyright © 2016年 hwacdx. All rights reserved.
//

#import "HWDetailViewController.h"

@interface HWDetailViewController ()

@property (nonatomic, copy) NSString *content;

@end

@implementation HWDetailViewController

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content
{
    if (self = [super init]) {
        self.title = title;
        _content = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self initUI];
}

- (void)initUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = self.content;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    __weak typeof(self) weakSelf = self;
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(66, 20, 100, 20));
    }];
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
