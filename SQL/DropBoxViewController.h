//
//  DropBoxViewController.h
//  SQL
//
//  Created by Tzu-Yang Ni on 7/30/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropBoxViewController; 

@protocol DropBoxViewControllerControllerdelegate <NSObject>
- (void)addItemViewController:(DropBoxViewController *)controller didFinishEnteringItem:(NSString *)item;
@end


@interface DropBoxViewController : UITableViewController

@property (nonatomic, weak) id <DropBoxViewControllerControllerdelegate> delegate;
@property (nonatomic, strong) NSMutableArray *folders;
@property BOOL ChildView;
@property BOOL Receiver;

@end
