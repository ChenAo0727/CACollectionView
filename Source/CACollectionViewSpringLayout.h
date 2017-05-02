//
//  CACollectionViewSpringLayout.h
//  CACollectionView
//
//  Created by chenao on 17/5/2.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CACollectionViewSpringLayout : UICollectionViewFlowLayout
//Default is 0.6
@property (nonatomic, assign) CGFloat damping;
//Default is 2
@property (nonatomic, assign) CGFloat frequency;
@end
