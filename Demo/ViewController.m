//
//  ViewController.m
//  CACollectionView
//
//  Created by chenao on 17/4/26.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import "ViewController.h"
#import "CACollectionViewScaleLayout.h"
#import "CACollectionView.h"
#import "CACollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) CACollectionView *hCollectionView;
@property (nonatomic, strong) CACollectionView *vCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.hCollectionView];
    [self.view addSubview:self.vCollectionView];
}

#pragma mark - getter
- (CACollectionView *)hCollectionView {
    if (_hCollectionView == nil) {
        CACollectionViewScaleLayout *layout = [[CACollectionViewScaleLayout alloc]init];
            //    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        layout.itemSize = CGSizeMake(width - 160, 160);
        layout.scaleRatio = 0.6;
        CACollectionView *collectionView = [[CACollectionView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CACollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CACollectionViewCell class])];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.dataCount = 3;
        collectionView.multiple = 1000;
        collectionView.currentIndex = 1500;
        _hCollectionView = collectionView;
    }
    return _hCollectionView;
}

- (CACollectionView *)vCollectionView {
    if (_vCollectionView == nil) {
        CACollectionViewScaleLayout *layout = [[CACollectionViewScaleLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        layout.itemSize = CGSizeMake(width - 180, 120);
        layout.scaleRatio = 0.3;
        CACollectionView *collectionView = [[CACollectionView alloc]initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 200) collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CACollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CACollectionViewCell class])];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.dataCount = 6;
        collectionView.multiple = 100;
        collectionView.currentIndex = 0;
        _vCollectionView = collectionView;
  
    }
    return _vCollectionView;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(CACollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView.dataCount * collectionView.multiple;
}

- (UICollectionViewCell *)collectionView:(CACollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CACollectionViewCell class]) forIndexPath:indexPath];
    cell.cellLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row % collectionView.dataCount];
    
    return cell;
}

//滚动停止后调整回中间部分
- (void)scrollViewDidEndDecelerating:(CACollectionView *)scrollView {
    NSArray *cells = [scrollView visibleCells];
    for (CACollectionViewCell *cell in cells) {
        CACollectionViewScaleLayout *layout = (CACollectionViewScaleLayout *)scrollView.collectionViewLayout;
        if (CGSizeEqualToSize(cell.frame.size, layout.normalSize)) {
            NSIndexPath *indexPath = [scrollView indexPathForCell:cell];
            NSInteger index = indexPath.row % scrollView.dataCount;
            scrollView.currentIndex = scrollView.dataCount * scrollView.multiple / 2 + index;
            
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click index:%zd", indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
