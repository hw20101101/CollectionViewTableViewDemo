//
//  ViewController.m
//  TestCollectionViewTableView
//
//  Created by hw on 2016/10/5.
//  Copyright © 2016年 hwacdx. All rights reserved.
//

#define kCellIdentifier @"HWCollectionViewCell"
#define kScrollViewY 64
#define kScrollViewH 35
#define kCollectionViewY kScrollViewY + kScrollViewH
#define kButtonW 65.0

#import "ViewController.h"
#import "HWCollectionViewCell.h"
#import "HWDetailViewController.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

/**
 UICollectionView当前显示的cell的索引
 */
@property (nonatomic, assign) NSInteger cellIndex;

/**
 collectionViewCell的宽度
 */
@property (nonatomic, assign) CGFloat cellWidth;

/**
 collectionViewCell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIView *lineBgView;

/**
 标签条的文本数组
 */
@property (nonatomic, strong) NSArray *tabTitleArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

#pragma mark - Rotation
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setCellWidthHeight];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"UICollectionView&UITableView";
    //使用UINavigationController后导致UIScollView下移64px
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setCellWidthHeight];
    [self initTabView];
    [self initCollectionView];
}

- (void)setCellWidthHeight
{
    self.cellWidth = [UIScreen mainScreen].bounds.size.width;
    self.cellHeight = [UIScreen mainScreen].bounds.size.height - kCollectionViewY;
}

- (NSArray *)tabTitleArray
{
    if (!_tabTitleArray) {
        _tabTitleArray = @[@"最新", @"排行榜", @"苹果", @"热评", @"手机", @"数码"];
    }
    return _tabTitleArray;
}

#pragma mark - init UI
- (void)initTabView
{
    __weak typeof(self) weakSelf = self;
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.tabTitleArray.count * kButtonW, 0);
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrollViewY);
        make.height.equalTo(@kScrollViewH);
        make.left.right.equalTo(weakSelf.view);
    }];
    
    for (int i = 0; i < self.tabTitleArray.count; i ++) {
        CGFloat buttonX = i * kButtonW;
        UIButton *button = [[UIButton alloc] init];
        [button setTag:i];
        [button setShowsTouchWhenHighlighted:YES];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitle:self.tabTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@(buttonX));
            make.size.mas_equalTo(CGSizeMake(kButtonW, 30));
        }];
    }
    
    self.lineBgView = [[UIView alloc] init];
    self.lineBgView.frame = CGRectMake(0, 33, kButtonW, 2);
    [self.scrollView addSubview:self.lineBgView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor redColor];
    [self.lineBgView addSubview:lineView];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineBgView);
        make.centerX.equalTo(weakSelf.lineBgView);
        make.size.mas_equalTo(CGSizeMake(45, 2));
    }];
}

- (void)initCollectionView
{
    __weak typeof(self) weakSelf = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[HWCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView.bottom).offset(1);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
}


#pragma mark - action
- (void)buttonOnClick:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    NSInteger cellIndex = button.tag;
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat buttonX = cellIndex * kButtonW;
        CGRect tempF = weakSelf.lineBgView.frame;
        tempF.origin.x = buttonX;
        weakSelf.lineBgView.frame = tempF;
    }];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth, self.cellHeight);
}

//此处不返回0会导致UICollectionView滚动的时候分页显示有问题
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tabTitleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.didSelectRowCallBack = ^(NSString *content){
        
        NSString *title = [NSString stringWithFormat:@"collection_index:%d", weakSelf.cellIndex];
        HWDetailViewController *vc = [[HWDetailViewController alloc] initWithTitle:title content:content];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //计算collectionView当前在哪一页
    self.cellIndex = scrollView.contentOffset.x / kScreenWidth;
    
    if ([[scrollView class] isSubclassOfClass:[UICollectionView class]]) {
        //设置红色线条的frame
        CGFloat scale = kButtonW / kScreenWidth;
        CGRect frame = self.lineBgView.frame;
        frame.origin.x = scrollView.contentOffset.x * scale;
        self.lineBgView.frame = frame;
        
        CGPoint point = self.scrollView.contentOffset;
        if(self.cellIndex == 0){//collectionView滚动到了第一页
            point.x = 0;
        } else if (self.cellIndex == self.tabTitleArray.count - 1) {//collectionView滚动到了最后一页
            point.x = kButtonW;
        }
        
        self.scrollView.contentOffset = point;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
