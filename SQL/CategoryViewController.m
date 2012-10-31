//
//  CategoryViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 7/29/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "CategoryViewController.h"
#import "ShowDocumentsViewController.h"


@interface CategoryViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>{
    NSMutableArray *imagesurl;
    UIPopoverController *popoverController_;
}

@property (nonatomic, strong) UIPopoverController *popoverController_;

@end


@implementation CategoryViewController

@synthesize popoverController_, delegate, aCategoryName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        if([self.popoverController_ isPopoverVisible]){
            [self.popoverController_ dismissPopoverAnimated:YES];
        }
    }
    if(imagesurl){
        [aCategoryName setObject:imagesurl forKey:@"imagesurl"];
        [self.delegate addItemViewController:self didFinishEnteringItem:aCategoryName];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(aCategoryName){
        NSLog(@"aCategoryName true");
    }
    if([aCategoryName objectForKey:@"imagesurl"]){
        imagesurl = [aCategoryName objectForKey:@"imagesurl"];
    }else {
        imagesurl = [[NSMutableArray alloc] init];
    }
    self.tableView.userInteractionEnabled = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [imagesurl count]+1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Photos";
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  indexPath.row < [imagesurl count]? 150: 50; 
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  //  }
//    for(UIView *view in [cell.contentView subviews]){
//        [view removeFromSuperview];
//    }

//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0){
        if(indexPath.row < [imagesurl count]){
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CGRect frame;
            frame.origin.x = 10;
            frame.origin.y = 10;
            frame.size.height = 30;
            frame.size.width = cell.frame.size.width;
            
//            Categorytextfield = [[UITextField alloc ] initWithFrame:frame];
//            Categorytextfield.textAlignment = UITextAlignmentCenter;
//            Categorytextfield.text = @"";
//            Categorytextfield.returnKeyType  = UIReturnKeyDefault;
//            Categorytextfield.delegate = self;
//            Categ orytextfield.placeholder = @"Enter Category Name..";
//            [cell.contentView addSubview:Categorytextfield];
//            NSURL *url = [imagesurl objectAtIndex:indexPath.row];
//            NSLog(@"%@",url);
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//            [library assetForURL:url resultBlock:^(ALAsset *asset){
//                UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
//                cell.imageView.image = copyOfOriginalImage;
//            }failureBlock:^(NSError *error){
//                // error handling
//            }];            
            NSDictionary *info = [imagesurl objectAtIndex:indexPath.row];
            UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            cell.imageView.image = editedImage;
//            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = [info objectForKey:@"Image_Name"];
            cell.textLabel.font = [UIFont systemFontOfSize:30];
        }
        if(indexPath.row == [imagesurl count]){
            NSLog(@"%d", [imagesurl count]);
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = @"Add images...";
        }   
    }else {
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return indexPath.row < [imagesurl count]? YES: YES;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [imagesurl count]){
        return UITableViewCellEditingStyleInsert; 
    }
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [imagesurl removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            picker.modalInPopover = YES;
            picker.modalPresentationStyle = UIModalPresentationCurrentContext;
            
            if(![self.popoverController_ isPopoverVisible]){
                
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];            
                self.popoverController_ = popover;
                self.popoverController_.delegate = self; 
                self.popoverController_.passthroughViews = [NSArray arrayWithObjects:self.parentViewController.view, self.parentViewController.parentViewController.view, nil];
                //self.popoverController_.
                [self.popoverController_ presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:0 animated:YES];
                UITapGestureRecognizer *gestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                gestureRecogniser.numberOfTapsRequired = 1;
                [self.view addGestureRecognizer:gestureRecogniser];
                
            }else {
                picker = nil;
                [self.popoverController_ dismissPopoverAnimated:YES];
            }
        }else {
            [self presentModalViewController:picker animated:YES];
        }
    }   
}


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
- (void)handleTap:(UIGestureRecognizer*)tap {
    NSLog(@"tap"); 
    if([self.popoverController_ isPopoverVisible]){
        [self.popoverController_ dismissPopoverAnimated:YES];
        [self.view removeGestureRecognizer:tap];
    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == [imagesurl count]){
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                
                picker.modalInPopover = YES;
                picker.modalPresentationStyle = UIModalPresentationCurrentContext;

                if(![self.popoverController_ isPopoverVisible]){

                    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];            
                    self.popoverController_ = popover;
                    self.popoverController_.delegate = self; 
                    self.popoverController_.passthroughViews = [NSArray arrayWithObjects:self.parentViewController.view, self.parentViewController.parentViewController.view, nil];
                    //self.popoverController_.
                    [self.popoverController_ presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:0 animated:YES];
                    UITapGestureRecognizer *gestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                    gestureRecogniser.numberOfTapsRequired = 1;
                    [self.view addGestureRecognizer:gestureRecogniser];

                }else {
                    picker = nil;
                    [self.popoverController_ dismissPopoverAnimated:YES];
                }
            }else {
                [self presentModalViewController:picker animated:YES];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma - uipopover delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    [self changeSelectedButtonTect];
    [self.tableView reloadData];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"here");
//    [tableview removeFromSuperview];
//    [self.view addSubview: tableview];
//    [tableview reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma - uiimagepicker delegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    
//    //    NSString *destDir = @"/";
//    
//    //    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    //    
//    //    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset){
//    //        UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
//    //        NSData *imageData = UIImageJPEGRepresentation(copyOfOriginalImage, 0.1);
//    //
//    //    }failureBlock:^(NSError *error){
//    //        // error handling
//    //    }];
//    
//    //dropbox testing
//    //    NSString *path = @"http://asset/asset.PNG?id=3136E173-59EE-4DCD-A6CA-F7D8D79A464E&ext=PNG";
//    
//    //    [[self restClient] uploadFile:@"testing.png" toPath:destDir
//    //                  withParentRev:nil fromPath:path];
//    
//    NSString *destDir = @"/testing";
//    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"tmp_photo.png"];
//    
//    //extracting image from the picker and saving it
//    UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    NSData *webData = UIImagePNGRepresentation(editedImage);
//    [webData writeToFile:imagePath atomically:YES];
//    
//    //    [[self restClient] createFolder:@"testing"];
//    //    [[self restClient] uploadFile:@"testing.png" toPath:destDir
//    //                    withParentRev:nil fromPath:imagePath];
//    //    [[self restClient] loadMetadata:@"/"];
//    //    [[self restClient] loadMetadata:@"/testing"];
//    
//    //    [[self restClient] createFolder:@"testing2"];
//    
//    //    [[self restClient] deletePath:@"/testing/"];
//    //    [[self restClient] deletePath:@"/testing.png"];
//    

//    [self changeSelectedButtonTect];
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        if([urlarray count] == 4){
//            [tableview removeFromSuperview];
//            [self.view addSubview: tableview];
//            [tableview reloadData];
//            [picker dismissViewControllerAnimated:YES completion:^(){
//            }];
//        }
//        
//    }else {
//        if([urlarray count] == 4){
//            [tableview removeFromSuperview];
//            [self.view addSubview: tableview];
//            [tableview reloadData];
//            [self.popoverController_ dismissPopoverAnimated:YES];
//        }
//    }
//    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Image" message:@"Enter Image name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [imagesurl addObject:info];
//    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:imagesurl.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

}


#pragma mark - Text Field delegate


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString* ImageName = [[alertView textFieldAtIndex:0] text];
    
    for (NSMutableDictionary *dic in imagesurl) {
        if ([[dic objectForKey:@"Image_Name"] isEqualToString:ImageName]){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Image Name Already Exists" message:@"Enter Another Image Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            return;
        }
    }

    if (buttonIndex == alertView.cancelButtonIndex || [ImageName isEqualToString:@""]) {
        [imagesurl removeLastObject];
        return;
    }else {
        [[imagesurl lastObject] setObject:ImageName forKey:@"Image_Name"];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:imagesurl.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
@end
