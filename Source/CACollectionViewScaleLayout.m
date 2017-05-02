//
//  CACollectionViewScaleLayout.m
//  CACollectionView
//
//  Created by chenao on 17/4/26.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import "CACollectionViewScaleLayout.h"
#import "CASpringEngine.h"
@interface CACollectionViewScaleLayout ()
@property (nonatomic, assign) CGFloat oneDelta;
@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGSize smallSize;
@property (nonatomic, assign) CGSize normalSize;
@end

@implementation CACollectionViewScaleLayout

- (instancetype)init {
    if (self = [super init]) {
        self.oneDelta = 0;
        self.scaleRatio = 0.2;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.spring = NO;
    }
    return self;
}

- (CASpringEngine *)springEngine {
    if (_springEngine == nil) {
        _springEngine = [CASpringEngine springEngineFor:self];
    }
    return _springEngine;
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (self.spring) {
        [self.springEngine updateBehaviorsForBoundsChange:newBounds];
    }
    return YES;
}


- (void)prepareLayout
{
    [super prepareLayout];
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        // 水平滚动
        // 设置内边距
        CGFloat inset = (CGRectGetWidth(self.collectionView.frame) - self.itemSize.width) * 0.5;
        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    }else {
        //垂直滚动
        CGFloat inset = (CGRectGetHeight(self.collectionView.frame) - self.itemSize.height) * 0.5;
        self.sectionInset = UIEdgeInsetsMake(inset, 0, inset, 0);

    }
    if (self.spring) {
        NSArray <UICollectionViewLayoutAttributes *>*attributes = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:self.collectionView.bounds] copyItems:YES];
        [self.springEngine removeOldBehaviorsForAttributes:attributes];
        [self.springEngine addNewBehaviorsForAttributes:attributes];
    }
    
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
        // 获得super已经计算好的布局属性
    NSArray *array;
    if (self.spring) {
        
        array = [self.springEngine.animator itemsInRect:rect];
    }else {
    
        array = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    }
    
    CGFloat oneDelta = CGFLOAT_MAX;
    CGFloat minScale = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + CGRectGetWidth(self.collectionView.frame) * 0.5;
    
        // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
            // cell的中心点x 和 collectionView最中心点的x值 的间距
        if (CGSizeEqualToSize(CGSizeZero, self.normalSize)) {
            self.normalSize = attrs.frame.size;
        }
        CGFloat delta = ABS(attrs.center.x - centerX);
        
            // 根据间距值 计算 cell的缩放比例
        CGFloat scale = 1 - self.scaleRatio * delta /  CGRectGetWidth(self.collectionView.frame);
        if (delta > 0) {
            oneDelta = MIN(delta, oneDelta);
            minScale = 1 - self.scaleRatio * oneDelta / CGRectGetWidth(self.collectionView.frame);
        }
            // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    } else {
    
            // 计算collectionView最中心点的y值
        CGFloat centerY = self.collectionView.contentOffset.y + CGRectGetHeight(self.collectionView.frame) * 0.5;
        
        for (UICollectionViewLayoutAttributes *attrs in array) {
                // cell的中心点y 和 collectionView最中心点的y值 的间距
            if (CGSizeEqualToSize(CGSizeZero, self.normalSize)) {
                self.normalSize = attrs.frame.size;
            }
            CGFloat delta = ABS(attrs.center.y - centerY);
            
                // 根据间距值 计算 cell的缩放比例
            CGFloat scale = 1 - self.scaleRatio * delta / CGRectGetHeight(self.collectionView.frame);
            if (delta > 0) {
                oneDelta = MIN(delta, oneDelta);
                minScale = 1 - self.scaleRatio * oneDelta / CGRectGetHeight(self.collectionView.frame);
            }
                // 设置缩放比例
            attrs.transform = CGAffineTransformMakeScale(scale, scale);
        }

    }
    
    if (self.oneDelta == 0) {
        self.oneDelta = oneDelta;
        self.minScale = minScale;
    }

    return array;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attributes;
    if (self.spring) {
        attributes = [self.springEngine.animator layoutAttributesForCellAtIndexPath:indexPath];
        if (!attributes) {
            attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
        }
    }else {
        attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat centerX = self.collectionView.contentOffset.x + CGRectGetWidth(self.collectionView.frame) * 0.5;
        CGFloat delta = ABS(attributes.center.x - centerX);
        
        CGFloat scale = 1 - self.scaleRatio * delta / CGRectGetWidth(self.collectionView.frame);
        
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }else {
    
        CGFloat centerY = self.collectionView.contentOffset.y + CGRectGetHeight(self.collectionView.frame) * 0.5;
        CGFloat delta = ABS(attributes.center.y - centerY);
        
        CGFloat scale = 1 - self.scaleRatio * delta / CGRectGetHeight(self.collectionView.frame);
        
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attributes;
}

- (CGSize)smallSize {
    return CGSizeMake(self.minScale * self.normalSize.width, self.minScale * self.normalSize.height);
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
        // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
        // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + CGRectGetWidth(self.collectionView.frame) * 0.5;
    
        // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
        
    }else {
        CGRect rect;
        rect.origin.y = proposedContentOffset.y;
        rect.origin.x = 0;
        rect.size = self.collectionView.frame.size;
        
        NSArray *array = [super layoutAttributesForElementsInRect:rect];
        
            // 计算collectionView最中心点的Y值
        CGFloat centerY = proposedContentOffset.y + CGRectGetHeight(self.collectionView.frame) * 0.5;
        
            // 存放最小的间距值
        CGFloat minDelta = MAXFLOAT;
        for (UICollectionViewLayoutAttributes *attrs in array) {
            if (ABS(minDelta) > ABS(attrs.center.y - centerY)) {
                minDelta = attrs.center.y - centerY;
            }
        }
        // 修改原有的偏移量
        proposedContentOffset.y += minDelta;

    }
    return proposedContentOffset;
}

@end
