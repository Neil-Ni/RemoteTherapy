//
//  DropBoxViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 7/30/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "DropBoxViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "DropboxImagesViewController.h"
#import "ImagesViewController.h"
#import "SQL.h"
#import "AppDelegate.h"

@class DBRestClient;

@interface DropBoxViewController () <DBRestClientDelegate>{
    DBRestClient* restClient;
    UIActivityIndicatorView *spiner;    
    BOOL folder;
    int folder_counter; 
    NSMutableArray *deleterows;
    NSString *username;
}

@end

@implementation DropBoxViewController
@synthesize folders, ChildView, Receiver, delegate;

- (void)checkfoldersarray{
    if([folders count] == 0){
        self.navigationItem.rightBarButtonItem = nil;
    }else {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
//    if(!folders){
        folder_counter = 0;
        folders = [[NSMutableArray alloc] init];
        folder = TRUE;
        [[self restClient] loadMetadata:@"/"];
        spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spiner startAnimating];
        [self.view addSubview:spiner];
        CGRect spinnerFrame = spiner.frame; 
        spinnerFrame.origin.x = (self.view.bounds.size.width - spinnerFrame.size.width) / 2.0; 
        spinnerFrame.origin.y = (self.view.bounds.size.height - spinnerFrame.size.height) / 2.0; 
        spiner.frame = spinnerFrame;
        [self.tableView reloadData];
        [self checkfoldersarray];
    
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        username = appDelegate.Username;

  //  }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"DropBox Folder";

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem = Back;
    };
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){

        UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem = Back;
    };

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)goBack{
    
    [self.parentViewController dismissModalViewControllerAnimated:YES];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [folders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (ChildView){
        if(Receiver){
            
        }else {
//              cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [folders objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ChildView? @"Available Categories" : @"Categories";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return ChildView? nil: @"The folder with no images will automatically be deleted.";
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(ChildView){
        NSLog(@"Do nothing");
    }else {        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSString *Filename = [[NSString alloc] initWithFormat:@"/%@/", [folders objectAtIndex:indexPath.row]];
            [[self restClient] deletePath:Filename];
            [folders removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }   
        else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(ChildView){
        if(Receiver){
            [self.delegate addItemViewController:self didFinishEnteringItem:[folders objectAtIndex:indexPath.row]];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else {
//            [self.delegate addItemViewController:self didFinishEnteringItem:[folders objectAtIndex:indexPath.row]];
            [SQL appendlog:username andResponse:1 andFolder:[folders objectAtIndex:indexPath.row]]; 
            NSLog(@"appending %@",[folders objectAtIndex:indexPath.row]);
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }else {
        DropboxImagesViewController *aDropboxImagesViewController = [[DropboxImagesViewController alloc] initWithStyle:UITableViewStyleGrouped];
        aDropboxImagesViewController.title = [folders objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:aDropboxImagesViewController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if(folder == TRUE){
        if (metadata.isDirectory) {
            NSLog(@"Folder '%@' contains:", metadata.path);
            for (DBMetadata *file in metadata.contents) {
                NSLog(@"\t%@", file.filename);
                [folders addObject:file.filename];
            }
        }
        NSMutableArray *tmp_ar = [[NSMutableArray alloc] init];
        for (int i = 0; i < [folders count]; i++ ){
            [tmp_ar addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView insertRowsAtIndexPaths:tmp_ar withRowAnimation:UITableViewRowAnimationFade];
        [spiner stopAnimating];
        folder = FALSE;
        int i = 0;
        for(i = 0; i< [folders count]; i ++){
            NSString *f = [[NSString alloc] initWithFormat:@"/%@/", [folders objectAtIndex:i]];
            [[self restClient] loadMetadata:f];
        }
        deleterows = [[NSMutableArray alloc] init];
        [self checkfoldersarray];

    }else {
        if (metadata.isDirectory) {
            if([metadata.contents count]==0){
                NSLog(@"%@ is empty", metadata.path);
                [deleterows addObject:[NSIndexPath indexPathForRow:folder_counter inSection:0]];
                NSString *f2 = [[NSString alloc] initWithFormat:@"%@/", metadata.path];
                [[self restClient] deletePath:f2];
            }
        }
        folder_counter++;
        if(folder_counter == [folders count]){
            int j;
            for(j = [deleterows count]-1; j > -1; j --){
                NSIndexPath *path = [deleterows objectAtIndex:j];
                [folders removeObjectAtIndex:path.row];
                NSLog(@"%d",path.row);
            }
            [self.tableView deleteRowsAtIndexPaths:deleterows withRowAnimation:UITableViewRowAnimationFade];
            [self checkfoldersarray];
        }
    }
    
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

@end
