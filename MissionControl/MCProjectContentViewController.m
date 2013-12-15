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
#import <QuartzCore/QuartzCore.h>

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
- (void)moveWorkNodes{
    NSLog(@"moveWorkNodes");
    for (PFObject *node in self.WorkNodes) {
        for (UIView *subview in self.myScrollView.subviews) {
            if([subview isKindOfClass:[MCWorkNode class]]){
                if ([[node objectForKey:@"seq"] integerValue] == subview.tag ) {
                    MCWorkNode *finder = subview;
                    NSLog(@"%@ %@",node[@"location_x"], node[@"location_y"]);
                    NSLog(@"%@ %@",[NSNumber numberWithDouble:finder.frame.origin.x], [NSNumber numberWithDouble:finder.frame.origin.y]);
                    
                    node[@"location_x"] = [NSNumber numberWithDouble:finder.frame.origin.x];
                    node[@"location_y"] = [NSNumber numberWithDouble:finder.frame.origin.y];
                    NSLog(@"new : %@ %@",node[@"location_x"], node[@"location_y"]);

                    NSLog(@"%d", subview.tag);
                }
            }
        }
    }
    [self drawAllLines];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pullFromServerProject];
    
    
    CGSize size = self.view.frame.size;
    
    self.myScrollView.contentSize = CGSizeMake(size.width, size.height*2);
    
//    for (MCWorkNode *node in self.view.subviews) {
//        [self.view bringSubviewToFront:node];
//    }
//
    if(self->seq == 0){
        [self addNodeTask:@"init" Worker:@"me" Previous:@"none"];
    }
    else
        self->seq++;
    [self drawAllLines];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveWorkNodes) name:@"moveWorkNodes" object:nil];
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
    
    for (UIView *subview in self.myScrollView.subviews) {
        if([subview isKindOfClass:[MCWorkNode class]]){
            MCWorkNode *finder = subview;
            NSLog(@"%d",finder.tag);

            [self pushToServerTask:finder.task Worker:finder.worker Prev:finder.previous Tag:finder.tag Status:false Location:finder.frame.origin];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}



- (void)addNodeTask:(NSString *)task Worker:(NSString*)worker Previous:(NSString*)previous {
//    NSLog(@"%@", task);
//    NSLog(@"%@", worker);
//    NSLog(@"%@", previous);
    MCWorkNode *theNode = [[MCWorkNode alloc] initWithPoint:self.view.center Seq:seq Task:task Worker:worker Prev:previous Delegate:self];
    //[self.view isKindOfClass:[UIImageView class]];
    
    NSLog(@"%d", self->seq);
    self->seq++;
    
    [self.myScrollView addSubview:theNode];
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

        MCWorkNode *theNode = [[MCWorkNode alloc] initWithPoint:position Seq:theSeq Task:task Worker:worker Prev:previous Delegate:self];
        [self.myScrollView addSubview:theNode];
        
    }
    self -> seq = maxSeq;
    NSLog(@"%d", self -> seq);
}

- (void)drawAllLines{
    NSLog(@"draw");
    for (UIView *subview in self.myScrollView.subviews) {
        if (subview.tag == -1) {
            [subview removeFromSuperview];
        }
    }
    CGSize size = self.myScrollView.frame.size;
    self.drawLine = [[MCDrawLine alloc] initWithFrame:CGRectMake(0, 0, size.width , size.height)];
    [self.drawLine setBackgroundColor:[UIColor whiteColor]];
    [self.drawLine addPoints:self.WorkNodes];
    self.drawLine.tag = -1;
    [self.myScrollView insertSubview:self.drawLine atIndex:0];
    
}

- (void)disableScroll {
    self.myScrollView.scrollEnabled = NO;
}

- (void)enableScroll {
    self.myScrollView.scrollEnabled = YES;
}

@end
