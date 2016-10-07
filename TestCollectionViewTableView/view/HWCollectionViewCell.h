//
//  HWCollectionViewCell.h
//  TestCollectionViewTableView
//
//  Created by hw on 2016/10/5.
//  Copyright © 2016年 hwacdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWCollectionViewCell : UICollectionViewCell

/**
 UICollectionView当前显示的cell的索引
 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UINavigationController *navigationController;

@end
