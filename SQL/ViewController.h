//
//  ViewController.h
//  SQL
//
//  Created by Tzu-Yang Ni on 6/26/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *UserName;
@property (strong, nonatomic) IBOutlet UITextField *Password;
- (IBAction)Login:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginbutton;
@property (strong, nonatomic) IBOutlet UILabel *Forgotpassword;

@end
