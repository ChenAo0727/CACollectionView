//
//  CACollectionView.m
//  CACollectionView
//
//  Created by chenao on 17/4/26.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import "CACollectionView.h"
#import "CACollectionViewScaleLayout.h"
@implementation CACollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _multiple = 1;
        _dataCount = 10;
    }
    return self;
}

- (NSInteger)currentIndex {
    NSInteger index = self.contentOffset.x / self.frame.size.width + 1;
    return index;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {

    if([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        NSInteger items = [self.dataSource collectionView:self numberOfItemsInSection:0];
        if (currentIndex >= items) {
            return;
        }
        if (currentIndex < 0) {
            currentIndex = 0;
        }
    }
    CACollectionViewScaleLayout *layout = (CACollectionViewScaleLayout *)self.collectionViewLayout;
    if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else {
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

@end
