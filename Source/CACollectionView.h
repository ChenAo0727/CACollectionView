//
//  CACollectionView.h
//  CACollectionView
//
//  Created by chenao on 17/4/26.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CACollectionView : UICollectionView
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger multiple;
@property (nonatomic, assign) NSInteger dataCount;
@end
