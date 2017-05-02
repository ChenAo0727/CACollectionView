//
//  CASpringEngine.m
//  CACollectionView
//
//  Created by chenao on 17/5/2.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import "CASpringEngine.h"
static CASpringEngine *_shareInstance;
@interface CASpringEngine ()<UIDynamicAnimatorDelegate>
@property (nonatomic, weak) UICollectionViewFlowLayout *layout;
@end

@implementation CASpringEngine
+ (instancetype)shareSpringEngine {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[CASpringEngine alloc]init];
    });
    return _shareInstance;
}

+ (instancetype)springEngineFor:(UICollectionViewFlowLayout *)layout {
    CASpringEngine *springEngine = [CASpringEngine shareSpringEngine];
    springEngine.animator = [[UIDynamicAnimator alloc]initWithCollectionViewLayout:layout];
    springEngine.layout = layout;
    springEngine.damping = 0.6;
    springEngine.frequency = 2;
    springEngine.animator.delegate = springEngine;
    return springEngine;
}

- (void)removeOldBehaviorsForAttributes:(NSArray <UICollectionViewLayoutAttributes *>*)attributes {
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        [indexPathArray addObject:attr.indexPath];
    }
    
    for (UIAttachmentBehavior *behavior in self.animator.behaviors) {
        id item = behavior.items.firstObject;
        if ([item isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
            UICollectionViewLayoutAttributes *attribute = (UICollectionViewLayoutAttributes *)item;
            if (![indexPathArray containsObject:attribute.indexPath]) {
                [self.animator removeBehavior:behavior];
            }
        }
    }
}

- (void)addNewBehaviorsForAttributes:(NSArray <UICollectionViewLayoutAttributes *>*)attributes {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UIAttachmentBehavior *behavior in self.animator.behaviors) {
        id item = behavior.items.firstObject;
        if ([item isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
            UICollectionViewLayoutAttributes *attribute = (UICollectionViewLayoutAttributes *)item;
            [indexPaths addObject:attribute.indexPath];
        }
    }
    NSMutableArray *attrs = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        if (![indexPaths containsObject:attr.indexPath]) {
            [attrs addObject:attr];
        }
    }
    
    for (UICollectionViewLayoutAttributes *addAttr in attrs) {
        UIAttachmentBehavior *attachBehavior = [[UIAttachmentBehavior alloc]initWithItem:addAttr attachedToAnchor:addAttr.center];
        attachBehavior.damping = self.damping;
        attachBehavior.frequency = self.frequency;
        [self.animator addBehavior:attachBehavior];
    }
    
}

- (void)updateBehaviorsForBoundsChange:(CGRect)newBounds {
    for (UIAttachmentBehavior *behavior in self.animator.behaviors) {
        id<UIDynamicItem> item = behavior.items.firstObject;
        [self updateBehavior:behavior item:item forBound:newBounds];
        [self.animator updateItemUsingCurrentState:item];
    }

}

- (void)updateBehavior:(UIAttachmentBehavior *)behavior item:(id <UIDynamicItem>)item forBound:(CGRect)bounds {
    CGVector delta = CGVectorMake(CGRectGetMinX(bounds) - CGRectGetMinX(self.layout.collectionView.bounds), (CGRectGetMinY(bounds) - CGRectGetMinY(self.layout.collectionView.bounds)));
    
    CGVector resistance = CGVectorMake(fabs([self.layout.collectionView.panGestureRecognizer locationInView:self.layout.collectionView].x - behavior.anchorPoint.x) / 1000, fabs([self.layout.collectionView.panGestureRecognizer locationInView:self.layout.collectionView].y - behavior.anchorPoint.y) / 1000);
    
    CGPoint center = item.center;
    
    CGFloat deltaY = delta.dy < 0 ? MAX(delta.dy, delta.dy * resistance.dy) : MIN(delta.dy, delta.dy * resistance.dy);
    
    CGFloat deltaX = delta.dx < 0 ? MAX(delta.dx, delta.dx * resistance.dx) : MIN(delta.dx, delta.dx * resistance.dx);
    item.center = CGPointMake(center.x + deltaX, center.y + deltaY );
}

#pragma mark - UIDynamicAnimatorDelegate


- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    if (self.animatorDidPause) {
        self.animatorDidPause();
    }
}

@end
