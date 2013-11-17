//
//  RNSettingsViewController.m
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import "RNSettingsViewController.h"
#import "RNCore.h"

@interface RNSettingsViewController ()

@end

@implementation RNSettingsViewController

@synthesize projects, projectsDict;

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
    if ([[RNCore core] defaultEventName]) {
        self.eventNameField.text = [[RNCore core] defaultEventName];
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
    return [self.projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DefaultProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    projectsDict = [projects objectAtIndex: indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [projectsDict objectForKey:@"Title"]];
    
    UISwitch *projectSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    BOOL defaultBool = [[projectsDict objectForKey:@"Default"] boolValue];
    NSLog(@"Project title and default: %@, %i", [projectsDict objectForKey:@"Title"], defaultBool);
    projectSwitch.on = defaultBool;
    cell.accessoryView = projectSwitch;
    cell.accessoryView.tag = 100+indexPath.row;
    
    [projectSwitch addTarget:self action:@selector(didChangeProjectDefaultStatus:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (void)didChangeProjectDefaultStatus:(id)sender {
    
    NSLog(@"Changed default for project on row %i to %i", [sender tag], [sender isOn]);
    
    NSMutableArray *defaultBools = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.projects count]; i++) {
        projectsDict = [projects objectAtIndex: i];
        if (i == [sender tag]-100) {
            [defaultBools addObject:[NSNumber numberWithBool:[sender isOn]]];
        }else{
            [defaultBools addObject:[NSNumber numberWithBool:[[projectsDict objectForKey:@"Default"] boolValue]]];
        }
    };
    
    NSLog(@"Default bools = %@", defaultBools);
    
    [defaultBools writeToFile:[self dataFilePath] atomically:YES];
    
//    [[NSBundle mainBundle] pathForResource:@"Projects" ofType:@"plist"]];
}


- (NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"defaultProjects.plist"];
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
    
    [[RNCore core] setDefaultEventName:textField.text];
    
    return YES;
}

@end
