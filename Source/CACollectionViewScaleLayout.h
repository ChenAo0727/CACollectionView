//
//  CACollectionViewScaleLayout.h
//  CACollectionView
//
//  Created by chenao on 17/4/26.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CACollectionViewScaleLayout : UICollectionViewFlowLayout
/**
 Default is 0.2 (scale = 1 - scaleRatio * delta / collectionView.width) 
 delta is the centerX offset
 */
@property (nonatomic, assign) CGFloat scaleRatio;
/**
 The neighbor scaled size
 */
@property (nonatomic, assign, readonly) CGSize smallSize;
/**
 The normal size equal to layout.itemSize
 */
@property (nonatomic, assign, readonly) CGSize normalSize;

@end
