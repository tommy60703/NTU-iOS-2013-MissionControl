//
//  MCProjectContentViewController.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCProjectContentViewController.h"
#import "MCWorkNode.h"
#import "MCNodeInputViewController.h"

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
    [self pullFromServerProject];
    //self->seq = 0;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"addNode"]) {
        
        UINavigationController *destinationViewController = segue.destinationViewController;
        MCNodeInputViewController *destination = [destinationViewController viewControllers][0];
        destination.delegate = self;
        
        
//        MCNodeInputViewController *destinationViewController = segue.destinationViewController;
//        destinationViewController.delegate = self;
    }

    
}
- (IBAction)saveWorkFlow:(id)sender {
    
    for (UIView *subview in self.view.subviews) {
        if([subview isKindOfClass:[MCWorkNode class]]){
            MCWorkNode *finder = subview;
            NSLog(@"%d",finder.tag);

            [self pushToServerTask:finder.task Worker:finder.worker Prev:finder.previous Tag:finder.tag Status:false Location:finder.frame.origin];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)addWorkNode:(id)sender {
    
    
    
    
}


- (void)addNodeTask:(NSString *)task Worker:(NSString*)worker Previous:(NSString*)previous {
//    NSLog(@"%@", task);
//    NSLog(@"%@", worker);
//    NSLog(@"%@", previous);
    MCWorkNode *theNode = [[MCWorkNode alloc] initWithPoint:self.view.center Seq:seq Task:task Worker:worker Prev:previous];
    //[self.view isKindOfClass:[UIImageView class]];
    
    NSLog(@"%d", self->seq);
    self->seq++;
    
    [self.view addSubview:theNode];
}

- (void)pushToServerTask:(NSString *)task Worker:(NSString *)worker Prev:(NSString *)previous Tag:(int)tag Status:(bool)status Location:(CGPoint)point{
    bool flag = true;
    for (PFObject *node in self.WorkNodes) {
        //NSLog(@"tag = %d",tag);
        NSLog(@"%d",[[node objectForKey:@"seq"] integerValue] == tag);
        if ([[node objectForKey:@"seq"] integerValue] == tag) {
            NSLog(@"same");
            node[@"state"] = [NSNumber numberWithBool:status];
            node[@"location_x"] = [NSNumber numberWithDouble:point.x];
            node[@"location_y"] = [NSNumber numberWithDouble:point.y];
            [node saveInBackground];
            flag = false;
        }
 
    }
    if(flag){
    PFObject *projectContent = [PFObject objectWithClassName:[self.project[@"projectName"]stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
    projectContent[@"task"] = task;
    projectContent[@"worker"] = worker;
    projectContent[@"previous"] = previous;
    projectContent[@"seq"] = [NSNumber numberWithInt:tag];
    projectContent[@"state"] = [NSNumber numberWithBool:status];
    projectContent[@"location_x"] = [NSNumber numberWithDouble:point.x];
    projectContent[@"location_y"] = [NSNumber numberWithDouble:point.y];
    [projectContent saveInBackground];
    NSLog(@"here");
    }
}

- (void)pullFromServerProject{
    self.drawLine = [[MCDrawLine alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    [self.drawLine setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.drawLine];
    
    PFQuery *query = [PFQuery queryWithClassName:[self.project[@"projectName"] stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
    [query orderByAscending:@"seq"];
    int maxSeq = 0;
    self.WorkNodes = [query findObjects];
    
    for (PFObject *node in self.WorkNodes) {
        CGPoint position;
        position.x = [[node objectForKey:@"location_x"] floatValue];
        position.y = [[node objectForKey:@"location_y"] floatValue];
        int theSeq = [[node objectForKey:@"seq"] integerValue];
        if(theSeq > maxSeq){
            maxSeq = theSeq;
        }
        
        NSString *task = node[@"task"];
        NSString *worker = node[@"worker"];
        NSString *previous = node[@"previous"];

        MCWorkNode *theNode = [[MCWorkNode alloc] initWithPoint:position Seq:theSeq Task:task Worker:worker Prev:previous];
        [self.view addSubview:theNode];
        
    }
    self -> seq = ++maxSeq;
    NSLog(@"%d", self -> seq);
}


@end
