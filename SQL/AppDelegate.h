//
//  AppDelegate.h
//  SQL
//
//  Created by Tzu-Yang Ni on 6/26/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, DBSessionDelegate, DBNetworkRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *Username;

@end
