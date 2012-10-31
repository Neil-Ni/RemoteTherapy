//
//  SQL.h
//  SQL
//
//  Created by Tzu-Yang Ni on 6/27/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQL : NSObject
+ (NSString *)deletelog:(NSString *)Username;
+ (NSArray *) returnlog: (NSString *)Username; 
+ (NSString *)appendlog:(NSString *)Username andResponse: (int)response andFolder:(NSString *)folder;

+ (NSMutableArray *)returnURL: (NSString *)Username andNumber:(NSString *)number;
+ (NSString *)returnReceiver: (NSString *)Username;
+ (NSString *)returnSender: (NSString *)Username; 
+ (BOOL) hasReceiver: (NSString *)Username;
+ (BOOL) hasSender: (NSString *)Username;
+ (BOOL) LoginWithUserName:(NSString *)Username andPassword:(NSString *)Password;
+ (BOOL) UpdateImageUserName:(NSString *)Username andnumber:(NSString *)number andURL:(NSString *)url;
+ (NSString *) SignUpWithUserName:(NSString *)Username andPassword:(NSString *)Password hasReceiver:(NSString *)hasReceiver hasSender:(NSString *)hasSender;
+ (NSString *) UploadImageWithData:(NSData *)data andfileName:(NSString *)fileName; 
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
