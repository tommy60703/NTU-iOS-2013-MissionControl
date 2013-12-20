//
//  MCProjectContentViewController.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCProjectContentViewController.h"
#import "MCNodeInputViewController.h"
#import "MCWorkNode.h"

@interface MCProjectContentViewController ()
@property (strong, nonatomic) NSTimer *syncWithServerTimer;
@property BOOL finished;
@end

@implementation MCProjectContentViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = self.view.frame.size;
    self.myScrollView.contentSize = CGSizeMake(size.width, size.height*2);
    
    self.isEditingProjectContent = NO;
    self.finished = NO;
    self.addNodeButton.hidden = YES;
    self.saveButton.hidden = YES;
    
    if ([self.project[@"user"] isEqualToString:self.project[@"owner"]]) {
        self.editSwitcher.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveWorkNodes) name:@"moveWorkNodes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishWorkNodes:) name:@"finishWorkNodes" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCanvas) name:@"loadedData" object:nil];
    [self reloadFromServer];
    
    [self drawAllLines];
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCanvas) name:@"doRefreshCanvas" object:nil];
    if (!self.isEditingProjectContent) {
        self.syncWithServerTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reloadFromServer) userInfo:nil repeats:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.syncWithServerTimer invalidate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addNode"]) {
        UINavigationController *destinationViewController = segue.destinationViewController;
        MCNodeInputViewController *destination = [destinationViewController viewControllers][0];
        destination.delegate = self;
    }
}

- (void)refreshCanvas {
    
}

#pragma mark - IBAction

- (IBAction)saveWorkFlow:(id)sender {
    for (UIView *subview in self.myScrollView.subviews) {
        if([subview isKindOfClass:[MCWorkNode class]]){
            MCWorkNode *finder = (MCWorkNode *)subview;
            //NSLog(@"%d",finder.tag);
            [self pushToServerTask:finder.task Worker:finder.worker Prev:finder.previousNodes Tag:finder.tag Status:finder.completion Location:finder.frame.origin];
        }
    }
    //[self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)switcherToggled:(UISwitch *)sender {
    self.isEditingProjectContent = !self.isEditingProjectContent;
    if (self.isEditingProjectContent) {
        [self.syncWithServerTimer invalidate];
    } else {
        self.syncWithServerTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reloadFromServer) userInfo:nil repeats:YES];
    }
    self.addNodeButton.hidden = !self.addNodeButton.hidden;
    self.saveButton.hidden = !self.saveButton.hidden;
}

#pragma mark - Instance Method

- (void)pushToServerTask:(NSString *)task Worker:(NSString *)worker Prev:(NSMutableArray *)previous Tag:(int)tag Status:(bool)status Location:(CGPoint)point {
    bool flag = true;
    for (PFObject *node in self.project.workNodes) {
        //NSLog(@"%d",[[node objectForKey:@"seq"] integerValue] == tag);
        if ([[node objectForKey:@"seq"] integerValue] == tag) {
            //NSLog(@"same");
            node[@"previous"] = previous;
            node[@"state"] = [NSNumber numberWithBool:status];
            node[@"location_x"] = [NSNumber numberWithDouble:point.x];
            node[@"location_y"] = [NSNumber numberWithDouble:point.y];
            [node saveInBackground];
            flag = false;
        }
        
    }
    if (flag) {
        PFObject *projectContent = [PFObject objectWithClassName:[@"A" stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
        projectContent[@"task"] = task;
        projectContent[@"worker"] = worker;
        projectContent[@"previous"] = previous;
        projectContent[@"seq"] = [NSNumber numberWithInt:tag];
        projectContent[@"state"] = [NSNumber numberWithBool:status];
        projectContent[@"location_x"] = [NSNumber numberWithDouble:point.x];
        projectContent[@"location_y"] = [NSNumber numberWithDouble:point.y];
        [projectContent saveInBackground];
        //NSLog(@"here");
    }
}
- (void)reloadFromServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PFQuery *fresh = [PFQuery queryWithClassName:[@"A" stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
        NSArray *newWorkNodes = [fresh findObjects];
        for (PFObject *newNode in newWorkNodes) {
            for (PFObject *oldNode in self.project.workNodes) {
                if ([newNode[@"task"] isEqualToString:oldNode[@"task"]]) {
                    if (newNode[@"state"] != oldNode[@"state"]) {
                        oldNode[@"state"] = newNode[@"state"];
                        [self refreshWorkNodes:[oldNode[@"seq"] integerValue]];
                    }
                }
            }
        }
        if ([self checkFinished]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished!" message:@"Congratz" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            if (!self.finished) {
                [alert show];
                self.finished = YES;
                [self.syncWithServerTimer invalidate];
            }
        }

    });
}
- (void)pullFromServerProject {
    PFQuery *query = [PFQuery queryWithClassName:[@"A" stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
    [query orderByAscending:@"seq"];

    self.project.workNodes =[NSMutableArray arrayWithArray:[query findObjects]];
    
    for (PFObject *node in self.project.workNodes) {
        CGPoint position;
        position.x = [[node objectForKey:@"location_x"] floatValue];
        position.y = [[node objectForKey:@"location_y"] floatValue];

        NSString *task = node[@"task"];
        NSString *worker = node[@"worker"];
        NSMutableArray *previous = node[@"previous"];
        BOOL completion = [node[@"state"] boolValue];
        MCWorkNode *theNode = [[MCWorkNode alloc] initWithTask:task Worker:worker PreviousNodes:previous Completion:completion];
        theNode.viewControllerDelegate = self;
        [self.myScrollView addSubview:theNode];
    }
}

#pragma mark - Private Method

- (void)addNodeTask:(NSString *)task Worker:(NSString*)worker Previous:(NSMutableArray*)previous {
    MCWorkNode *theNode = [[MCWorkNode alloc] initWithTask:task Worker:worker PreviousNodes:previous Completion:NO];
    theNode.viewControllerDelegate = self;
    
    NSMutableArray *tempWorkNodes = [[NSMutableArray alloc] init];
    
    for (PFObject *node in self.project.workNodes) {
        [tempWorkNodes addObject:node];
    }
    
    PFObject *projectContent = [PFObject objectWithClassName:[@"A" stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
    projectContent[@"task"] = task;
    projectContent[@"worker"] = worker;
    projectContent[@"previous"] = previous;
    projectContent[@"state"] = [NSNumber numberWithBool:NO];
    projectContent[@"location_x"] = [NSNumber numberWithDouble:theNode.frame.origin.x];
    projectContent[@"location_y"] = [NSNumber numberWithDouble:theNode.frame.origin.y];
    [tempWorkNodes addObject:projectContent];
    
    self.project.workNodes = tempWorkNodes;
    
    [self.myScrollView addSubview:theNode];
    [self drawAllLines];
}

- (void)drawAllLines {
    for (UIView *subview in self.myScrollView.subviews) {
        if (subview.tag == -1) {
            [subview removeFromSuperview];
        }
    }
    CGSize size = self.myScrollView.frame.size;
    self.drawLine = [[MCDrawLine alloc] initWithFrame:CGRectMake(0, 0, size.width , size.height)];
    [self.drawLine setBackgroundColor:[UIColor whiteColor]];
    [self.drawLine addPoints:self.project.workNodes];
    self.drawLine.tag = -1;
    [self.myScrollView insertSubview:self.drawLine atIndex:0];
    
}

- (void)moveWorkNodes {
    for (PFObject *node in self.project.workNodes) {
        for (UIView *subview in self.myScrollView.subviews) {
            if([subview isKindOfClass:[MCWorkNode class]]){
                if ([[node objectForKey:@"seq"] integerValue] == subview.tag ) {
                    MCWorkNode *finder = (MCWorkNode *)subview;
                    node[@"location_x"] = [NSNumber numberWithDouble:finder.frame.origin.x];
                    node[@"location_y"] = [NSNumber numberWithDouble:finder.frame.origin.y];
                }
            }
        }
    }
    [self drawAllLines];
}
- (void)refreshWorkNodes:(int)tag{
    for (UIView *subview in self.myScrollView.subviews) {
        if([subview isKindOfClass:[MCWorkNode class]]){
            MCWorkNode *finder = (MCWorkNode *)subview;
            if (finder.tag == tag) {
                bool flag = true;
                
                NSSet *parents = [NSSet setWithArray:finder.previousNodes];
                //NSLog(@"%@",parents);
                
                for (PFObject *parentNode in self.project.workNodes) {
                    
                    if ([parents containsObject:[parentNode objectForKey:@"task"]])  {
                        //NSLog(@"%@",parentNode);
                        //NSLog(@"%d",[[parentNode objectForKey:@"state"] boolValue]);
                        if ([[parentNode objectForKey:@"state"] boolValue] == false) {
                            flag = false;
                            break;
                        }
                    }
                }
                
                //NSLog(@"%d",flag);
                if (flag) {
//                    [MCWorkNode workNodeChange:finder];
                    [self syncStatusWithServer:tag];
                }
            }
            
        }
    }
    

}
- (void)finishWorkNodes:(NSNotification *) notification{
    NSDictionary *dict = [notification userInfo];
   //NSLog(@"%d", [[dict valueForKey:@"tag"] integerValue]);
    for (UIView *subview in self.myScrollView.subviews) {
        if([subview isKindOfClass:[MCWorkNode class]]){
            MCWorkNode *finder = (MCWorkNode *)subview;
            if (finder.tag == [[dict valueForKey:@"tag"] integerValue]) {
                bool flag = true;
                if (![finder.worker isEqualToString:self.project[@"job"]]) {
                    flag=false;
                    break;
                }
                NSSet *parents = [NSSet setWithArray:finder.previousNodes];
                //NSLog(@"%@",parents);
                
                for (PFObject *parentNode in self.project.workNodes) {
                    
                    if ([parents containsObject:[parentNode objectForKey:@"task"]])  {
//                        NSLog(@"%@",parentNode);
//                        NSLog(@"%d",[[parentNode objectForKey:@"state"] boolValue]);
                        if ([[parentNode objectForKey:@"state"] boolValue] == false) {
                            flag = false;
                            break;
                        }
                    }
                }
                
                //NSLog(@"%d",flag);
                if (flag) {
//                    [MCWorkNode workNodeChange:finder];
                    [self syncStatusWithServer:[[dict valueForKey:@"tag"] integerValue]];
                }
            }
            
        }
    }
    
}

-(void)syncStatusWithServer:(int) tag{
    for (UIView *subview in self.myScrollView.subviews) {
        if([subview isKindOfClass:[MCWorkNode class]]){
            MCWorkNode *finder = (MCWorkNode *)subview;
            //NSLog(@"%d",finder.tag);
            if (finder.tag == tag) {
            [self pushToServerTask:finder.task Worker:finder.worker Prev:finder.previousNodes Tag:finder.tag Status:finder.completion Location:finder.frame.origin];
                [self.syncWithServerTimer invalidate];
                self.syncWithServerTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reloadFromServer) userInfo:nil repeats:YES];
            }
        }
    }
    
}
-(bool)checkFinished{
    //NSLog(@"check");
    bool flag = true;
    for (UIView *subview in self.myScrollView.subviews) {
        if([subview isKindOfClass:[MCWorkNode class]]){
            MCWorkNode *finder = (MCWorkNode *)subview;
            //NSLog(@"%d", finder.status);
            if (!finder.completion) {
                flag = false;
                break;
            }
        }
    }
    return flag;
}
#pragma mark - MCNodeDelegate

- (void)disableScroll {
    self.myScrollView.scrollEnabled = NO;
}

- (void)enableScroll {
    self.myScrollView.scrollEnabled = YES;
}

- (BOOL)isEditingContent {
    return self.isEditingProjectContent;
}

@end
