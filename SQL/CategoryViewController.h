//
//  CategoryViewController.h
//  SQL
//
//  Created by Tzu-Yang Ni on 7/29/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryViewController;

@protocol CategoryViewControllerdelegate <NSObject>

- (void)addItemViewController:(CategoryViewController *)controller didFinishEnteringItem:(NSMutableDictionary *)item;

@end

@interface CategoryViewController : UITableViewController

@property (nonatomic, weak) id <CategoryViewControllerdelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *aCategoryName;
@end
