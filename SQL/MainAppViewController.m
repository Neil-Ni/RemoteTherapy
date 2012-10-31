//
//  MainAppViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 6/27/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "MainAppViewController.h"
#import "SQL.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <DropboxSDK/DropboxSDK.h>
#import "ShowDocumentsViewController.h"
#import "DropBoxViewController.h"
#import "SignUpViewController.h"
#import "ImagesViewController.h"

@interface MainAppViewController () <SignUpViewControllerControllerdelegate,ShowDocumentsViewControllerdelegate, DBRestClientDelegate, ImagesViewControllerControllerdelegate>{
    NSMutableArray *folders;
    NSString *folder;
    BOOL sessionover;
}

//- (void)setupImages;
- (void)changeSelectedButtonTect;
- (void)OrdermodeWithSession:(NSInteger)s;
- (void)startordermode;
- (void)leaveOrdermodeSessionFinal:(BOOL)final;

@end

@implementation MainAppViewController 
@synthesize PlayButton;
@synthesize UserProfile;
@synthesize Documents;
@synthesize DropBo;

static NSString* const kApiKey = @"";
static NSString* const kToken = @"";
static NSString* const kSessionId = @"";
static bool subscribeToSelf = YES; // Change to NO if you want to subscribe to streams other than your own.
static bool AudioEnabled = TRUE;
static bool Partneronline = FALSE;
@synthesize popoverController_;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) CheckOnline: (NSTimer *)timer{
    //timer fto check if online
    //check if interenet is connected
    NSArray *logarray;
    if(Sender){
        logarray = [SQL returnlog:[SQL returnReceiver:username]];
    }
    if(receiver){
        logarray = [SQL returnlog:[SQL returnSender:username]];
    }
    int online = [[logarray objectAtIndex:0] intValue];
    NSLog(@"%d",online);
    if(Sender){
        if(online == 1){
            Chatting = TRUE;
            self.PlayButton.hidden = FALSE;
        }else{  
            Chatting = FALSE;
            self.PlayButton.hidden = TRUE;
        }; 
    }
    if(receiver){
        if(online == 1){
            Chatting = TRUE;
        }else{
            Chatting = FALSE;
        }; 
    }
//    if (Chatting == TRUE){ 
//        NSLog(@"Partner is online");
//    }else {
//        NSLog(@"Partner is not online");
//    };

    if(InteractionMode){
        if(io == TRUE && sessionover == TRUE){
            NSString *folderrequest = [logarray objectAtIndex:1];
            if(folderrequest){
                folder = folderrequest;
                NSLog(@"requestedfolder %@", folderrequest);
                for(int j = 0; j< [folders count]; j++){
                    if([folder isEqualToString: [[folders objectAtIndex:j] stringByReplacingOccurrencesOfString:@" " withString:@""]]){
                        session = j;
                        NSLog(@"%d", j);
                        [self OrdermodeWithSession:j];
                    }
                }
            }
        }
    }

}
- (void)setUpInitial{
    sessionover = TRUE;
    _session = [[OTSession alloc] initWithSessionId:kSessionId
                                                            delegate:self];
    self.view.autoresizingMask = FALSE;
    self.view.autoresizesSubviews = FALSE;
    log = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    username = appDelegate.Username;
    //check if the user is receiver or sender
    [SQL appendlog:username andResponse:1 andFolder:nil];
    Sender = [SQL hasReceiver:username];
    receiver = [SQL hasSender:username];
    NSLog(@"username %@",username);
    
    NSArray *logarray;
    
    if(Sender){
        logarray = [SQL returnlog:[SQL returnReceiver:username]];
    }
    if(receiver){
        logarray = [SQL returnlog:[SQL returnSender:username]];
    }

    int online = [[logarray objectAtIndex:0] intValue];
    if(Sender){
        if(online == 1){
            Chatting = TRUE;
            self.PlayButton.hidden = FALSE;
        }else{
            Chatting = FALSE;
            self.PlayButton.hidden = TRUE;
        }; 
    }
    if(receiver){
        if(online == 1){
            Chatting = TRUE;
        }else{
            Chatting = FALSE;
        }; 
    }
    if (Chatting == TRUE){ 
        NSLog(@"Partner is online");
    }else {
        NSLog(@"Partner is not online");
    };
//    float height = Sender? self.view.frame.size.height: self.view.frame.size.height;
//    float spacing = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 20: 5;
//    tableview = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*80/100., spacing, self.view.frame.size.width*20/100., height) style:UITableViewStylePlain];
//    tableview.dataSource = self;
//    tableview.delegate = self; 
//    tableview.separatorColor = [UIColor clearColor];
    
    Chatting = TRUE;
    self.PlayButton.hidden = FALSE;

    if(Sender){//means sender
        Displayimages = 2;
        urlarray = [[NSMutableArray alloc] init];
        UIBarButtonItem *ShowDownloadsButton = [[UIBarButtonItem alloc] initWithTitle:@"Select Images" style:UIBarButtonItemStyleDone target:self action:@selector(handleShowImagesbuttonpressed:)];
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *LogoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(handleLogoutbuttonpressed:)];
        [self.navigationItem setLeftBarButtonItem:LogoutButton animated:YES];

        [self.navigationItem setRightBarButtonItem:ShowDownloadsButton animated:YES];
        NSLog(@"Receiver: %@", [SQL returnReceiver:username]);
        if (Chatting == TRUE){ 
        }else {
            self.PlayButton.hidden = TRUE;
        };
    }
    if(receiver){
        self.DropBo.hidden = YES; 
        self.Documents.hidden = YES;
        urlarray = [[NSMutableArray alloc] init];
        [timer invalidate];
        UIBarButtonItem *ShowDownloadsButton = [[UIBarButtonItem alloc] initWithTitle:@"Retrieve" style:UIBarButtonItemStyleDone target:self action:@selector(handleRetrievebuttonpressed:)];
        [self.navigationItem setRightBarButtonItem:ShowDownloadsButton animated:YES];
        UIBarButtonItem *LogoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(handleLogoutbuttonpressed:)];
        [self.navigationItem setLeftBarButtonItem:LogoutButton animated:YES];

        NSLog(@"Sender: %@", [SQL returnSender:username]);
        tappednumber = 0; 
        
    }
    //use the booleans to ask the person to sign up?
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    spinner.hidden = YES;
    [self.view addSubview:spinner];
    
}

- (void)updateSubscriber {
    for (NSString* streamId in _session.streams) {
        OTStream* stream = [_session.streams valueForKey:streamId];
        if (![stream.connection.connectionId isEqualToString: _session.connection.connectionId]) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            break;
        }
    }
}

- (void) handleLogoutbuttonpressed: (id)sender{
    [timer invalidate];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)handleRetrievebuttonpressed: (id)sender{
    if([urlarray count]> 0){
        Displayimages = 0;
        [tableview beginUpdates];
        NSArray *indexPathsToInsert = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0], [NSIndexPath indexPathForRow:3 inSection:0], nil];
        [tableview deleteRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationRight];
        [tableview endUpdates];

    }
    urlarray = [SQL returnURL:[SQL returnSender:username] andNumber:@"0"];
    NSString *result = [SQL deletelog:username];
    for(NSString *s in urlarray){
        NSLog(@"%@",s);
    }
    [tableview removeFromSuperview];
    [self.view addSubview: tableview];
    
    tableview.scrollEnabled = FALSE;
    Displayimages = 2;
    [tableview beginUpdates];
    NSArray *indexPathsToInsert = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0], [NSIndexPath indexPathForRow:3 inSection:0], nil];
    [tableview insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationRight];
    [tableview endUpdates];
    
}

- (void)Displayimages{
    [tableview beginUpdates];
    NSArray *indexPathsToInsert = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0], [NSIndexPath indexPathForRow:3 inSection:0], nil];
    [tableview deleteRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationRight];
    [tableview endUpdates];
    
    Displayimages = 1;
    [tableview beginUpdates];
    [tableview insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationRight];
    [tableview endUpdates];
    tableview.scrollEnabled = FALSE;
    NSString *title = [[NSString alloc] initWithFormat:@"Select Images"];
    self.navigationItem.rightBarButtonItem.title = title;
}


- (void)CheckLog{
    //NSLog(@"receiver %@",[SQL returnReceiver:username]);
//    int result = [SQL returnlog:[SQL returnReceiver:username]];
    
//    NSArray *logarray;
//    if(Sender){
//        logarray = [SQL returnlog:[SQL returnReceiver:username]];
//    }
//    if(receiver){
//        logarray = [SQL returnlog:[SQL returnSender:username]];
//    }

//    NSLog(@"result %d",result);
//    NSLog(@"%d", [log count]);
//    if (![log containsObject:[NSNumber numberWithInt:result]]) {
//        if(result!=4){
//            //tappednumber = result;
//            [log addObject:[NSNumber numberWithInt:result]];
//            UITableViewCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:result inSection:0]];
//            UIImageView *imageview = (UIImageView *)[cell.contentView viewWithTag:200];
//            imageview.image = [UIImage imageNamed:@"videoButtonActive@2x.png"];
//            NSArray *indexPathsToInsert = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:result inSection:0], nil];
//            [tableview beginUpdates];
//            [tableview deleteRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
//            [tableview endUpdates];
//            [tableview beginUpdates];
//            [tableview insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationBottom];
//            [tableview endUpdates];
//        }
//    }
//    if([log count] == 5){
//        [timer invalidate];
//        [log removeAllObjects];
//        NSLog(@"invalidate"); 
//    }
    //once there are 4 result then the timer can be invalidated.
}


-(void)SQLlogchecking{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckLog) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [SQL appendlog:username andResponse:0 andFolder:nil];
    [_session disconnect];
    [timer invalidate];


}
- (void)viewWillAppear:(BOOL)animated{

}


//-(void) showMyActionSheet
//{
//    sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Profile", @"Edit Photos", nil]; 
//    [sheet showInView:self.view];
//
//}
- (void)viewDidLoad
{
//    [[DBSession sharedSession] unlinkAll];
    [self setUpInitial];
    //unlink first to test out when the app is first used
    
//    receiver = TRUE;
//    Chatting = TRUE;

    if (![[DBSession sharedSession] isLinked]) {
        NSLog(@"DBSession isnotLinked");
        [[DBSession sharedSession] linkFromController:self];
    }else {
        NSLog(@"DBSession isLinked");
        folders = [[NSMutableArray alloc] init];
        [[self restClient] loadMetadata:@"/"];
//        [self performSelectorOnMainThread:@selector(showMyActionSheet) withObject:nil waitUntilDone:NO];
    }
    
    self.view.backgroundColor = [UIColor blackColor];

    timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(CheckOnline:)
                                   userInfo:nil
                                    repeats:YES];
//    Chatting = TRUE;
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setPlayButton:nil];
    [self setUserProfile:nil];
    [self setDocuments:nil];
    [self setDropBo:nil];
    QuestionLabel = nil;
    [super viewDidUnload];
    popoverController_= nil;
    username= nil;
    urlarray= nil;
    spinner= nil;
    ScrollView= nil;
    
    log= nil;
    timer= nil;
    confirm= nil;
    _session= nil;
    _publisher= nil; 
    _subscriber= nil;
    [SQL appendlog:username andResponse:0 andFolder:nil];
    [_session disconnect];
    [timer invalidate];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UIWebView *)Stupwebviewdetails:(UIWebView *) webview{
    webview.scalesPageToFit = YES;
    webview.scrollView.autoresizesSubviews = YES;
    webview.layer.cornerRadius = 10.0;
    webview.scrollView.scrollEnabled = NO;
    webview.scrollView.bounces = NO;    
    webview.scrollView.userInteractionEnabled = NO;
    webview.scrollView.contentMode = UIViewContentModeScaleAspectFit;
    return webview;
}

-(UIImageView *)setupimagesdetails: (UIImageView*)imageview{
    imageview.autoresizesSubviews = YES;
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = 20.0;
    imageview.userInteractionEnabled = YES;
    return imageview;
}

- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}


-(void)changeSelectedButtonTect{
//    int i = [ImageDictArray count];
    int i = [urlarray count];
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Select Images"]){
        [tableview removeFromSuperview];
        NSString *result = [SQL deletelog:[SQL returnReceiver:username]];
        [timer invalidate];
        [log removeAllObjects];
    }
    NSString *title;
    if (i == 4){
        title = [[NSString alloc] initWithFormat:@"Confirm"];
    }else if (i == 3){
        title = [[NSString alloc] initWithFormat:@"1 more"];
    }else {
        title = [[NSString alloc] initWithFormat:@"%d more", 4-i]; 
    }
    self.navigationItem.rightBarButtonItem.title = title;
}
-(void)setUpsnedAndConfirmbutton{
    confirm.hidden = NO;
}

#pragma - uipopover delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self changeSelectedButtonTect];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [tableview removeFromSuperview];
    [self.view addSubview: tableview];
    [tableview reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma - uiimagepicker delegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    [urlarray addObject:referenceURL];
    [self changeSelectedButtonTect];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if([urlarray count] == 4){
            [tableview removeFromSuperview];
            [self.view addSubview: tableview];
            [tableview reloadData];
            [picker dismissViewControllerAnimated:YES completion:^(){
            }];
        }
        
    }else {
        if([urlarray count] == 4){
            [tableview removeFromSuperview];
            [self.view addSubview: tableview];
            [tableview reloadData];
            [self.popoverController_ dismissPopoverAnimated:YES];
        }
    }
    
}
- (IBAction)GoBack:(id)sender {
    [timer invalidate];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - OpenTok methods

- (void)doConnect 
{
    spinner.hidden = NO;
//    [spinner startAnimating];
    [_session connectWithApiKey:kApiKey token:kToken];
}

- (void)doPublish
{
    if(!_publisher){
        _publisher = [[OTPublisher alloc] initWithDelegate:self];
        [_publisher setName:[[UIDevice currentDevice] name]];
        _publisher.publishAudio = YES;
        _publisher.publishVideo = YES;
        [_session publish:_publisher];
    }
    
//    
//    [self.view addSubview:_publisher.view];
//    [_publisher.view setFrame:CGRectMake(widgetWidth/2.-widgetHeight/2., widgetHeight-200, widgetHeight/5., widgetWidth/5.)];
//    _publisher.view.layer.masksToBounds = YES;
//    _publisher.view.layer.borderColor = [[UIColor blackColor] CGColor];
//    _publisher.view.layer.borderWidth = 1.0;
//    _publisher.view.layer.cornerRadius = 10.0;
//    _publisher.view.userInteractionEnabled = YES;
//
//    [self.view bringSubviewToFront:_publisher.view];
//    
//    [spinner stopAnimating];
//    spinner.hidden = YES;
//    for (UIImageView *checkView in [self.view subviews] ) {
//        if ([checkView tag] == 1) {
//            checkView.image = [UIImage imageNamed:@"videoButtonActive.png"];
//        }
//    }
    
}

- (void)sessionDidConnect:(OTSession*)session
{
    self.PlayButton.enabled = YES;
    self.PlayButton.alpha = 1;

    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self doPublish];
    }else {
        [self doPublish];
    }
}

- (void)sessionDidDisconnect:(OTSession*)session
{

    NSString* alertMessage = [NSString stringWithFormat:@"Session disconnected: (%@)", session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
    self.PlayButton.enabled = YES;
    self.PlayButton.alpha = 1;

//    [self showAlert:alertMessage];
}


- (void)session:(OTSession*)mySession didReceiveStream:(OTStream*)stream
{
    NSLog(@"session didReceiveStream (%@)", stream.streamId);
    
    // See the declaration of subscribeToSelf above.
    if ( (subscribeToSelf && [stream.connection.connectionId isEqualToString: _session.connection.connectionId])
        ||
        (!subscribeToSelf && ![stream.connection.connectionId isEqualToString: _session.connection.connectionId])
        ) {
        if (!_subscriber) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
        }
    }
}

- (void)session:(OTSession*)session didDropStream:(OTStream*)stream{
    NSLog(@"session didDropStream (%@)", stream.streamId);
    NSLog(@"_subscriber.stream.streamId (%@)", _subscriber.stream.streamId);
    self.PlayButton.enabled = YES;
    self.PlayButton.alpha = 1;

 
    if (!subscribeToSelf
        && _subscriber
        && [_subscriber.stream.streamId isEqualToString: stream.streamId])
    {
        _subscriber = nil;
        [self updateSubscriber];

    }
}

- (void)subscriberDidConnectToStream:(OTSubscriber*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)", subscriber.stream.connection.connectionId);
    subscriber.subscribeToAudio = YES;
    subscriber.subscribeToVideo = YES;
    [self.view viewWithTag:30].backgroundColor = [UIColor clearColor];
    subscriber.view.frame = [self.view viewWithTag:30].frame;
//    [subscriber.view setFrame:CGRectMake(widgetWidth/2.-widgetHeight/2., widgetHeight-200, widgetHeight, widgetWidth)];
    subscriber.view.layer.masksToBounds = YES;
    subscriber.view.layer.borderColor = [[UIColor blackColor] CGColor];
    subscriber.view.layer.borderWidth = 1.0;
    subscriber.view.layer.cornerRadius = 10.0;
    subscriber.view.userInteractionEnabled = YES;
    subscriber.view.tag = 30;
//    [[self.view viewWithTag:30] addSubview:subscriber.view];
    [self.view addSubview:subscriber.view];
    [self.view sendSubviewToBack:subscriber.view];

}

- (void)publisher:(OTPublisher*)publisher didFailWithError:(NSError*) error {
    NSLog(@"publisher didFailWithError %@", error);
//    [self showAlert:[NSString stringWithFormat:@"There was an error publishing."]];
}

- (void)subscriber:(OTSubscriber*)subscriber didFailWithError:(NSError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@", subscriber.stream.streamId, error);
//    [self showAlert:[NSString stringWithFormat:@"There was an error subscribing to stream %@", subscriber.stream.streamId]];
}

- (void)session:(OTSession*)session didFailWithError:(NSError*)error {
    NSLog(@"sessionDidFail");
    self.PlayButton.enabled = NO;
    self.PlayButton.alpha = 0.5;
    io = FALSE;
//    [self showAlert:[NSString stringWithFormat:@"There was an error connecting to session %@", session.sessionId]];
}


- (void)showAlert:(NSString*)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message from video session"
                                                    message:string
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (Displayimages) {
        case 0:
            return 0; 
            break;
        case 1:
            return [urlarray count];
            break;
        case 2:
            return [urlarray count];
            break;
        case 3:
            return 3;
            break;
        default:
            break;
    }
    return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? tableview.frame.size.width*1.5: tableview.frame.size.width*1.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyCellIdentifier = @"MyCellIdentifier";
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:MyCellIdentifier];
    for(UIView *view in [cell.contentView subviews]){
        [view removeFromSuperview];
    }
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCellIdentifier];
    }
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.height = (tableview.frame.size.width)*1.5;
    frame.size.width = tableview.frame.size.width;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:frame];
    if(Sender){
        if(Displayimages==1){
            NSURL *url = [urlarray objectAtIndex:indexPath.row];
            NSLog(@"%d",[urlarray count]);
            NSLog(@"%@",url);
            float spacing = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?30 : 10;
            
            CGRect frame = CGRectMake(spacing, spacing,  tableview.frame.size.width-spacing, (tableview.frame.size.width-spacing)*1.5);
            imageview.frame = frame;
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:url resultBlock:^(ALAsset *asset){
                UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                imageview.image = copyOfOriginalImage;
            }failureBlock:^(NSError *error){
                // error handling
            }];
            NSLog(@"%@",NSStringFromCGRect(frame));
            
            [cell.contentView addSubview:imageview];
            frame = CGRectMake(0, (tableview.frame.size.width-spacing)*1.5/2., spacing, spacing);            
            NSLog(@"%@",NSStringFromCGRect(frame));
            UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:frame];
            imageview2.tag = 200;
            imageview2.image = [UIImage imageNamed:@"videoButton@2x.png"];
            [cell.contentView addSubview:imageview2];
            
        }else {
            NSURL *url = [urlarray objectAtIndex:indexPath.row];
            NSLog(@"%@",url);
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:url resultBlock:^(ALAsset *asset){
                UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                imageview.image = copyOfOriginalImage;
            }failureBlock:^(NSError *error){
                // error handling
            }];
            [cell.contentView addSubview:imageview];   
        }
    }
    if(receiver){
        UIWebView *webview = [[UIWebView alloc] initWithFrame:frame];
        webview.tag = 100;
        webview = [self Stupwebviewdetails: webview];
        NSString *url = [urlarray objectAtIndex:indexPath.row];
        int width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 600:250;
        NSString *htmlString = @"<html><body><img src='%@' width='%d'></body></html>";
        NSString *imageHTML  = [[NSString alloc] initWithFormat:htmlString, url, width];
        webview = [self Stupwebviewdetails: webview];
        webview.backgroundColor = [UIColor clearColor];
        [webview loadHTMLString:imageHTML baseURL:nil];
        [cell.contentView addSubview:webview];
        cell.userInteractionEnabled = YES;
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    if(Sender){
        if(Displayimages!=1){
            [urlarray removeObjectAtIndex:indexPath.row];
            [tableview beginUpdates];
            NSArray *indexPathsToInsert = [NSArray arrayWithObject:indexPath];
            [tableview deleteRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationRight];
            [tableview endUpdates];
            [self changeSelectedButtonTect];
        }
    }else {
        tappednumber+=1;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.contentView viewWithTag:100].alpha = 0.2;
        cell.userInteractionEnabled = NO;
        if(tappednumber%4!=0){
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
//        NSString *result = [SQL appendlog:username andResponse:indexPath.row];
//        NSLog(@"%@",result);
    }
}


#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            [folders addObject:file.filename];
            NSLog(@"\t%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
//    [self loadRandomPhoto];
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
//    [self setWorking:NO];
//    imageView.image = [UIImage imageWithContentsOfFile:destPath];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
//    [self setWorking:NO];
//    [self displayError];
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

static bool OrderMode = FALSE;
static bool ShuffleMode = FALSE;
static bool InteractionMode = TRUE;


#pragma mark -SignUpViewControllerControllerdelegate
- (void)setSettingWith:(SignUpViewController *)controller OrderMode:(BOOL) ordermode andShuffleMode:(BOOL)shufflemode andInteractionMode:(BOOL) interactionmode{
    
    if(ordermode){
        NSLog(@"ordermode on");
    }else {
        NSLog(@"ordermode off");
    }
    if(shufflemode){
        NSLog(@"shufflemode on");
    }else {
        NSLog(@"shufflemode off");
    }
    if(interactionmode){
        NSLog(@"interactionmode on");
    }else {
        NSLog(@"interactionmode off");
    }
    
    if(!ordermode && !shufflemode && !interactionmode){
        ordermode = FALSE;
        shufflemode = FALSE;
        interactionmode = TRUE;
    }

    OrderMode = ordermode; 
    ShuffleMode = shufflemode;
    InteractionMode = interactionmode; 

}

#pragma mark -ImagesViewControllerControllerdelegate

- (void)addItem:(ImagesViewController *)controller didFinishEnteringItem:(NSString *)item{
    NSLog(@"ImagesViewControllerControllerdelegate %@", item);
    QuestionLabel.text = item;
}
-(void)next{
    if(OrderMode || ShuffleMode){
        [self leaveOrdermodeSessionFinal: NO];
    }
    if(InteractionMode){
        [self leaveOrdermodeSessionFinal:YES];
    }
    
}

- (void)nextsession:(ImagesViewController *)controller{
    NSLog(@"Done");
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(next)
                                   userInfo:nil
                                    repeats:NO];
}

#pragma mark -ShowUserProfile


- (IBAction)ShowUserProfile:(id)sender {
    
    SignUpViewController *aSignUpViewController = [[SignUpViewController alloc] initWithStyle:UITableViewStyleGrouped];
    aSignUpViewController.Profile = TRUE;
    if(OrderMode || ShuffleMode || InteractionMode){
        aSignUpViewController.ordermode = OrderMode;
        aSignUpViewController.shufflemode = ShuffleMode;
        aSignUpViewController.interactionmode  = InteractionMode;
    }
    aSignUpViewController.delegate = self;
    UINavigationController *Controller = [[UINavigationController alloc] initWithRootViewController:aSignUpViewController];     
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        Controller.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:Controller animated:YES];
    }else {
        [self presentModalViewController:Controller animated:YES];
    }
}

#pragma mark -ShowDocuments

- (IBAction)ShowDocuments:(id)sender {
    
    ShowDocumentsViewController *DocumentsView = [[ShowDocumentsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    DocumentsView.delegate = self;
    UINavigationController *Controller = [[UINavigationController alloc] initWithRootViewController:DocumentsView];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        Controller.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:Controller animated:YES];
    }else {
        [self presentModalViewController:Controller animated:YES];
    }
}


#pragma mark -ShowDropBox

- (IBAction)ShowDropBo:(id)sender {
    DropBoxViewController *aDropBoxViewController = [[DropBoxViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *Controller = [[UINavigationController alloc] initWithRootViewController:aDropBoxViewController];     
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        Controller.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:Controller animated:YES];
    }else {
        [self presentModalViewController:Controller animated:YES];
    }

    
}


#pragma mark -ShowDocumentsViewControllerdelegate

- (void)addItemViewController:(ShowDocumentsViewController *)controller didFinishEnteringItem:(NSMutableArray *)item{
    NSLog(@"didFinishEnteringItem");
    
    for(NSMutableDictionary *d in item){
        NSString *question = [d objectForKey:@"question"];
        NSString *folder = [d objectForKey:@"CategoryName"];
        [[self restClient] createFolder:folder];
        NSString *destDir = [[NSString alloc] initWithFormat:@"/%@",folder];
        NSLog(@"Creating %@", folder);
        for (NSMutableDictionary *info in  [d objectForKey:@"imagesurl"]) {
            NSString *ImageName = [[NSString alloc] initWithFormat:@"%@%@.jpg",[question stringByReplacingOccurrencesOfString:@" " withString:@"_"], [info objectForKey:@"Image_Name"]];
            NSLog(@"Uploading %@", ImageName);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:ImageName];
            UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            NSData *webData = UIImageJPEGRepresentation(editedImage, 0.2);
            [webData writeToFile:imagePath atomically:YES];
            [[self restClient] uploadFile:ImageName toPath:destDir withParentRev:nil fromPath:imagePath];
            
        }
    }
    
}

- (void) initiatedropboxsession{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(768, 434, 183, 368)];
        view.tag = 10;
        view.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:view];
        [UIView beginAnimations:@"SwitchToView1" context:nil];
        [UIView setAnimationDuration:0.5];
        view.frame = CGRectOffset(view.frame, -183, 0);
        [UIView commitAnimations];
        
        DropBoxViewController *aDropBoxViewController = [[DropBoxViewController alloc] initWithStyle:UITableViewStyleGrouped];
        aDropBoxViewController.view.frame = view.bounds;

        aDropBoxViewController.ChildView = TRUE;
        aDropBoxViewController.Receiver = FALSE;
        
        view.autoresizesSubviews = YES; 
        [view addSubview:aDropBoxViewController.view];
        [self addChildViewController:aDropBoxViewController];
        
        
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(-400, 202, 400, 600)];
        view3.tag = 30;
        view3.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view3];
        [UIView beginAnimations:@"SwitchToView1" context:nil];
        [UIView setAnimationDuration:0.5];
        view3.frame = CGRectOffset(view3.frame, 584, 0);
        [UIView commitAnimations];
    }else {
        
        self.UserProfile.hidden = YES;
        self.DropBo.hidden = YES; 
        self.Documents.hidden = YES;
        
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(60, 460, 200, 300)];
        view3.tag = 30;
        view3.backgroundColor = [UIColor whiteColor];
        view3.layer.borderColor = [[UIColor grayColor] CGColor];
        [self.view addSubview:view3];
        [UIView beginAnimations:@"SwitchToView1" context:nil];
        [UIView setAnimationDuration:0.5];
        view3.frame = CGRectOffset(view3.frame, 0, -380);
        [UIView commitAnimations];
        
    }
    self.PlayButton.enabled = YES;
    self.PlayButton.alpha = 1;

}

- (void) canceldropboxsession{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){

        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view viewWithTag:10].frame = CGRectOffset(CGRectMake(585, 434, 183, 368), 183, 0);
             
         } completion:^(BOOL finished) 
         {
             
             if (finished) {
                 
                 [self.view viewWithTag:10].frame = CGRectMake(768, 434, 183, 368); 
                 [[self.view viewWithTag:10] removeFromSuperview];
                 for (DropBoxViewController *aDropBoxViewController in [self childViewControllers]){
                     [aDropBoxViewController removeFromParentViewController];
                     NSLog(@"aDropBoxViewController removed");
                 }
             }
         }];
        
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view viewWithTag:30].frame = CGRectOffset(CGRectMake(184, 202, 400, 600), -584, 0);
             
         } completion:^(BOOL finished) 
         {
             
             if (finished) {
                 [self quittokbox];
                 [self.view viewWithTag:30].frame = CGRectMake(-400, 202, 400, 600); 
                 [[self.view viewWithTag:30] removeFromSuperview];
             }
         }];
    }else {
        
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view viewWithTag:30].frame = CGRectOffset(CGRectMake(60, 80, 200, 300), 380, 0);
             
         } completion:^(BOOL finished) 
         {
             
             if (finished) {
                 [self quittokbox];
                 self.UserProfile.hidden = NO;
                 self.DropBo.hidden = NO; 
                 self.Documents.hidden = NO;

                 [self.view viewWithTag:30].frame = CGRectMake(60, 460, 200, 300); 
                 [[self.view viewWithTag:30] removeFromSuperview];
             }
         }];

    }
}

- (void)initiatedropboxsessionwithreceiverwithchatting{
    //canceldropboxsessionwithreceiverwithchatting
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(157, 1004, 190, 364)];
    view.tag = 10;
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    [UIView beginAnimations:@"SwitchToView1" context:nil];
    [UIView setAnimationDuration:0.5];
    view.frame = CGRectOffset(view.frame, 0, -364);
    [UIView commitAnimations];
    
    DropBoxViewController *aDropBoxViewController = [[DropBoxViewController alloc] initWithStyle:UITableViewStyleGrouped];
    aDropBoxViewController.view.frame = view.bounds;
    
    aDropBoxViewController.ChildView = TRUE;
    aDropBoxViewController.Receiver = TRUE;
    
    view.autoresizesSubviews = YES; 
    [view addSubview:aDropBoxViewController.view];
    [self addChildViewController:aDropBoxViewController];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(-618, 132, 618, 506)];
    view2.tag = 20;
    view2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view2];
    [UIView beginAnimations:@"SwitchToView1" context:nil];
    [UIView setAnimationDuration:0.99];
    view2.frame = CGRectOffset(view2.frame, 618+75, 0);
    [UIView commitAnimations];
    
    ImagesViewController *aImagesViewController = [[ImagesViewController alloc] init];
    aDropBoxViewController.delegate = aImagesViewController;
    aImagesViewController.delegate = self;
    aImagesViewController.ordermode = OrderMode;
    aImagesViewController.shufflemode = ShuffleMode;
    aImagesViewController.interactionmode = InteractionMode; 

    aImagesViewController.view.frame = view2.bounds;
    view2.autoresizesSubviews = YES; 
    [view2 addSubview:aImagesViewController.view];
    [self addChildViewController:aImagesViewController];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(350, 1004, 268, 364)];
    view3.tag = 30;
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
    [UIView beginAnimations:@"SwitchToView1" context:nil];
    [UIView setAnimationDuration:0.99];
    view3.frame = CGRectOffset(view3.frame, 0, -364);
    [UIView commitAnimations];


}

- (void)canceldropboxsessionwithreceiverwithchatting{
    //initiatedropboxsessionwithreceiverwithchatting
    [UIView animateWithDuration:0.99 animations:^
     {
         [self.view viewWithTag:20].frame = CGRectOffset(CGRectMake(0, 132, 618, 506), -618-75, 0);
         
     } completion:^(BOOL finished) 
     {
         
         if (finished) {
             [self.view viewWithTag:20].frame = CGRectMake(-618, 132, 618, 506); 
             [[self.view viewWithTag:20] removeFromSuperview];
             for (ImagesViewController *aImagesViewController in [self childViewControllers]){
                 [aImagesViewController removeFromParentViewController];
                 NSLog(@"aImagesViewController removed");
             }
         }
     }];
    
    [UIView animateWithDuration:0.5 animations:^
     {
         [self.view viewWithTag:10].frame = CGRectOffset(CGRectMake(157, 640, 190, 364), 0, 364);
         
     } completion:^(BOOL finished) 
     {
         
         if (finished) {
             [self.view viewWithTag:10].frame = CGRectMake(157, 1004, 190, 364); 
             [[self.view viewWithTag:10] removeFromSuperview];
             for (DropBoxViewController *aDropBoxViewController in [self childViewControllers]){
                 [aDropBoxViewController removeFromParentViewController];
                 NSLog(@"aDropBoxViewController removed");
             }
         }
     }];
    [UIView animateWithDuration:0.5 animations:^
     {
         [self.view viewWithTag:30].frame = CGRectOffset(CGRectMake(350, 640, 268, 364), 0, 364);
         
     } completion:^(BOOL finished) 
     {
         
         if (finished) {
             [self.view viewWithTag:30].frame = CGRectMake(350, 1004, 268, 364); 
             [[self.view viewWithTag:30] removeFromSuperview];
         }
     }];
}


- (void)initiatedropboxsessionwithreceiver{
    //canceldropboxsessionwithreceiver
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(768, 325, 150, 290)];
    view.tag = 10;
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    [UIView beginAnimations:@"SwitchToView1" context:nil];
    [UIView setAnimationDuration:0.5];
    view.frame = CGRectOffset(view.frame, -150, 0);
    [UIView commitAnimations];
    
    DropBoxViewController *aDropBoxViewController = [[DropBoxViewController alloc] initWithStyle:UITableViewStyleGrouped];
    aDropBoxViewController.view.frame = view.bounds;
    
    aDropBoxViewController.ChildView = TRUE;
    aDropBoxViewController.Receiver = TRUE;
    
    view.autoresizesSubviews = YES; 
    [view addSubview:aDropBoxViewController.view];
    [self addChildViewController:aDropBoxViewController];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(-618, 217, 618, 506)];
    view2.tag = 20;
    view2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view2];
    [UIView beginAnimations:@"SwitchToView1" context:nil];
    [UIView setAnimationDuration:0.99];
    view2.frame = CGRectOffset(view2.frame, 618, 0);
    [UIView commitAnimations];
    
    ImagesViewController *aImagesViewController = [[ImagesViewController alloc] init];
    aDropBoxViewController.delegate = aImagesViewController;
    aImagesViewController.ordermode = OrderMode;
    aImagesViewController.shufflemode = ShuffleMode;
    aImagesViewController.interactionmode = InteractionMode; 

    aImagesViewController.view.frame = view2.bounds;
    view2.autoresizesSubviews = YES; 
    [view2 addSubview:aImagesViewController.view];
    [self addChildViewController:aImagesViewController];
    
}
- (void)canceldropboxsessionwithreceiver{
    //initiatedropboxsessionwithreceiver
    [UIView animateWithDuration:0.99 animations:^
     {
         [self.view viewWithTag:20].frame = CGRectOffset(CGRectMake(0, 217, 618, 506), -618, 0);
         
     } completion:^(BOOL finished) 
     {
         
         if (finished) {
             [self.view viewWithTag:20].frame = CGRectMake(-618, 217, 618, 506); 
             [[self.view viewWithTag:20] removeFromSuperview];
             for (ImagesViewController *aImagesViewController in [self childViewControllers]){
                 [aImagesViewController removeFromParentViewController];
                 NSLog(@"aImagesViewController removed");
             }
         }
     }];
    
    [UIView animateWithDuration:0.5 animations:^
     {
         [self.view viewWithTag:10].frame = CGRectOffset(CGRectMake(618, 325, 150, 290), 150, 0);
         
     } completion:^(BOOL finished) 
     {
         
         if (finished) {
             [self.view viewWithTag:10].frame = CGRectMake(768, 325, 150, 290); 
             [[self.view viewWithTag:10] removeFromSuperview];
             for (DropBoxViewController *aDropBoxViewController in [self childViewControllers]){
                 [aDropBoxViewController removeFromParentViewController];
                 NSLog(@"aDropBoxViewController removed");
             }
         }
     }];
}

static int session;

#pragma mark -ordermode

-(void)leaveOrdermodeSessionFinal: (BOOL)final{
    [UIView animateWithDuration:0.99 animations:^
     {
         [self.view viewWithTag:20].frame = CGRectOffset(CGRectMake(0, 132, 618, 506), 768-75, 0);
         
     } completion:^(BOOL finished) 
     {
         
         if (finished) {
             [self.view viewWithTag:20].frame = CGRectMake(768, 132, 618, 506); 
             [[self.view viewWithTag:20] removeFromSuperview];
             for (ImagesViewController *aImagesViewController in [self childViewControllers]){
                 [aImagesViewController removeFromParentViewController];
                 NSLog(@"aImagesViewController removed");
             }
             if(final){
                 NSLog(@"leaveOrdermodeSessionFinal"); 
                 QuestionLabel.text = @"";
                 if(InteractionMode){
                     sessionover = TRUE;
                 }
             }else {
                 if(OrderMode){
                     session++;
                 }
                 if(ShuffleMode){
                     session = arc4random()% [folders count];
                 }
                 [self OrdermodeWithSession:session%[folders count]];
             }
         }
     }];
}

- (void)OrdermodeWithSession:(NSInteger)s {
    if(InteractionMode){
        [SQL appendlog:[SQL returnSender:username] andResponse:1 andFolder:nil];
        sessionover = FALSE;
    }
    NSString *foldername = [folders objectAtIndex:s];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(-618, 132, 618, 506)];
    view2.tag = 20;
    view2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view2];
    [UIView beginAnimations:@"SwitchToView1" context:nil];
    [UIView setAnimationDuration:0.99];
    view2.frame = CGRectOffset(view2.frame, 618+75, 0);
    [UIView commitAnimations];
    
    ImagesViewController *aImagesViewController = [[ImagesViewController alloc] init];
    aImagesViewController.delegate = self;
    aImagesViewController.folder = foldername;
    aImagesViewController.ordermode = OrderMode;
    aImagesViewController.shufflemode = ShuffleMode;
    aImagesViewController.interactionmode = InteractionMode; 
    
    aImagesViewController.view.frame = view2.bounds;
    view2.autoresizesSubviews = YES; 
    [view2 addSubview:aImagesViewController.view];
    [self addChildViewController:aImagesViewController];
}
- (void)startordermode{
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(250, 1004, 268, 364)];
    view3.tag = 30;
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
    [UIView beginAnimations:@"SwitchToView1" context:nil];
    [UIView setAnimationDuration:0.99];
    view3.frame = CGRectOffset(view3.frame, 0, -364);
    [UIView commitAnimations];
    

}

- (void)leaveordermode{
    
    [UIView animateWithDuration:0.99 animations:^
     {
         [self.view viewWithTag:30].frame = CGRectOffset(CGRectMake(250, 640, 268, 364), 0, 364);
         
     } completion:^(BOOL finished) 
     {
         
         if (finished) {
             [self quittokbox];
             [self.view viewWithTag:30].frame = CGRectMake(250, 1004, 268, 0); 
             [[self.view viewWithTag:30] removeFromSuperview];

         }
     }];
    
    
}

- (void)quittokbox{
//    NSLog(@"%d",_session.connectionCount);
////    [_session disconnect];
//    [_session unpublish:_publisher];
//    [_subscriber close];
//
//    _subscriber= nil;
//    _publisher = nil;
    self.PlayButton.enabled = YES;
    self.PlayButton.alpha = 1;

}

static bool io;

- (IBAction)StartSession:(id)sender {
//    _session = [[OTSession alloc] initWithSessionId:kSessionId
//                                           delegate:self];
//    
    if(!io){
//        if(_session){
//            [self doConnect];
//        }else {
////            _session = [[OTSession alloc] initWithSessionId:kSessionId
////                                                   delegate:self];
////            
//        }
        NSLog(@"ON");   
        self.PlayButton.enabled = NO;
        self.PlayButton.alpha = 0.5;
        self.PlayButton.selected = YES;
        io = TRUE;
        if(Sender){
            NSLog(@"Sender Mode");
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                if(Chatting){
                    NSLog(@"Initiate Sender Mode With Chatting");
                    [self initiatedropboxsession];
                }else {
                    NSLog(@"Cannot initiate");
                }
            }else{
                if(Chatting){
                    NSLog(@"Initiate Sender Mode With Chatting");
                    [self initiatedropboxsession];

                }
            }
        }
        if(receiver){
            NSLog(@"Receiver Mode");
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                if(Chatting){
                    NSLog(@"Initiate Receiver Mode With Chatting");
                    
                    if(OrderMode){
                        session = 0;
                        [self startordermode];
                        [self OrdermodeWithSession:session];
                    }
                    if(ShuffleMode){
                        session = arc4random()% [folders count];
                        [self startordermode];
                        [self OrdermodeWithSession:session];
                    }
                    if(InteractionMode){
                        [self startordermode];
                        if(folder){
                            for(int j = 0; j< [folders count]; j++){
                                if([folder isEqualToString: [folders objectAtIndex:j]]){
                                    session = j;
                                }
                            }
                            if(session){
                                [self OrdermodeWithSession:session];
                            }
                        }
                    }
                    self.PlayButton.enabled = YES;
                    self.PlayButton.alpha = 1;

//                    [self initiatedropboxsessionwithreceiverwithchatting];
                }else {
                    NSLog(@"Initiate Receiver Mode Without Chatting");
                    if(OrderMode){
                        session = 0;
                        [self OrdermodeWithSession:session];
                    }
                    if(ShuffleMode){
                        session = arc4random()% [folders count];
                        [self OrdermodeWithSession:session];
                    }else {
                        NSLog(@"No interaction mode without chatting");
                    }
                
//                    [self initiatedropboxsessionwithreceiver];
                }
            }else {
                
            }
        }
    }else {
        NSLog(@"OFF");
        self.PlayButton.enabled = NO;
        self.PlayButton.alpha = 0.5;

            
        if(Sender){
            if(Chatting){
                [self canceldropboxsession];
            }
        }
        if(receiver){
            NSLog(@"Receiver Mode");
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                if(Chatting){
                    
                    if(OrderMode){
                        [self leaveOrdermodeSessionFinal: YES];
                    }
                    if(ShuffleMode){
                        [self leaveOrdermodeSessionFinal: YES];
                    }
                    if(InteractionMode){
                        [self leaveOrdermodeSessionFinal: YES];
                    }
                    [self leaveordermode];
                }else {
                    [self canceldropboxsessionwithreceiver];
                }
            }else {
                
            }
        }
        self.PlayButton.selected = NO;
        io = FALSE;
        
    }
}



- (void)handleShowImagesbuttonpressed: (id)sender{
    
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Select Images"]){
        Displayimages = 2;
        tableview.scrollEnabled = TRUE;
        urlarray = [[NSMutableArray alloc] init]; 
        
        [tableview beginUpdates];
        NSArray *indexPathsToInsert = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0], [NSIndexPath indexPathForRow:3 inSection:0], nil];
        [tableview deleteRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationRight];
        [tableview endUpdates];
        [tableview reloadData];
        
    }
    if([urlarray count] ==4){
        int i=0;
        for(NSURL *url in urlarray){
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:url resultBlock:^(ALAsset *asset){
                UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                //UIImage *smaller = [SQL imageWithImage:copyOfOriginalImage scaledToSize:CGSizeMake(copyOfOriginalImage.size.width, copyOfOriginalImage.size.height)];
                NSData *imageData = UIImageJPEGRepresentation(copyOfOriginalImage, 0.1);
                NSString *filename = [[NSString alloc] initWithFormat:@"%d", i];
                NSString *returnString = [SQL UploadImageWithData:imageData andfileName:filename];
                NSArray *array = [returnString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                NSLog(@"%@",[array objectAtIndex:0]);
                
                BOOL uploadsucces = [SQL UpdateImageUserName:username andnumber:filename andURL:[array objectAtIndex:0]];
                if(uploadsucces){
                    NSLog(@"success");
                }else {
                    NSLog(@"something is wrong");
                };
                
            }failureBlock:^(NSError *error){
                // error handling
            }];
            i++;
        }
        if(i == 4){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Success!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            Displayimages = 0;
            [self Displayimages];
            //urlarray = [[NSMutableArray alloc] init];
            [self SQLlogchecking];
        }else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Something went wrong!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }else {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //[self presentModalViewController:picker animated:YES];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            if(![self.popoverController_ isPopoverVisible]){
                
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
                self.popoverController_ = popover;
                self.popoverController_.delegate = self; 
                [popover presentPopoverFromRect:CGRectMake(self.view.frame.size.width*2/6, -self.view.frame.size.height/2.+400, 400.0, 400.0) 
                                         inView:self.view
                       permittedArrowDirections:0
                                       animated:YES];
                
                //            [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                [self.popoverController_ dismissPopoverAnimated:YES];
                
            }
        }else {
            [self presentModalViewController:picker animated:YES];
        }
    }
}

@end
