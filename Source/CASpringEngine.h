//
//  CASpringEngine.h
//  CACollectionView
//
//  Created by chenao on 17/5/2.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CASpringEngine : NSObject
//Default is 0.6
@property (nonatomic, assign) CGFloat damping;
//Default is 2
@property (nonatomic, assign) CGFloat frequency;

@property (nonatomic, weak) UIDynamicAnimator *animator;

@property (nonatomic, copy) void (^animatorDidPause)();

+ (instancetype)springEngineFor:(UICollectionViewFlowLayout *)layout;

- (void)removeOldBehaviorsForAttributes:(NSArray <UICollectionViewLayoutAttributes *>*)attributes;
- (void)addNewBehaviorsForAttributes:(NSArray <UICollectionViewLayoutAttributes *>*)attributes;
- (void)updateBehaviorsForBoundsChange:(CGRect)newBounds;
+ (instancetype)shareSpringEngine;
@end
