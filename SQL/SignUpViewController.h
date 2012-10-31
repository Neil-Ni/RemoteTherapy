//
//  SignUpViewController.h
//  SQL
//
//  Created by Tzu-Yang Ni on 6/27/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SignUpViewController; 

@protocol SignUpViewControllerControllerdelegate <NSObject>
- (void)setSettingWith:(SignUpViewController *)controller OrderMode:(BOOL) ordermode andShuffleMode:(BOOL)shufflemode andInteractionMode:(BOOL) interactionmode;
@end


@interface SignUpViewController : UITableViewController <UITextFieldDelegate>{
    NSMutableArray *textfields;
    UITextField *userNameTextField;
    UITextField *passwordTextField;
    UITextField *hasReceiverTextField;
    UITextField *hasSenderTextField;
    BOOL sender;
}
@property BOOL Profile;
@property BOOL ordermode;
@property BOOL shufflemode;
@property BOOL interactionmode;

@property (nonatomic, weak) id <SignUpViewControllerControllerdelegate> delegate;

@end
