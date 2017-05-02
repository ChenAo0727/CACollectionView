//
//  CACollectionViewSpringLayout.m
//  CACollectionView
//
//  Created by chenao on 17/5/2.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import "CACollectionViewSpringLayout.h"
#import "CASpringEngine.h"

@interface CACollectionViewSpringLayout ()
@property (nonatomic, strong) CASpringEngine *springEngine;
@end

@implementation CACollectionViewSpringLayout

- (instancetype)init {
    if (self = [super init]) {
        self.damping = 0.6;
        self.frequency = 2;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    NSArray <UICollectionViewLayoutAttributes *>*attributes = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:self.collectionView.bounds] copyItems:YES];
    [self.springEngine removeOldBehaviorsForAttributes:attributes];
    [self.springEngine addNewBehaviorsForAttributes:attributes];
    
}

- (CASpringEngine *)springEngine {
    if (_springEngine == nil) {
        _springEngine = [CASpringEngine springEngineFor:self];
    }
    return _springEngine;
}

- (void)setDamping:(CGFloat)damping {
    _damping = damping;
    self.springEngine.damping = damping;
}

- (void)setFrequency:(CGFloat)frequency {
    _frequency = frequency;
    self.springEngine.frequency = frequency;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
     NSArray *attrs = [self.springEngine.animator itemsInRect:rect];
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [self.springEngine.animator layoutAttributesForCellAtIndexPath:indexPath];
    return attr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    [self.springEngine updateBehaviorsForBoundsChange:newBounds];
    return NO;
}

@end
