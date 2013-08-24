//
//  RNSettingsViewController.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNSettingsViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *defaultProjectsTableView;
@property (weak, nonatomic) IBOutlet UITextField *eventNameField;
@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, strong) NSDictionary *projectsDict;
@property (nonatomic, strong) NSMutableArray *defaultBools;

@end
