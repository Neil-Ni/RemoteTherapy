//
//  SignUpViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 6/27/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "SignUpViewController.h"
#import "SQL.h"
#import "AppDelegate.h"
#import "MainAppViewController.h"

@interface SignUpViewController (){
    NSString *username; 
    NSArray *settingarray;
}

-(void)setupinitialsetting;

@end

@implementation SignUpViewController
@synthesize Profile,delegate,ordermode,shufflemode,interactionmode;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupinitialsetting{
    if(!ordermode && !shufflemode && !interactionmode){
       ordermode = FALSE;
       shufflemode = FALSE;
       interactionmode = TRUE;
    }
    settingarray = [[NSArray alloc] initWithObjects:@"Show Images by Order",@"Shuffle Mode",@"Interaction Mode",nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(Profile){
        [self setupinitialsetting];
        sender = TRUE;
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        username = appDelegate.Username;
        self.navigationItem.title= @"User's Profile";
        textfields = [[NSMutableArray alloc] initWithObjects:@"Username",@"Sender", nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppeared) name:UIKeyboardDidShowNotification object:nil];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            UIBarButtonItem *btnGo = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleBordered target:self action:@selector(SignUpAction)];
            self.navigationItem.rightBarButtonItem = btnGo;
            UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
            self.navigationItem.leftBarButtonItem = Back;
        };
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
            self.navigationItem.leftBarButtonItem = Back;

            UIBarButtonItem *btnGo = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleBordered target:self action:@selector(SignUpAction)];
            self.navigationItem.rightBarButtonItem = btnGo;
        };

    }else {
        sender = TRUE;
        self.navigationItem.title= @"Sign Up";
        textfields = [[NSMutableArray alloc] initWithObjects:@"Username",@"Password",@"Sender", nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppeared) name:UIKeyboardDidShowNotification object:nil];
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
     
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            UIBarButtonItem *btnGo = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(SignUpAction)];
            self.navigationItem.rightBarButtonItem = btnGo;
            UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
            self.navigationItem.leftBarButtonItem = Back;
        };
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
            self.navigationItem.leftBarButtonItem = Back;
            
            UIBarButtonItem *btnGo = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(SignUpAction)];
            self.navigationItem.rightBarButtonItem = btnGo;
        };
    }
}

- (void) keyboardAppeared{
    if(Profile){
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            UIBarButtonItem *btnGo = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleBordered target:self action:@selector(SignUpAction)];
            self.navigationItem.rightBarButtonItem = btnGo;
            UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
            self.navigationItem.leftBarButtonItem = Back;
        };
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
            self.navigationItem.leftBarButtonItem = Back;
            
            UIBarButtonItem *btnGo = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleBordered target:self action:@selector(SignUpAction)];
            self.navigationItem.rightBarButtonItem = btnGo;
        };

    }else {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            UIBarButtonItem *btnGo = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(SignUpAction)];
            self.navigationItem.rightBarButtonItem = btnGo;
            UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
            self.navigationItem.leftBarButtonItem = Back;
        };
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
            self.navigationItem.leftBarButtonItem = Back;
            
            UIBarButtonItem *btnGo = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(SignUpAction)];
            self.navigationItem.rightBarButtonItem = btnGo;
        };
    }
}

- (void)goBack{
    [self.delegate setSettingWith:self OrderMode:ordermode andShuffleMode:shufflemode andInteractionMode:interactionmode];
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)SignUpAction{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"This function is not completely implemented yet."
                                                       delegate:self 
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show]; 
    if(Profile){
        NSLog(@"Confirm and update user's information");
    }else {
        
    /*
        NSLog(@"%@",userNameTextField.text);
        
        NSLog(@"%@",passwordTextField.text);
        NSLog(@"%@",hasReceiverTextField.text);
        NSLog(@"%@",hasSenderTextField.text);
        BOOL Pass = TRUE;
        if (![userNameTextField.text isEqualToString:@""] && ![passwordTextField.text isEqualToString:@""]) {
            if([hasReceiverTextField.text isEqualToString:@""] && [hasSenderTextField.text isEqualToString:@""]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"eh"
                                                                    message:@"sender or receiver?"
                                                                   delegate:self 
                                                          cancelButtonTitle:@"cancel"
                                                          otherButtonTitles:@"Ok", nil];
                [alertView show]; 
                Pass = FALSE;
            }
            
            if(![hasReceiverTextField.text isEqualToString:@""] && ![hasSenderTextField.text isEqualToString:@""]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"eh"
                                                                    message:@"sender or receiver?"
                                                                   delegate:self 
                                                          cancelButtonTitle:@"cancel"
                                                          otherButtonTitles:@"Ok", nil];
                [alertView show]; 
                Pass = FALSE;
            }
        }
        if(Pass){
            NSString *result = [SQL SignUpWithUserName:userNameTextField.text andPassword:passwordTextField.text hasReceiver:hasReceiverTextField.text hasSender:hasSenderTextField.text];
            NSLog(@"%@",result);
            if([result isEqualToString:@"sucess"]){
                AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                appDelegate.Username = userNameTextField.text;
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:result
                                                                   delegate:self 
                                                          cancelButtonTitle:@"cancel"
                                                          otherButtonTitles:@"Ok", nil];
                [alertView show]; 
            }
        }*/
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    textfields = nil;
    userNameTextField = nil; 
    passwordTextField = nil; 
    hasSenderTextField = nil;
    hasReceiverTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return Profile? 3: 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [textfields count];
        case 1:
            return 1;
        case 2:
            return [settingarray count];
    }
    return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(Profile){
        switch (section) {
            case 0:
                return @"Basic Information";
                break;
            case 1:
                return sender? @"Switch Your Receiver": @"Switch Your Sender";
                break;
            case 2:
                return @"Advanded Setting";
                break;
            default:
                return nil;
        }
    }else {
        switch (section) {
            case 0:
                return @"Basic Information";
                break;
            case 1:
                return sender? @"Enter Your Receiver's Username": @"Enter Your Sender's Username";
                break;
            default:
                return nil;
        }
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return @"p.s This field of your partner's should match your username";
            break;
        case 2:
            return @"Only one mode can be activated, the default mode is interaction mode.";
            break;
        default:
            return nil;
    }
}

- (void) switchChanged:(id)send {
    
    UISwitch* switchControl = send;
    NSLog(@"%d", switchControl.tag);
    switch (switchControl.tag) {
        case 10:
            if(switchControl.on){
                sender = TRUE;
            }else {
                sender = FALSE;
            }
            break;
        case 0:
            if(switchControl.on){
                ordermode = TRUE;
                shufflemode = FALSE;
                interactionmode = FALSE; 
            }else {
                ordermode = FALSE;
            }
            break;
        case 1:
            if(switchControl.on){
                shufflemode = TRUE;
                ordermode = FALSE;
                interactionmode = FALSE;
            }else {
                shufflemode = FALSE;
            }
            break;
        case 2:
            if(switchControl.on){
                ordermode = FALSE;
                shufflemode = FALSE;
                interactionmode = TRUE; 
            }else {
                interactionmode = FALSE;
            }
            break;
        default:
            break;
    }
//    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
        for (UISwitch *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }

    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    CGRect frame;
    frame.origin.x = 10;
    frame.origin.y = 10;
    frame.size.height = 30;
    frame.size.width = 200;
    
    if(Profile){
        if (indexPath.section == 0){ 
            UILabel *label = [[UILabel alloc] initWithFrame: frame];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize:16.0];
            label.text = [textfields objectAtIndex:indexPath.row];
            [cell.contentView addSubview:label];
            
            frame.origin.x = 110;
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                frame.size.width = 100;
                frame.size.height = 30;
            }else {
                frame.size.width = 200;
                frame.size.height = 30;

            }

            if (indexPath.row == 0) {
                
                UILabel *label2 = [[UILabel alloc] initWithFrame: frame];
                label2.textAlignment = UITextAlignmentCenter;
                label2.backgroundColor = [UIColor clearColor];
                label2.text = username;
                [cell.contentView addSubview:label2];
            }
            if (indexPath.row == 1){
                frame.origin.x = 180;
                frame.size.height = 90;
                frame.size.width = 180;
                
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:frame];
                switchView.tag = 10;
                sender? [switchView setOn:YES animated:NO]:[switchView setOn:NO animated:NO];
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:switchView];
                
            }
        }
        if(indexPath.section == 1){
            if(sender){
                if (indexPath.row == 0) {//user name part
                    UILabel *label = [[UILabel alloc] initWithFrame: frame];
                    label.backgroundColor = [UIColor clearColor];
                    label.font = [UIFont boldSystemFontOfSize:16.0];
                    label.text = @"Receiver's Username";
                    [cell.contentView addSubview:label];
                    
                    frame.origin.x = 180;
                    frame.size.height = 90;
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                        frame.size.width = 120;
                        frame.size.height = 30;
                    }else {
                        frame.size.width = 250;
                        frame.size.height = 30;
                    }
                    
                    hasReceiverTextField = [[UITextField alloc] initWithFrame:frame];
                    hasReceiverTextField.textAlignment = UITextAlignmentCenter;
                    hasReceiverTextField.placeholder = @"Enter Here...";                 

                    hasReceiverTextField.text = @"";
                    hasReceiverTextField.returnKeyType = UIReturnKeyDefault;
                    hasReceiverTextField.delegate = self;
                    [cell.contentView addSubview:hasReceiverTextField];
                    
                }     
            }else {
                if (indexPath.row == 0) {//user name part
                    UILabel *label = [[UILabel alloc] initWithFrame: frame];
                    label.backgroundColor = [UIColor clearColor];
                    label.font = [UIFont boldSystemFontOfSize:16.0];
                    label.text = @"Sender's Username";
                    [cell.contentView addSubview:label];
                    
                    frame.origin.x = 180;
                    frame.size.height = 90;
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                        frame.size.width = 120;
                        frame.size.height = 30;

                    }else {
                        frame.size.height = 30;
                        frame.size.width = 250;
                        
                    }
                    hasSenderTextField = [[UITextField alloc] initWithFrame:frame];
                    hasSenderTextField.textAlignment = UITextAlignmentCenter;
                    hasSenderTextField.placeholder = @"Enter Here...";                 

                    hasSenderTextField.text = @"";
                    hasSenderTextField.returnKeyType = UIReturnKeyDefault;
                    hasSenderTextField.delegate = self;
                    [cell.contentView addSubview:hasSenderTextField];
                } 
            }
        }
        if(indexPath.section == 2){
            
            UILabel *label = [[UILabel alloc] initWithFrame: frame];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize:16.0];
            label.text = [settingarray objectAtIndex:indexPath.row];
            [cell.contentView addSubview:label];
            
            frame.origin.x = 220;
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                frame.size.width = 120;
                frame.size.height = 30;
            }else {
                frame.size.width = 250;
                frame.size.height = 30;
                
            }
//            frame.size.height = 90;
//            frame.size.width = 180;
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:frame];
            switchView.tag = indexPath.row;
            if(indexPath.row == 0){
                ordermode? [switchView setOn:YES animated:NO]:[switchView setOn:NO animated:YES];
            }
            if(indexPath.row == 1){
                shufflemode? [switchView setOn:YES animated:NO]:[switchView setOn:NO animated:YES];
            }
            if(indexPath.row == 2){
                interactionmode? [switchView setOn:YES animated:NO]:[switchView setOn:NO animated:YES];
            }
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:switchView];

        }
    }else {
        // textfield part, 
        if (indexPath.section == 0){ 
            UILabel *label = [[UILabel alloc] initWithFrame: frame];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize:16.0];
            label.text = [textfields objectAtIndex:indexPath.row];
            [cell.contentView addSubview:label];
            
            frame.origin.x = 110;
            frame.size.height = 90;
            frame.size.width = 200;
            
            if (indexPath.row == 0) {//user name part
                userNameTextField = [[UITextField alloc ] initWithFrame: frame];
                userNameTextField.textAlignment = UITextAlignmentCenter;
                userNameTextField.placeholder = @"Enter Username Here...";
                userNameTextField.text = @"";
                userNameTextField.returnKeyType  = UIReturnKeyDefault;
                userNameTextField.delegate = self;
                [cell.contentView addSubview:userNameTextField];
            }
            if (indexPath.row == 1){
                //password part
                passwordTextField = [[UITextField alloc] initWithFrame:frame];
                passwordTextField.textAlignment = UITextAlignmentCenter;
                passwordTextField.placeholder = @"Enter Password Here..."; 
                passwordTextField.text = @"";
                passwordTextField.returnKeyType = UIReturnKeyDefault;
                passwordTextField.secureTextEntry = YES;
                passwordTextField.delegate = self;
                [cell.contentView addSubview:passwordTextField];
            }
            if (indexPath.row == 2){
                
                frame.origin.x = 180;
                frame.size.height = 90;
                frame.size.width = 180;
                
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:frame];
                sender? [switchView setOn:YES animated:NO]:[switchView setOn:NO animated:NO];
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:switchView];
                
            }
        }else {
            if(sender){
                if (indexPath.row == 0) {//user name part
                    UILabel *label = [[UILabel alloc] initWithFrame: frame];
                    label.backgroundColor = [UIColor clearColor];
                    label.font = [UIFont boldSystemFontOfSize:16.0];
                    label.text = @"Receiver's Username";
                    [cell.contentView addSubview:label];
                    
                    frame.origin.x = 180;
                    frame.size.height = 90;
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                        frame.size.width = 120;
                    }else {
                        frame.size.width = 250;
                    }
                    hasReceiverTextField = [[UITextField alloc] initWithFrame:frame];
                    hasReceiverTextField.textAlignment = UITextAlignmentCenter;
                    hasReceiverTextField.placeholder = @"Enter Here...";                 
                    hasReceiverTextField.text = @"";
                    hasReceiverTextField.returnKeyType = UIReturnKeyDefault;
                    hasReceiverTextField.delegate = self;
                    [cell.contentView addSubview:hasReceiverTextField];
                    
                }     
            }else {
                if (indexPath.row == 0) {//user name part
                    UILabel *label = [[UILabel alloc] initWithFrame: frame];
                    label.backgroundColor = [UIColor clearColor];
                    label.font = [UIFont boldSystemFontOfSize:16.0];
                    label.text = @"Sender's Username";
                    [cell.contentView addSubview:label];
                    
                    frame.origin.x = 180;
                    frame.size.height = 90;
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                        frame.size.width = 120;
                    }else {
                        frame.size.width = 250;
                    }
                    
                    hasSenderTextField = [[UITextField alloc] initWithFrame:frame];
                    hasSenderTextField.textAlignment = UITextAlignmentCenter;
                    hasSenderTextField.placeholder = @"Enter Here..."; 
                    hasSenderTextField.text = @"";
                    hasSenderTextField.returnKeyType = UIReturnKeyDefault;
                    hasSenderTextField.delegate = self;
                    [cell.contentView addSubview:hasSenderTextField];
                } 
            }
        }
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
