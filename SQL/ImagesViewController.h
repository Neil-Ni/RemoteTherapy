//
//  ImagesViewController.h
//  SQL
//
//  Created by Tzu-Yang Ni on 7/31/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropBoxViewController.h"


@class ImagesViewController; 

@protocol ImagesViewControllerControllerdelegate <NSObject>
- (void)addItem:(ImagesViewController *)controller didFinishEnteringItem:(NSString *)item;
- (void)nextsession:(ImagesViewController *)controller;

@end


@interface ImagesViewController : UIViewController <DropBoxViewControllerControllerdelegate>
@property (nonatomic, weak) id <ImagesViewControllerControllerdelegate> delegate;
@property (nonatomic,strong) NSString *folder;
@property BOOL ordermode;
@property BOOL shufflemode;
@property BOOL interactionmode;

@end
