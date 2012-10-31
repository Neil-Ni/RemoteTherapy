//
//  OfflineImageViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 8/24/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "OfflineImageViewController.h"

@interface OfflineImageViewController (){
    
    int number_ofimages;
    NSMutableArray *photoPaths;
    NSMutableArray *array;
    int counter;
    int z; 
    UILabel *questionlabel;
    BOOL restartsignal;
    int tapcount;
    
}
- (void)setupimages;

@end

@implementation OfflineImageViewController
@synthesize CorrectAnswer, Category, isDemoMode, delegate, infos;

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
    z = 0; 
    counter = 0;
    tapcount = 0;
    for(UIImageView *view in [self.view subviews]){
        [view removeFromSuperview];
    }
    if(isDemoMode){
        number_ofimages = [infos count];
        [self setupimages];
    }

}

- (void)viewDidLoad
{
//    for(NSMutableDictionary *d in item){
//        NSString *question = [d objectForKey:@"question"]; 
//        NSString *folder = [d objectForKey:@"CategoryName"];
//        NSLog(@"%@",question);
//        NSLog(@"/%@", folder);
//        for (NSMutableDictionary *info in  [d objectForKey:@"imagesurl"]) {
//
    [super viewDidLoad];
    
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

- (void)FlipImage: (UITapGestureRecognizer *)sender{
    tapcount ++; 
    NSLog(@"%d", sender.view.tag);
    NSLog(@"%@", [infos objectAtIndex:sender.view.tag]);
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
                        answer.text = [[infos objectAtIndex:sender.view.tag] objectForKey:@"Image_Name"] ;
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
    int tmp_count = [infos count];
    if(number_ofimages != tmp_count){
        //warning please refresh or restart the session
    }
    if(tmp_count == 1){
        
        NSMutableDictionary *info = [infos objectAtIndex:0];
        UIImage *img  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.backgroundColor = [UIColor blackColor];
        view.frame = CGRectMake(186, 65, 250, 375);
        view.tag = 0;
        NSLog(@"%@",info);

        [self.view addSubview:view];
    }
    if(tmp_count == 2){
        NSMutableDictionary *info = [infos objectAtIndex:0];
        UIImage *img  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 65, 250, 375);
        
        
        info = [infos objectAtIndex:1];
        UIImage *img2  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(348, 65, 250, 375);
        view.tag = 0;
        view2.tag = 1;
        
        [self.view addSubview:view];
        [self.view addSubview:view2];
    }
    if(tmp_count == 3){
        NSMutableDictionary *info = [infos objectAtIndex:0];
        UIImage *img  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(1, 103, 200, 300);
        
        info = [infos objectAtIndex:1];
        UIImage *img2  = [info objectForKey:UIImagePickerControllerOriginalImage]; 

        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(210, 103, 200, 300);
        
        info = [infos objectAtIndex:2];
        UIImage *img3  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
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
        NSMutableDictionary *info = [infos objectAtIndex:0];
        UIImage *img  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(121, 20, 150, 225);
        
        info = [infos objectAtIndex:1];
        UIImage *img2  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(347, 20, 150, 225);
        
        info = [infos objectAtIndex:2];
        UIImage *img3  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(121, 261, 150, 225);
        
        info = [infos objectAtIndex:3];
        UIImage *img4  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
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
        NSMutableDictionary *info = [infos objectAtIndex:0];
        UIImage *img  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 20, 150, 225);
        
        info = [infos objectAtIndex:1];
        UIImage *img2  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(234, 20, 150, 225);
        
        info = [infos objectAtIndex:2];
        UIImage *img3  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(448, 20, 150, 225);
        
        info = [infos objectAtIndex:3];
        UIImage *img4  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view4 = [[UIImageView alloc] initWithImage:img4];
        view4.frame = CGRectMake(121, 261, 150, 225);
        
        info = [infos objectAtIndex:4];
        UIImage *img5  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
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
        NSMutableDictionary *info = [infos objectAtIndex:0];
        UIImage *img  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 20, 150, 225);
        
        info = [infos objectAtIndex:1];
        UIImage *img2  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(234, 20, 150, 225);
        
        info = [infos objectAtIndex:2];
        UIImage *img3  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(448, 20, 150, 225);
        
        info = [infos objectAtIndex:3];
        UIImage *img4  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view4 = [[UIImageView alloc] initWithImage:img4];
        view4.frame = CGRectMake(20, 261, 150, 225);
        
        info = [infos objectAtIndex:4];
        UIImage *img5  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view5 = [[UIImageView alloc] initWithImage:img5];
        view5.frame = CGRectMake(234, 261, 150, 225);
        
        info = [infos objectAtIndex:5];
        UIImage *img6  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
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
        NSMutableDictionary *info = [infos objectAtIndex:0];
        UIImage *img  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 40, 130, 195);
        
        info = [infos objectAtIndex:1];
        UIImage *img2  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(170, 40, 130, 195);
        
        info = [infos objectAtIndex:2];
        UIImage *img3  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(320, 40, 130, 195);
        
        info = [infos objectAtIndex:3];
        UIImage *img4  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view4 = [[UIImageView alloc] initWithImage:img4];
        view4.frame = CGRectMake(468, 40, 130, 195);
        
        info = [infos objectAtIndex:4];
        UIImage *img5  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view5 = [[UIImageView alloc] initWithImage:img5];
        view5.frame = CGRectMake(94, 262, 130, 195);
        
        info = [infos objectAtIndex:5];
        UIImage *img6  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view6 = [[UIImageView alloc] initWithImage:img6];
        view6.frame = CGRectMake(244, 262, 130, 195);
        
        info = [infos objectAtIndex:6];
        UIImage *img7  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
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
        NSMutableDictionary *info = [infos objectAtIndex:0];
        UIImage *img  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(20, 40, 130, 195);
        
        info = [infos objectAtIndex:1];
        UIImage *img2  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view2 = [[UIImageView alloc] initWithImage:img2];
        view2.frame = CGRectMake(170, 40, 130, 195);
        
        info = [infos objectAtIndex:2];
        UIImage *img3  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view3 = [[UIImageView alloc] initWithImage:img3];
        view3.frame = CGRectMake(320, 40, 130, 195);
        
        info = [infos objectAtIndex:3];
        UIImage *img4  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view4 = [[UIImageView alloc] initWithImage:img4];
        view4.frame = CGRectMake(468, 40, 130, 195);
        
        info = [infos objectAtIndex:4];
        UIImage *img5  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view5 = [[UIImageView alloc] initWithImage:img5];
        view5.frame = CGRectMake(20, 262, 130, 195);
        
        info = [infos objectAtIndex:5];
        UIImage *img6  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view6 = [[UIImageView alloc] initWithImage:img6];
        view6.frame = CGRectMake(170, 262, 130, 195);
        
        info = [infos objectAtIndex:6];
        UIImage *img7  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        UIImageView *view7 = [[UIImageView alloc] initWithImage:img7];
        view7.frame = CGRectMake(320, 262, 130, 195);
        
        info = [infos objectAtIndex:7];
        UIImage *img8  = [info objectForKey:UIImagePickerControllerOriginalImage]; 
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

@end
