//
//  ImagesViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 7/31/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "ImagesViewController.h"
#import <DropboxSDK/DropboxSDK.h>


#define Max_Pics_row 4
#define Max_Width 100
#define Max_Height 150


@class DBRestClient;

@interface ImagesViewController () <DBSessionDelegate>{
    UIActivityIndicatorView *spiner;
    DBRestClient *restClient;
    int number_ofimages;
    NSMutableArray *photoPaths;
    NSMutableArray *array;
    int counter;
    int z; 
    UILabel *questionlabel;
    BOOL restartsignal;
    int tapcount;
}

@end

@implementation ImagesViewController
@synthesize delegate,ordermode,shufflemode,interactionmode,folder;

#pragma mark -DropBoxViewController delegate


- (void)addItemViewController:(DropBoxViewController *)controller didFinishEnteringItem:(NSString *)item
{
    z = 0; 
    counter = 0;
    for(UIImageView *view in [self.view subviews]){
        [view removeFromSuperview];
    }
    NSLog(@"didFinishEnteringItem");
    NSLog(@"%@", item);
    NSString *dir = [[NSString alloc] initWithFormat:@"/%@/", item];
    [[self restClient] loadMetadata:dir];
    
    spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:spiner];
    CGRect spinnerFrame = spiner.frame; 
    spinnerFrame.origin.x = (self.view.bounds.size.width - spinnerFrame.size.width) / 2.0; 
    spinnerFrame.origin.y = (self.view.bounds.size.height - spinnerFrame.size.height) / 2.0; 
    NSLog(@"%@",NSStringFromCGRect(spinnerFrame));   
    
    spiner.frame = spinnerFrame;
    [spiner startAnimating];   


}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));   
    if(ordermode || shufflemode || interactionmode){
        z = 0; 
        counter = 0;
        tapcount = 0;
        for(UIImageView *view in [self.view subviews]){
            [view removeFromSuperview];
        }
        NSLog(@"didFinishEnteringItem");
        NSString *dir = [[NSString alloc] initWithFormat:@"/%@/", folder];
        [[self restClient] loadMetadata:dir];
        
        spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:spiner];
        CGRect spinnerFrame = spiner.frame; 
        spinnerFrame.origin.x = (self.view.bounds.size.width - spinnerFrame.size.width) / 2.0; 
        spinnerFrame.origin.y = (self.view.bounds.size.height - spinnerFrame.size.height) / 2.0; 
        NSLog(@"%@",NSStringFromCGRect(spinnerFrame));   
        
        spiner.frame = spinnerFrame;
        [spiner startAnimating];   
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
//    self.view = view;
//    delegate = self;
	// Do any additional setup after loading the view.

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSString*)tmp_photoPath {
    NSString *filename = [[NSString alloc] initWithFormat:@"photo%d.jpg", z];
    z++; 
    return [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
}

#pragma mark DBRestClientDelegate methods


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    photoPaths = [[NSMutableArray alloc] init];
    array = [[NSMutableArray alloc] init];
//    questionlabel = [[UILabel alloc] initWithFrame:CGRectMake(91, -133, 536, 133)];
//    questionlabel.textAlignment = UITextAlignmentCenter;
//    questionlabel.font = [UIFont systemFontOfSize:30];
//    questionlabel.textColor = [UIColor whiteColor];
    NSString *question;
    if (metadata.isDirectory) {
        number_ofimages = [metadata.contents count];
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
            NSString *path = [self tmp_photoPath];
            NSArray *strsplit = [file.filename componentsSeparatedByString:@"?"];
            NSString *Filename = [[strsplit objectAtIndex:1] stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
            question = [strsplit objectAtIndex:0];
            [array addObject:Filename];
            [photoPaths addObject:path];
            [self.restClient loadThumbnail:file.path ofSize:@"iphone_bestfit" intoPath:path];
        
        }
    }
    if(question){
        NSString *item = [[NSString alloc] initWithFormat:@"%@?",[question stringByReplacingOccurrencesOfString:@"_" withString:@" "]]; 
        [self.delegate addItem:self didFinishEnteringItem:item];
    }

//    NSLog(@"%@?",[question stringByReplacingOccurrencesOfString:@"_" withString:@" "]);
//    questionlabel.text = question;
}

- (void)FlipImage: (UITapGestureRecognizer *)sender{
    tapcount ++; 
    NSLog(@"%d", sender.view.tag);
    NSLog(@"%@", [array objectAtIndex:sender.view.tag]);
    UIImageView *view = (UIImageView *)sender.view; 
    float x = view.frame.origin.x;
    float y = view.frame.origin.y+view.frame.size.height/2.-15;
    float width = view.frame.size.width;
    float height = 60;
    UILabel *answer = [[UILabel alloc] initWithFrame:CGRectMake(x,y,width,height)];
    answer.textAlignment = UITextAlignmentCenter;
//    answer.text = [UIFont ]
    answer.textColor = [UIColor whiteColor];
    answer.tag = sender.view.tag*10; 
    answer.backgroundColor = [UIColor clearColor];
    [UIView transitionWithView:view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^(void) {
                        view.image = nil;
                    }
                    completion:^(BOOL finished) {
                        view.userInteractionEnabled = FALSE;
                        answer.text = [array objectAtIndex:sender.view.tag];
                        [self.view addSubview:answer];
                    }];
    //
//    if(view.image == nil){
//        [UIView transitionWithView:view
//                          duration:0.5f
//                           options:UIViewAnimationOptionTransitionCurlDown
//                        animations:^(void) {
//                            view.image = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:sender.view.tag]];
//;
//                        }
//                        completion:^(BOOL finished) {
//                            [[self.view viewWithTag:sender.view.tag*10] removeFromSuperview];
//                        }];
//
//    }
    if(tapcount == [photoPaths count]){
        [self.delegate nextsession:self];
    }
}
- (void)setupimages{
    int tmp_count = [photoPaths count];
    if(number_ofimages != tmp_count){
        //warning please refresh or restart the session
    }
    if(tmp_count == 1){
        UIImage *img  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:0]]; 
        NSLog(@"%@",[photoPaths objectAtIndex:0]); 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(186, 65, 250, 375);
        view.tag = 0;

        [self.view addSubview:view];
    }
    if(tmp_count == 2){
        UIImage *img  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:0]]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 65, 250, 375);
        
        UIImage *img2  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:1]]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(348, 65, 250, 375);
        view.tag = 0;
        view2.tag = 1;

        [self.view addSubview:view];
        [self.view addSubview:view2];
    }
    if(tmp_count == 3){
        UIImage *img  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:0]]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(1, 103, 200, 300);
        
        UIImage *img2  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:1]]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(210, 103, 200, 300);
        
        UIImage *img3  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:2]]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(418, 103, 200, 300);
        view.tag = 0;
        view2.tag = 1;
        view3.tag = 2;

        [self.view addSubview:view];
        [self.view addSubview:view2];
        [self.view addSubview:view3];
    }
    if(tmp_count == 4){
        UIImage *img  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:0]]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(121, 20, 150, 225);
        
        UIImage *img2  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:1]]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(347, 20, 150, 225);
        
        UIImage *img3  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:2]]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(121, 261, 150, 225);
        
        UIImage *img4  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:3]]; 
        UIImageView *view4 = [[UIImageView alloc] initWithImage:img4];
        view4.frame = CGRectMake(347, 261, 150, 225);
        view.tag = 0;
        view2.tag = 1;
        view3.tag = 2;
        view4.tag = 3;

        [self.view addSubview:view];
        [self.view addSubview:view2];
        [self.view addSubview:view3];
        [self.view addSubview:view4];
    }
    
    if(tmp_count == 5){
        UIImage *img  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:0]]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 20, 150, 225);
        
        UIImage *img2  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:1]]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(234, 20, 150, 225);

        UIImage *img3  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:2]]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(448, 20, 150, 225);

        UIImage *img4  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:3]]; 
        UIImageView *view4 = [[UIImageView alloc] initWithImage:img4];
        view4.frame = CGRectMake(121, 261, 150, 225);
        
        UIImage *img5  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:4]]; 
        UIImageView *view5 = [[UIImageView alloc] initWithImage:img5];
        view5.frame = CGRectMake(347, 261, 150, 225);
        view.tag = 0;
        view2.tag = 1;
        view3.tag = 2;
        view4.tag = 3;
        view5.tag = 4;
     
        [self.view addSubview:view];
        [self.view addSubview:view2];
        [self.view addSubview:view3];
        [self.view addSubview:view4];
        [self.view addSubview:view5];
    }
    
    if(tmp_count == 6){
        UIImage *img  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:0]]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 20, 150, 225);
        
        UIImage *img2  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:1]]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(234, 20, 150, 225);
        
        UIImage *img3  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:2]]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(448, 20, 150, 225);
        
        UIImage *img4  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:3]]; 
        UIImageView *view4 = [[UIImageView alloc] initWithImage:img4];
        view4.frame = CGRectMake(20, 261, 150, 225);
        
        UIImage *img5  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:4]]; 
        UIImageView *view5 = [[UIImageView alloc] initWithImage:img5];
        view5.frame = CGRectMake(234, 261, 150, 225);

        UIImage *img6  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:5]]; 
        UIImageView *view6 = [[UIImageView alloc] initWithImage:img6];
        view6.frame = CGRectMake(448, 261, 150, 225);
        view.tag = 0;
        view2.tag = 1;
        view3.tag = 2;
        view4.tag = 3;
        view5.tag = 4;
        view6.tag = 5;

        [self.view addSubview:view];
        [self.view addSubview:view2];
        [self.view addSubview:view3];
        [self.view addSubview:view4];
        [self.view addSubview:view5];
        [self.view addSubview:view6];
    }

    if(tmp_count == 7){
        UIImage *img  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:0]]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 40, 130, 195);
        
        UIImage *img2  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:1]]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(170, 40, 130, 195);
        
        UIImage *img3  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:2]]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(320, 40, 130, 195);
        
        UIImage *img4  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:3]]; 
        UIImageView *view4 = [[UIImageView alloc] initWithImage:img4];
        view4.frame = CGRectMake(468, 40, 130, 195);
        
        UIImage *img5  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:4]]; 
        UIImageView *view5 = [[UIImageView alloc] initWithImage:img5];
        view5.frame = CGRectMake(94, 262, 130, 195);
        
        UIImage *img6  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:5]]; 
        UIImageView *view6 = [[UIImageView alloc] initWithImage:img6];
        view6.frame = CGRectMake(244, 262, 130, 195);

        UIImage *img7  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:6]]; 
        UIImageView *view7 = [[UIImageView alloc] initWithImage:img7];
        view7.frame = CGRectMake(395, 262, 130, 195);

        view.tag = 0;
        view2.tag = 1;
        view3.tag = 2;
        view4.tag = 3;
        view5.tag = 4;
        view6.tag = 5;
        view7.tag = 6;

        
        [self.view addSubview:view];
        [self.view addSubview:view2];
        [self.view addSubview:view3];
        [self.view addSubview:view4];
        [self.view addSubview:view5];
        [self.view addSubview:view6];
        [self.view addSubview:view7];
    }
    
    
    if(tmp_count == 8){
        UIImage *img  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:0]]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 40, 130, 195);
        
        UIImage *img2  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:1]]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(170, 40, 130, 195);
        
        UIImage *img3  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:2]]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(320, 40, 130, 195);
        
        UIImage *img4  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:3]]; 
        UIImageView *view4 = [[UIImageView alloc] initWithImage:img4];
        view4.frame = CGRectMake(468, 40, 130, 195);
        
        UIImage *img5  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:4]]; 
        UIImageView *view5 = [[UIImageView alloc] initWithImage:img5];
        view5.frame = CGRectMake(20, 262, 130, 195);
        
        UIImage *img6  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:5]]; 
        UIImageView *view6 = [[UIImageView alloc] initWithImage:img6];
        view6.frame = CGRectMake(170, 262, 130, 195);
        
        UIImage *img7  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:6]]; 
        UIImageView *view7 = [[UIImageView alloc] initWithImage:img7];
        view7.frame = CGRectMake(320, 262, 130, 195);

        UIImage *img8  = [UIImage imageWithContentsOfFile:[photoPaths objectAtIndex:7]]; 
        UIImageView *view8 = [[UIImageView alloc] initWithImage:img8];
        view8.frame = CGRectMake(468, 262, 130, 195);

        view.tag = 0;
        view2.tag = 1;
        view3.tag = 2;
        view4.tag = 3;
        view5.tag = 4;
        view6.tag = 5;
        view7.tag = 6;
        view8.tag = 7;
        
        [self.view addSubview:view];
        [self.view addSubview:view2];
        [self.view addSubview:view3];
        [self.view addSubview:view4];
        [self.view addSubview:view5];
        [self.view addSubview:view6];
        [self.view addSubview:view7];
        [self.view addSubview:view8];
    }
    
    for(UIImageView *view in [self.view subviews]){
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FlipImage:)];
        [view addGestureRecognizer:tap];
    }
}
- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    NSLog(@"destPath %@", destPath);
    counter ++;
    if(counter == number_ofimages){
        [spiner stopAnimating];
        NSLog(@"%@",NSStringFromCGRect(self.view.frame));   
        [self setupimages];
        z = 0; 
        counter = 0;
    }
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
    NSLog(@"%@", error);
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}
@end
