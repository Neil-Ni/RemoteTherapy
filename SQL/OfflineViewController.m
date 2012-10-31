//
//  OfflineViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 8/24/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "OfflineViewController.h"
#import "OfflineImageViewController.h"
#import "OfflineShowDocumentsViewControllerViewController.h"

@interface OfflineViewController () <OfflineImageViewControllerControllerdelegate, OfflineShowDocumentsViewControllerdelegate>{
    IBOutlet UILabel *QuestionLabel;
}

- (void)UpdateButtonsUI;
- (void)SetUpInitial;
- (void)showimagepicker;
- (void)ShowDocuments;

@end

static BOOL isDemoMode, isTestMode;

@implementation OfflineViewController
@synthesize ModeSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)ShowDocuments{
    OfflineShowDocumentsViewControllerViewController *DocumentsView = [[OfflineShowDocumentsViewControllerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    DocumentsView.isDemoMode = isDemoMode;
    DocumentsView.delegate = self;
    
    UINavigationController *Controller = [[UINavigationController alloc] initWithRootViewController:DocumentsView];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        Controller.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:Controller animated:YES];
    }else {
        [self presentModalViewController:Controller animated:YES];
    }
}

- (void) showimagepicker {
    if(isDemoMode){
        [self ShowDocuments];
    }
}

- (void) switchChanged:(id)send {
    
    UISwitch* switchControl = send;
    if(switchControl.on){
        isDemoMode = TRUE;
    }else {
        isDemoMode = FALSE;
    }
    isDemoMode? [self.ModeSwitch setOn:YES animated:NO]:[self.ModeSwitch setOn:NO animated:NO];
    
    [self showimagepicker];
    
    if(isDemoMode){
        NSLog(@"isDemoMode");
    }else {
        NSLog(@"not isDemoMode");
    }
}


- (void)SetUpInitial{
    self.view.backgroundColor = [UIColor blackColor];
    //default initial to be demomode
    
    isDemoMode = FALSE;
    isTestMode = TRUE;    
    
    isDemoMode? [self.ModeSwitch setOn:YES animated:NO]:[self.ModeSwitch setOn:NO animated:NO];
    [self.ModeSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self SetUpInitial];
}


- (void)viewDidUnload
{
    [self setModeSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)UpdateButtonsUI{    
    
}


- (IBAction)GoBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];

}


#pragma OfflineImageViewControllerControllerdelegate

static int session;
static bool OrderMode;
static bool ShuffleMode;

-(void)leaveDemomodeSessionFinal: (BOOL)final{
    [UIView animateWithDuration:0.99 animations:^
     {
         [self.view viewWithTag:20].frame = CGRectOffset(CGRectMake(0, 132, 618, 506), 768-75, 0);
         
     } completion:^(BOOL finished) 
     {
         
         if (finished) {
             [self.view viewWithTag:20].frame = CGRectMake(768, 132, 618, 506); 
             [[self.view viewWithTag:20] removeFromSuperview];
             for (OfflineImageViewController *aOfflineImageViewController in [self childViewControllers]){
                 [aOfflineImageViewController removeFromParentViewController];
                 NSLog(@"aOfflineImageViewController removed");
             }
             
             if(final){
                 NSLog(@"leaveOrdermodeSessionFinal"); 
                 QuestionLabel.text = @"";
             }else {
                 if(OrderMode){
                     session++;
                 }
                 if(ShuffleMode){
//                     session = arc4random()% [info count];
                 }
//                 [self OrdermodeWithSession:session%[folders count]];
             }
         }
     }];
}


- (void)startsessionwith: (NSMutableArray *)infos{
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(-618, 132, 618, 506)];
    view2.tag = 20;
    [self.view addSubview:view2];
    [UIView beginAnimations:@"SwitchToView1" context:nil];
    [UIView setAnimationDuration:0.99];
    view2.frame = CGRectOffset(view2.frame, 618+75, 0);
    [UIView commitAnimations];
    
    OfflineImageViewController *aOfflineImageViewController = [[OfflineImageViewController alloc] init];
    aOfflineImageViewController.delegate = self;
    aOfflineImageViewController.infos = infos;
    aOfflineImageViewController.isDemoMode = isDemoMode;
    aOfflineImageViewController.view.frame = view2.bounds;
    view2.autoresizesSubviews = YES; 
    [view2 addSubview:aOfflineImageViewController.view];
    [self addChildViewController:aOfflineImageViewController];
    

    
}

- (void)addItem:(OfflineImageViewController *)controller didFinishEnteringItem:(NSString *)item{
    NSLog(@"addItem");
    
}
- (void)nextsession:(OfflineImageViewController *)controller{
    QuestionLabel.text = @"";
    NSLog(@"nextsession");
}
- (void)score: (OfflineImageViewController *)controller{
    NSLog(@"score");
}

#pragma ShowDocumentsViewControllerdelegate

- (void)addItemViewController:(OfflineShowDocumentsViewControllerViewController *)controller didFinishEnteringItem:(NSMutableArray *)item{
    
    if(isDemoMode){
        NSLog(@"%@",item);
        NSLog(@"%@",[item objectAtIndex:0]);
        NSString *question = [[item objectAtIndex:0] objectForKey:@"question"]; 
        QuestionLabel.text = question;
        session = 0;
        [self startsessionwith: [[item objectAtIndex:0] objectForKey:@"imagesurl"]];
//        for(NSMutableDictionary *d in item){
//            NSString *folder = [d objectForKey:@"CategoryName"];
//            NSLog(@"/%@", folder);
//            for (NSMutableDictionary *info in  [d objectForKey:@"imagesurl"]) {
//                NSLog(@"   %@",[info objectForKey:@"Image_Name"]);
//    //            NSString *ImageName = [[NSString alloc] initWithFormat:@"%@%@.jpg",[question stringByReplacingOccurrencesOfString:@" " withString:@"_"], [info objectForKey:@"Image_Name"]];
//    //            NSLog(@"Uploading %@", ImageName);
//    //            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //            NSString *documentsDirectory = [paths objectAtIndex:0];
//    //            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:ImageName];
//    //            UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    //            NSData *webData = UIImageJPEGRepresentation(editedImage, 0.2);
//    //            [webData writeToFile:imagePath atomically:YES];
//                
//            }
//        }
//        NSString *question = [[item objectAtIndex:0] objectForKey:@"question"]; 
//        NSLog(@"%@",question);
//
//        [self startsessionwith: [item objectAtIndex:0]];
    }

}

@end
