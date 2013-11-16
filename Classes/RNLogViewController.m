//
//  RNLog2ViewController.m
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import "RNLogViewController.h"
#import "RNPerson.h"
#import "RNCore.h"

@interface RNLogViewController ()

@end

@implementation RNLogViewController

@synthesize persons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
} 

- (void)viewWillAppear:(BOOL)animated {
    [self.logTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[RNCore core] savedRecipientsDict] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"LogCell"];
    
    NSDictionary *personDict = [[[RNCore core] savedRecipientsDict] objectForKey:[NSNumber numberWithInt:indexPath.row]];

    NSLog(@"Persondict = %@", personDict);
    
    NSString *eMail = [personDict objectForKey:@"email"];
    NSString *name = [personDict objectForKey:@"name"];
    NSString *meetingDate = [personDict objectForKey:@"meetingDate"];
    NSString *meetingPlace = [personDict objectForKey:@"meetingPlace"];
    
    NSLog(@"%i added already? %@", indexPath.row, [personDict objectForKey:@"added"]);
    
    if ([[personDict objectForKey:@"added"] integerValue] == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", eMail];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@", name];
    }
    
    if ([meetingPlace isEqualToString:@""]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", meetingDate];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@", meetingDate, meetingPlace];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    NSString *givenEMail = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    
    [self addPerson:givenEMail];
    
    indexOfPersonAdded = indexPath.row;
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void)addPerson:(NSString *)givenEMail {
    NSLog(@"%s, %@", __func__, givenEMail);
    
//    NSString *givenEMail = [self tableView:tableView cellForRowAtIndexPath:sender.row];
    
    ABRecordRef aRecord = ABPersonCreate();
    CFErrorRef anError = NULL;
    
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFStringRef)givenEMail, kABWorkLabel, NULL);
    ABRecordSetValue(aRecord, kABPersonEmailProperty, multiEmail, &anError);
    CFRelease(multiEmail);
    
    CFStringRef firstName, lastName;
    firstName = ABRecordCopyValue(aRecord, kABPersonFirstNameProperty);
    lastName  = ABRecordCopyValue(aRecord, kABPersonLastNameProperty);
    
    ABUnknownPersonViewController *view = [[ABUnknownPersonViewController alloc] init];
    
    view.unknownPersonViewDelegate = self;
    view.displayedPerson = aRecord; // Assume person is already defined.
    view.allowsAddingToAddressBook = YES;
    
    UINavigationController *newNavigationController = [[UINavigationController alloc]
                                                       initWithRootViewController:view];
    
    [self presentViewController:newNavigationController animated:YES completion:NULL];
}

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person {    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    NSLog(@"Did resolve to person: %@", name);
    
    [[RNCore core] addNameToRecipient:indexOfPersonAdded withName:name];

    [self.logTableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
