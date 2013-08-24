//
//  RNProjectsViewController.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNProjectsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *projectsTableView;
@property (nonatomic, strong) NSMutableArray *projects;

@end
