//
//  ExampleViewController.h
//  CACollectionView
//
//  Created by chenao on 17/5/2.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CollectionViewType) {
    CollectionViewScaleType,
    CollectionViewSpringType
};

@interface ExampleViewController : UIViewController
@property (nonatomic, assign) CollectionViewType type;

@end
