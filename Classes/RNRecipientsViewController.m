//
//  RNRecipientsViewController.m
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import "RNRecipientsViewController.h"
#import "RNCore.h"

@interface RNRecipientsViewController ()

@end

@implementation RNRecipientsViewController

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
	// Do any additional setup after loading the view.
    
    self.inputEMailField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[[RNCore core] queuedRecipients] count] == 0) {
        [self.inputEMailField becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [[[RNCore core] queuedRecipients] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecipientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...    
    cell.textLabel.text = [NSString stringWithString:[[[RNCore core] queuedRecipients] objectAtIndex:indexPath.row]];
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Text field delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    NSString *inputEMail = self.inputEMailField.text;
    
    if (inputEMail != nil && ![inputEMail isEqualToString:@""]) {       
        [[RNCore core] addRecipientToQueue:inputEMail];
             
        [self.recipientsTableView reloadData];        
        self.inputEMailField.text = @"";
        
        [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [NSString stringWithFormat:@"%i", [[[RNCore core] queuedRecipients] count]];
        
    } else {
        
        NSLog(@"newCompName is blank");
    }
    
    return YES;
}

// Disallow any characters
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"#"]) {
        return NO;
    }
    else {
        return YES;
    }
}

// Clears field when 'x' is pressed
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)sendButtonPressed:(id)sender {
    
    [self openMailView];
    
}

#pragma mark - E-mail

- (void)openMailView{
    
//    NSString *photoTitle = [numberItem valueForKey:NameKey];
    
    NSString *eMailBody = [[RNCore core] defaultEMailBody];
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
	[mailViewController setSubject:@"Reactify E-Business Card"];
    
    [mailViewController addAttachmentData:[NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"bcard-bg-yuli"])] mimeType:@"png" fileName:@"Yuli Levtov.png"];
    
    [mailViewController setMessageBody:eMailBody isHTML:YES];
    
    [mailViewController setBccRecipients:[[RNCore core] queuedRecipients]];
    
	mailViewController.mailComposeDelegate = self;
	
    mailViewController.modalPresentationStyle = UIModalPresentationPageSheet;

    NSData *vcfData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Yuli Levtov" ofType:@"vcf"]];
    
    [mailViewController addAttachmentData:vcfData mimeType:@"text/x-vcard" fileName:@"Yuli Levtov.vcf"];
    
	[self presentViewController:mailViewController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
    [self dismissViewControllerAnimated:YES completion:nil];
	
	switch (result) {
		case MFMailComposeResultSent:
            NSLog(@"PHOTO SENT SUCCESSFULLY");
            [[RNCore core] saveSentRecipients];
            [self.recipientsTableView reloadData];            
            [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [NSString stringWithFormat:@"%i", [[[RNCore core] queuedRecipients] count]];
            break;
		case MFMailComposeResultFailed:
            NSLog(@"PHOTO SENDING FAILED");
            [[RNCore core] saveSentRecipients];
            [self.recipientsTableView reloadData];
            [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [NSString stringWithFormat:@"%i", [[[RNCore core] queuedRecipients] count]];
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"PHOTO SENDING CANCELLED");
            [[RNCore core] saveSentRecipients];
            [self.recipientsTableView reloadData];
            [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [NSString stringWithFormat:@"%i", [[[RNCore core] queuedRecipients] count]];
            break;
		case MFMailComposeResultSaved:
            NSLog(@"PHOTO DRAFT SAVED");
            break;
		default:
            NSLog(@"PHOTO SENDING CANCELLED");
			break;
	}
}

@end
