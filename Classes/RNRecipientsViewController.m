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
    
    // observe keyboard hide and show notifications to resize the text view appropriately
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
//    if ([[[RNCore core] queuedRecipients] count] == 0) {
        [self.inputEMailField becomeFirstResponder];
//    }
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


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         NSString *cellStringToRemove = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
         [[RNCore core] removeRecipientFromQueue:cellStringToRemove];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Text field delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.inputAccessoryView == nil) {
        textField.inputAccessoryView = self.accessoryView;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [self addTextFieldTextToQueuedRecipients];
    
    return YES;
}

- (void)addTextFieldTextToQueuedRecipients {
    
    NSString *inputEMail = self.inputEMailField.text;
    
    if (inputEMail != nil && ![inputEMail isEqualToString:@""]) {
        [[RNCore core] addRecipientToQueue:inputEMail];
        
        [self.recipientsTableView reloadData];
        self.inputEMailField.text = @"";
        
        [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [NSString stringWithFormat:@"%i", [[[RNCore core] queuedRecipients] count]];
    } else {
        NSLog(@"newCompName is blank");
    }
}

#pragma mark - Accessory view action
- (IBAction)tappedMe:(id)sender {
    [self addTextFieldTextToQueuedRecipients];
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
            NSLog(@"EMAIL SENT SUCCESSFULLY");
            [[RNCore core] combineUnsavedAndSavedRecipients:YES];
            [self.recipientsTableView reloadData];            
            [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [NSString stringWithFormat:@"%i", [[[RNCore core] queuedRecipients] count]];
            break;
		case MFMailComposeResultFailed:
            NSLog(@"EMAIL SENDING FAILED");
            [self displayAlertWithError:error];
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"EMAIL SENDING CANCELLED");
            break;
		case MFMailComposeResultSaved:
            NSLog(@"EMAIL DRAFT SAVED");
            [[RNCore core] combineUnsavedAndSavedRecipients:YES];
            [self.recipientsTableView reloadData];
            [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [NSString stringWithFormat:@"%i", [[[RNCore core] queuedRecipients] count]];
            break;
		default:
            NSLog(@"EMAIL SENDING CANCELLED");
			break;
	}
}

-(void)displayAlertWithError:(NSError*)error {
    NSString *errorAsString = [NSString stringWithFormat:@"Error: %@", error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"E-mail Sending Failed"
                                                    message:errorAsString
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's
    // coordinate system. The bottom of the text view's frame should align with the top
    // of the keyboard's final position.
    //
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    [UIView commitAnimations];
}

@end
