//
//  OfflineShowDocumentsViewControllerViewController.h
//  SQL
//
//  Created by Tzu-Yang Ni on 8/24/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OfflineShowDocumentsViewControllerViewController;

@protocol OfflineShowDocumentsViewControllerdelegate <NSObject>

- (void)addItemViewController:(OfflineShowDocumentsViewControllerViewController *)controller didFinishEnteringItem:(NSMutableArray *)item;

@end

@interface OfflineShowDocumentsViewControllerViewController : UITableViewController
@property (nonatomic, weak) id <OfflineShowDocumentsViewControllerdelegate> delegate;
@property BOOL isDemoMode;

@end
