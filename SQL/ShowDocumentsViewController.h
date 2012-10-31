//
//  ShowDocumentsViewController.h
//  SQL
//
//  Created by Tzu-Yang Ni on 7/29/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ShowDocumentsViewController;

@protocol ShowDocumentsViewControllerdelegate <NSObject>

- (void)addItemViewController:(ShowDocumentsViewController *)controller didFinishEnteringItem:(NSMutableArray *)item;

@end

@interface ShowDocumentsViewController : UITableViewController

@property (nonatomic, weak) id <ShowDocumentsViewControllerdelegate> delegate;

@end
