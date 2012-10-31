//
//  DropboxImagesViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 7/30/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "DropboxImagesViewController.h"
#import <DropboxSDK/DropboxSDK.h>
@class DBRestClient;

@interface DropboxImagesViewController () <DBRestClientDelegate> {
    DBRestClient* restClient;
    UIActivityIndicatorView *spiner;
    NSMutableArray  *photoPaths;
    NSIndexPath *tmp_path;
    NSMutableArray  *images;
    int j;
    int z;
}

@end

@implementation DropboxImagesViewController
@synthesize folder;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    if(!photoPaths){
        photoPaths = [[NSMutableArray alloc] init];
        images = [[NSMutableArray alloc] init];
        j = 0;
        z = 0; 
        NSString *dir = [[NSString alloc] initWithFormat:@"/%@", self.title];
        [[self restClient] loadMetadata:dir];
        
        spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spiner startAnimating];
        [self.view addSubview:spiner];
        CGRect spinnerFrame = spiner.frame; 
        spinnerFrame.origin.x = (self.view.bounds.size.width - spinnerFrame.size.width) / 2.0; 
        spinnerFrame.origin.y = (self.view.bounds.size.height - spinnerFrame.size.height) / 2.0; 
        spiner.frame = spinnerFrame;

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Photos";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[photoPaths count]);
    return [photoPaths count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  150; 
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Configure the cell...
    DBMetadata *file = [[photoPaths objectAtIndex:indexPath.row] objectForKey:@"DBMetadata"]; 
    tmp_path = indexPath;
    cell.textLabel.font = [UIFont systemFontOfSize:30];
    NSArray *strsplit = [file.filename componentsSeparatedByString:@"?"];
    cell.textLabel.text = [[strsplit objectAtIndex:1] stringByReplacingOccurrencesOfString:@".jpg" withString:@""];

    cell.imageView.image = [[photoPaths objectAtIndex:indexPath.row] objectForKey:@"Image"];
//    [self restClient:restClient loadedThumbnail:[photoPaths objectAtIndex:indexPath.row]];
    return cell;
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *Filename = [[[photoPaths objectAtIndex:indexPath.row] objectForKey:@"DBMetadata"] path];
        [[self restClient] deletePath:Filename];
        [photoPaths removeObjectAtIndex:indexPath.row];
        
        //    //    [[self restClient] deletePath:@"/testing/"];
        //    //    ;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (NSString*)tmp_photoPath {
    NSString *filename = [[NSString alloc] initWithFormat:@"photo%d.jpg", z];
    z++; 
    return [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
}

#pragma mark DBRestClientDelegate methods


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
//            [photoPaths addObject:file.path];
            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
            [info setObject:file forKey:@"DBMetadata"];
            [photoPaths addObject:info];
//            [self restClient:restClient loadedThumbnail:file.path];
            [self.restClient loadThumbnail:file.path ofSize:@"iphone_bestfit" intoPath:[self tmp_photoPath]];
            

        }
    }
    
//    NSMutableArray* newPhotoPaths = [NSMutableArray new];
//    for (DBMetadata* child in metadata.contents) {
//        NSString* extension = [[child.path pathExtension] lowercaseString];
//        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
//            [newPhotoPaths addObject:child.path];
//        }
//    }
//    photoPaths = newPhotoPaths;
    
    
}


- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    NSLog(@"%@", destPath);
    UIImage *img  = [UIImage imageWithContentsOfFile:destPath];
    
    [[photoPaths objectAtIndex:j] setObject:img forKey:@"Image"];
    j++;
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:tmp_path];
//    cell.imageView.image = [UIImage imageWithContentsOfFile:destPath];
//    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:tmp_path] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadData];
    NSLog(@"%d, %d", [photoPaths count], j); 
    if(j == [photoPaths count]){
        NSMutableArray *tmp_ar = [[NSMutableArray alloc] init];
        for (int i = 0; i < [photoPaths count]; i++ ){
            [tmp_ar addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView insertRowsAtIndexPaths:tmp_ar withRowAnimation:UITableViewRowAnimationFade];
        [spiner stopAnimating];
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
