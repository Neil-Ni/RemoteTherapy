//
//  OfflineImageViewController.h
//  SQL
//
//  Created by Tzu-Yang Ni on 8/24/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>


@class OfflineImageViewController; 

@protocol OfflineImageViewControllerControllerdelegate <NSObject>
- (void)addItem:(OfflineImageViewController *)controller didFinishEnteringItem:(NSString *)item;
- (void)nextsession:(OfflineImageViewController *)controller;
- (void)score: (OfflineImageViewController *)controller;

@end

@interface OfflineImageViewController : UIViewController
@property (nonatomic, weak) id <OfflineImageViewControllerControllerdelegate> delegate;
@property (nonatomic,strong) NSString *CorrectAnswer;
@property (nonatomic,strong) NSString *Category;
@property (nonatomic,strong) NSMutableArray *infos;
@property BOOL isDemoMode;

@end
