//
//  HWCollectionViewCell.m
//  TestCollectionViewTableView
//
//  Created by hw on 2016/10/5.
//  Copyright © 2016年 hwacdx. All rights reserved.
//

#import "HWDetailViewController.h"
#import "HWCollectionViewCell.h"
#import "HWTableViewCell.h"

@interface HWCollectionViewCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HWCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.contentView addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(26, 0, 0, 0));
    }];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    _dataSource = @[@"暴降700元！苹果iPhone7国行256GB版国美售价创新低", @"科技宅福利：轻柔时尚，恒源祥男士修身立领羽绒服298元", @"美核潜艇内部曝光：艇员睡在导弹发射管间", @"中国科学家成功解析牛带绦虫和亚洲带绦虫基因组序列", @"韩媒：三星将为高通代工骁龙830，多数Galaxy S8会搭载"];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HWTableViewCell"];
    if (!cell) {
        cell = [[HWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HWTableViewCell"];
    }
         
    cell.textLabel.text = [NSString stringWithFormat:@"collection_index:%d", self.index];
    cell.detailTextLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *title = [NSString stringWithFormat:@"collection_index:%d", self.index];
    NSString *content = self.dataSource[indexPath.row];
    HWDetailViewController *vc = [[HWDetailViewController alloc] initWithTitle:title content:content];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
