//
//  MCProjectContentViewController.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCProjectContentViewController.h"
#import "MCWorkNode.h"

@interface MCProjectContentViewController ()

@end

@implementation MCProjectContentViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addWorkNode:(id)sender {
    MCWorkNode *theNode = [[MCWorkNode alloc] initWithPoint:self.view.center];
    [self.view addSubview:theNode];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message 1......\nMessage 2......" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
    
}

@end
