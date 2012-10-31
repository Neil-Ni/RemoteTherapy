//
//  OfflineShowDocumentsViewControllerViewController.m
//  SQL
//
//  Created by Tzu-Yang Ni on 8/24/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "OfflineShowDocumentsViewControllerViewController.h"
#import "CategoryViewController.h"

@interface OfflineShowDocumentsViewControllerViewController () <CategoryViewControllerdelegate> {
    NSString *new_title;
    NSMutableArray *Titles;
    NSMutableDictionary *aCategory;
}


@end

@implementation OfflineShowDocumentsViewControllerViewController

@synthesize delegate, isDemoMode;

static bool Category;

#pragma mark -CategoryViewController delegate

- (void)addItemViewController:(CategoryViewController *)controller didFinishEnteringItem:(NSMutableDictionary *)item
{
    int i = 0;
    for(i = 0; i< [Titles count]; i++){
        NSMutableDictionary *d = [Titles objectAtIndex:i];
        if([[d objectForKey:@"CategoryName"] isEqualToString:[item objectForKey:@"CategoryName"]]){
            NSLog(@"Same dictionary found");
            [Titles removeObjectAtIndex:i];
            [Titles insertObject:item atIndex:i];
            [self.tableView reloadData];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated{
    
    self.title = @"Category Manager";
    Category = TRUE;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[self restClient] createFolder:@"testing"];
    
    self.navigationController.title = @"Categories";
    
    if (!Titles) {
        Titles = [[NSMutableArray alloc] init];
    }
    if (!aCategory) {
        aCategory = [[NSMutableDictionary alloc] init];
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem = Back;
    };
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem = Back;
    };
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    if(isDemoMode){
        
    }
}

-(void)addrow{
    [self.tableView reloadData];
}
//confirm and upload

- (void)goBack{
    
    [self.delegate addItemViewController:self didFinishEnteringItem:Titles];
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    new_title = nil;
    Titles = nil;
    aCategory = nil;
    
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
    return [Titles count]+1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Categories";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"Once the confirm button is pressed, all photos will automatically be saved.";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //  }
    if(indexPath.row < [Titles count]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = [[Titles objectAtIndex:indexPath.row] objectForKey:@"CategoryName"];
    }else {
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"Add New Category...";
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [Titles count]){
        return UITableViewCellEditingStyleInsert; 
    }
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


//-(void) showMyActionSheet
//{
//    sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Profile", @"Edit Photos", nil]; 
//    [sheet showInView:self.view];
//
//}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [Titles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        Category = TRUE;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Category" message:@"Enter Category name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        
        
        //
        //        CategoryViewController *aCategoryViewController = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
        //        aCategoryViewController.callbackview = self;
        //        [self.navigationController pushViewController:aCategoryViewController animated:YES];
        //        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if(indexPath.row == [Titles count]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Category" message:@"Enter  Category name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        
    }else {
        CategoryViewController *aCategoryViewController = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
        aCategoryViewController.title = [[Titles objectAtIndex:indexPath.row] objectForKey:@"CategoryName"];
        aCategoryViewController.delegate = self;
        aCategoryViewController.aCategoryName = aCategory; 
        [self.navigationController pushViewController:aCategoryViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSString* CategoryName = [[alertView textFieldAtIndex:0] text];
    
    if(Category){
        for (NSMutableDictionary *dic in Titles) {
            if ([[dic objectForKey:@"CategoryName"] isEqualToString:CategoryName]){
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Category Name Already Exists" message:@"Enter Another Category Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
                return;
            }
        }
        
        if (buttonIndex == alertView.cancelButtonIndex || [CategoryName isEqualToString:@""]) {
            return;
            
        }else {
            aCategory = [[NSMutableDictionary alloc] init];
            [aCategory setObject:CategoryName forKey:@"CategoryName"];
            //            [Titles addObject:aCategory];
            //            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:Titles.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            Category = FALSE;
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:@"Category Question" message:@"Enter Category question" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
            alert2.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert2 show];
            
        }
    }else {
        if (buttonIndex == alertView.cancelButtonIndex || [CategoryName isEqualToString:@""]) {
            return;
            
        }else {
            NSRange textRange;
            textRange =[CategoryName rangeOfString:@"?"];
            if(textRange.location != NSNotFound)
            {            
                [aCategory setObject:CategoryName forKey:@"question"];
                [Titles addObject:aCategory];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:Titles.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
            }else {
                NSString *question = [[NSString alloc] initWithFormat:@"%@?",CategoryName];
                [aCategory setObject:question forKey:@"question"];
                [Titles addObject:aCategory];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:Titles.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }            
        }
    }
}

@end
