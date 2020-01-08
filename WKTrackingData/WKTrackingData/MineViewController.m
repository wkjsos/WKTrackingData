//
//  MineViewController.m
//  WKTrackingData
//
//  Created by wkj on 2020/1/3.
//  Copyright © 2020 wkj. All rights reserved.
//

#import "MineViewController.h"

#import "CollectionViewCell.h"

@interface MineViewController ()

    <
        UICollectionViewDataSource,
        UICollectionViewDelegate
    >

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor systemGray2Color];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

#pragma mark - UICollectionViewDelegate

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemWidth = 50 ;
        CGFloat itemHeight = 50;
        CGFloat collectionViewLeft = 5;
        CGFloat collectionViewTop = 5;

        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = 2;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, collectionViewLeft, 0, collectionViewLeft);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, collectionViewTop, 200, 200) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;

        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        _collectionView.delaysContentTouches = NO;
    }
    return _collectionView;
}


@end
