//
//  MainAppViewController.h
//  SQL
//
//  Created by Tzu-Yang Ni on 6/27/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Opentok/Opentok.h>

@class DBRestClient;

@interface MainAppViewController : UIViewController <UIImagePickerControllerDelegate , UINavigationControllerDelegate, UIScrollViewDelegate, OTSessionDelegate, OTSubscriberDelegate, OTPublisherDelegate, UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    UIPopoverController *popoverController_;
    int Image_counter;
    NSString *username;
    BOOL Sender;
    BOOL receiver;
    int Displayimages;
    NSMutableArray *urlarray;
    UIActivityIndicatorView *spinner;
    UIScrollView *ScrollView;
    UITableView *tableview;
    
    NSMutableArray *log;
    NSTimer *timer;
    NSMutableArray *removeindex;
    UIButton *confirm;
    int tappednumber;
    BOOL Chatting;
    OTSession* _session;
    OTPublisher* _publisher;    
    OTSubscriber* _subscriber;
    
    DBRestClient* restClient;
    
    IBOutlet UILabel *QuestionLabel;
}
@property (nonatomic, strong) UIPopoverController *popoverController_;
@property (strong, nonatomic) IBOutlet UIButton *PlayButton;
@property (strong, nonatomic) IBOutlet UIButton *UserProfile;
@property (strong, nonatomic) IBOutlet UIButton *Documents;
@property (strong, nonatomic) IBOutlet UIButton *DropBo;


- (IBAction)GoBack:(id)sender;
- (IBAction)StartSession:(id)sender;
- (IBAction)ShowUserProfile:(id)sender;
- (IBAction)ShowDocuments:(id)sender;
- (IBAction)ShowDropBo:(id)sender;

@end
