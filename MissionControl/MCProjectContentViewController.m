//
//  MCProjectContentViewController.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCProjectContentViewController.h"
#import "MCProjects.h"

@interface MCProjectContentViewController ()

@end


@implementation MCProjectContentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    self.navigationItem.title = self.project[MCProjectNameKey];
    self.projectName.text = self.project[MCProjectNameKey];
    self.projectCreator.text = self.project[MCProjectCreatorKey];
}

@end
