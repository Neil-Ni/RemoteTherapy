//
//  ViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 6/26/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SQL.h"
#import "MainAppViewController.h"
#import "SignUpViewController.h"


@interface ViewController () <UITextFieldDelegate>

- (void) setUpInitial;
- (void) keyboardAppeared;

@end

@implementation ViewController
@synthesize Forgotpassword;
@synthesize loginbutton, UserName, Password;

bool isKeyboardVisible = FALSE;
static int i = 0;

- (void) Login:(id)sender{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.Username = UserName.text;
//    NSLog(@"username %@", appDelegate.Username);
}

- (void) keyboardAppeared{
    if (isKeyboardVisible == FALSE) {
        isKeyboardVisible = true;
        
        UIBarButtonItem *btnGo = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStyleBordered target:self action:@selector(loginAction)];
        self.navigationItem.rightBarButtonItem = btnGo;
    }
}

- (void)setUpInitial{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppeared) name:UIKeyboardDidShowNotification object:nil];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UserName.frame = CGRectMake(277, 327, 214, 62);
        Password.frame = CGRectMake(277, 442, 214, 62);
    }

    UserName.returnKeyType = UIReturnKeyDefault;
    UserName.delegate = self;
    Password.returnKeyType = UIReturnKeyDefault;
    Password.secureTextEntry = YES;
    Password.delegate = self;
    
    
    loginbutton.enabled = NO;
    loginbutton.alpha = 0.7;
}
- (void)viewWillAppear:(BOOL)animated{
//    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    /*if(![appDelegate.Username isEqualToString:@""]){
        NSLog(@"user: %@", appDelegate.Username);
        loginbutton.enabled = YES;
        loginbutton.alpha = 1.0;
    };*/
    
    
    loginbutton.enabled = NO;
    loginbutton.alpha = 0.7;
    loginbutton.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpInitial];
    self.navigationController.navigationBar.hidden = YES;

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setPassword:nil];
    [self setLoginbutton:nil];
    [self setForgotpassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (![UserName.text isEqualToString:@""] && ![Password.text isEqualToString:@""]) {
        BOOL canlogin = [SQL LoginWithUserName:UserName.text andPassword:Password.text];
        if(canlogin){
            loginbutton.enabled = YES;
            loginbutton.alpha = 1.0;
            AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            appDelegate.Username = UserName.text;

        }else {
            NSLog(@"cannotlogin");
            i += 1;
            loginbutton.enabled = NO;
            loginbutton.alpha = 0.7;
            if(i>5){
                Forgotpassword.hidden = NO;
            }
        }
    }

    return YES;
}
@end
