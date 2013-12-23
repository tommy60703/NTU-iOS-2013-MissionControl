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
@property (strong, nonatomic) NSTimer *syncWithServer;
@property BOOL shown;
@end

@implementation MCProjectContentViewController

#pragma mark - Lifecycle
-(void)viewWillAppear:(BOOL)animated{
    if (!self.isEditingProjectContent) {
    self.syncWithServer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshFromServer) userInfo:nil repeats:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.syncWithServer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationItem.title = self.project[@"projectName"];
    self.isEditingProjectContent = NO;
    self.shown = NO;
    self.addNodeButton.hidden = YES;
    //self.saveButton.hidden = YES;
    
    if ([self.project[@"user"] isEqualToString:self.project[@"owner"]]) {
        self.editSwitcher.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveWorkNodes) name:@"moveWorkNodes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveWorkFlow) name:@"saveWorkNode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishWorkNodes:) name:@"finishWorkNodes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editWorkNode:) name:@"editWorkNode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteWorkNode:) name:@"deleteWorkNode" object:nil];

    
    
    CGSize size = self.view.frame.size;
    self.myScrollView.contentSize = CGSizeMake(size.width, size.height*2);
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       PFQuery *queryWorkers = [PFQuery queryWithClassName:@"project"];
       [queryWorkers whereKey:@"projectPasscode" equalTo:self.project[@"projectPasscode"]];
       PFObject *findWorkers = [queryWorkers getFirstObject];
       self.workerList = findWorkers[@"projectWorkers"];
       //NSLog(@"%@", self.workerList);
    });
    [self pullFromServerProject];
    [self drawAllLines];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addNode"]) {
    
        UINavigationController *destinationViewController = segue.destinationViewController;
        MCNodeInputViewController *destination = [destinationViewController viewControllers][0];
        destination.workerList = self.workerList;
        destination.previousList = self.previousList;
        destination.delegate = self;
        destination.tag = -1;
        
    }
//    MCProjectContentViewController *source = (MCProjectContentViewController *)segue.sourceViewController;
//    MCNodeInputViewController *destination = (MCNodeInputViewController *)segue.destinationViewController;
}

#pragma mark - IBAction

- (void)saveWorkFlow{
    for (UIView *subview in self.myScrollView.subviews) {
        if([subview isKindOfClass:[MCWorkNode class]]){
            MCWorkNode *finder = (MCWorkNode *)subview;
            //NSLog(@"%d",finder.tag);
            [self pushToServerTask:finder.task Worker:finder.worker Prev:finder.previousNodes Tag:finder.tag Status:finder.status Location:finder.frame.origin];
        }
    }
    //[self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)switcherToggled:(UISwitch *)sender {
    self.isEditingProjectContent = !self.isEditingProjectContent;
    if (self.isEditingProjectContent) {
        [self.syncWithServer invalidate];
        //NSLog(@"%d",self.isEditingProjectContent);
    }
    else{
        self.syncWithServer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshFromServer) userInfo:nil repeats:YES];
        //NSLog(@"%d",self.isEditingProjectContent);
    }
    self.addNodeButton.hidden = !self.addNodeButton.hidden;
    //self.saveButton.hidden = !self.saveButton.hidden;
}

#pragma mark - Instance Method

- (void)pushToServerTask:(NSString *)task Worker:(NSString *)worker Prev:(NSMutableArray *)previous Tag:(int)tag Status:(bool)status Location:(CGPoint)point {
    bool flag = true;
    for (PFObject *node in self.workNodes) {
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
- (void)refreshFromServer{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    PFQuery *fresh = [PFQuery queryWithClassName:[@"A" stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
        NSArray *newWorkNodes = [fresh findObjects];
//    dispatch_sync(dispatch_get_main_queue(), ^{
        for (PFObject *newNode in newWorkNodes) {
            for (PFObject *oldNode in self.workNodes) {
                if ([newNode[@"task"] isEqualToString:oldNode[@"task"]]) {
                    if (newNode[@"state"] != oldNode[@"state"]) {
                        oldNode[@"state"] = newNode[@"state"];
                        [self refreshWorkNodes:[oldNode[@"seq"] integerValue]];
                        if ([self checkMyJob]) {
                            //here
                        }
                        
                        
                    }
                }
            }
        }

//        });
//    });
    
            if ([self checkFinished]) {
        //NSLog(@"yoooooooo");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished!" message:@"Congratz" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        if (!self.shown) {
            [alert show];
            self.shown = YES;
            [self.syncWithServer invalidate];
        }
    }
}
- (void)pullFromServerProject {

        NSLog(@"pull frome Server");
    int maxSeq = -1;
    self.previousList = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:[@"A" stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
    [query orderByAscending:@"seq"];

    self.workNodes = [query findObjects];
    
    for (PFObject *node in self.workNodes) {
        CGPoint position;
        position.x = [[node objectForKey:@"location_x"] floatValue];
        position.y = [[node objectForKey:@"location_y"] floatValue];
        int theSeq = [[node objectForKey:@"seq"] integerValue];
        if(theSeq > maxSeq){
            maxSeq = theSeq;
        }
        
        NSString *task = node[@"task"];
        NSString *worker = node[@"worker"];
        NSMutableArray *previous = node[@"previous"];
        bool status = [node[@"state"] boolValue];
        MCWorkNode *theNode = [[MCWorkNode alloc] initWithPoint:position Seq:theSeq Task:task Worker:worker Prev:previous Status:status];
        theNode.delegate = self;
        [self.previousList addObject:node[@"task"]];
        [self.myScrollView addSubview:theNode];
 
    }
    self -> seq = maxSeq;
        
    if (self->seq == -1) {
        self->seq = 0;
        [self addNodeTask:@"Start" Worker:self.project[@"job"] Previous:[NSMutableArray new] Tag:-1];
    } else {
            self->seq++;
    }
    //NSLog(@"%d", self -> seq);

}

#pragma mark - Private Method

- (void)addNodeTask:(NSString *)task Worker:(NSString*)worker Previous:(NSMutableArray*)previous Tag:(int)tag{
    if(tag==-1)
    {
    NSMutableArray *prevPositions = [NSMutableArray new];
    for (NSString *prevNode in previous) {
        for (UIView *subview in self.myScrollView.subviews) {
            if ([subview isKindOfClass:[MCWorkNode class]]) {
                MCWorkNode *finder = (MCWorkNode *)subview;
                if ([finder.task isEqualToString:prevNode]) {
                    NSMutableDictionary *position = [NSMutableDictionary new];
                    [position setObject:[NSNumber numberWithFloat:finder.frame.origin.x] forKey:@"location_x"] ;
                    [position setObject:[NSNumber numberWithFloat:finder.frame.origin.y] forKey:@"location_y"] ;
                    [prevPositions addObject:position];
                }
            }
        }
    }
    CGPoint position = CGPointMake(0, 0);
    for (NSDictionary *pos in prevPositions) {
        position.x += [pos[@"location_x"] floatValue];
        position.y += [pos[@"location_y"] floatValue];
    }
        if (prevPositions.count != 0) {
            position.x /= prevPositions.count;
            position.y /= prevPositions.count;
            
        }
        position.y += 100;
        
    MCWorkNode *theNode = [[MCWorkNode alloc] initWithPoint:position Seq:seq Task:task Worker:worker Prev:previous Status:false];
    theNode.delegate = self;
    
    
    NSMutableArray *tempWorkNodes = [[NSMutableArray alloc] init];
    self.previousList = [NSMutableArray new];
    for (PFObject *node in self.workNodes) {
        [tempWorkNodes addObject:node];
        [self.previousList addObject:node[@"task"]];
    }
    
    PFObject *projectContent = [PFObject objectWithClassName:[@"A" stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
    projectContent[@"task"] = task;
    projectContent[@"worker"] = worker;
    projectContent[@"previous"] = previous;
    projectContent[@"seq"] = [NSNumber numberWithInt:self->seq];
    projectContent[@"state"] = [NSNumber numberWithBool:false];
    projectContent[@"location_x"] = [NSNumber numberWithDouble:theNode.frame.origin.x];
    projectContent[@"location_y"] = [NSNumber numberWithDouble:theNode.frame.origin.y];
    [tempWorkNodes addObject:projectContent];
    [self.previousList addObject:projectContent[@"task"]];
    self.workNodes = tempWorkNodes;
    
    self->seq++;
    
    [self.myScrollView addSubview:theNode];
    
    [self drawAllLines];
    }
    else{
        
        for (UIView *subview in self.myScrollView.subviews) {
            if ([subview isKindOfClass:[MCWorkNode class]]) {
                MCWorkNode *finder = (MCWorkNode *)subview;
                if (finder.tag == tag) {
                    [MCWorkNode WorkNodeEdit:finder Task:(NSString *)task Worker:(NSString*)worker Previous:(NSMutableArray*)previous];
                    [self moveWorkNodes];
                    break;
                }
                
            }
        }
    }
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
    [self.drawLine addPoints:(NSMutableArray *)self.workNodes];
    self.drawLine.tag = -1;
    [self.myScrollView insertSubview:self.drawLine atIndex:0];
    //[self saveWorkFlow];
    
}

- (void)moveWorkNodes {
    for (PFObject *node in self.workNodes) {
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
                
                for (PFObject *parentNode in self.workNodes) {
                    
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
                    [MCWorkNode WorkNodeChange:finder];
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
                
                for (PFObject *parentNode in self.workNodes) {
                    
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
                    [MCWorkNode WorkNodeChange:finder];
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
            [self pushToServerTask:finder.task Worker:finder.worker Prev:finder.previousNodes Tag:finder.tag Status:finder.status Location:finder.frame.origin];
                [self.syncWithServer invalidate];
                self.syncWithServer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshFromServer) userInfo:nil repeats:YES];
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
            if (!finder.status) {
                flag = false;
                break;
            }
        }
    }
    return flag;
}
-(void)editWorkNode:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    //获取"MyMain.storyboard"故事板的引用
    UIStoryboard *mainStoryboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];

    //实例化Identifier为"myConfig"的视图控制器
    UINavigationController *naviToNodeInput = [mainStoryboard instantiateViewControllerWithIdentifier:@"navigationToNodeInput"];

    MCNodeInputViewController *NodeInput = [naviToNodeInput viewControllers][0];

    //为视图控制器设置过渡类型
    NodeInput.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    //为视图控制器设置显示样式
    NodeInput.modalPresentationStyle = UIModalPresentationFullScreen;
    NodeInput.workerList = self.workerList;
    NodeInput.previousList = self.previousList;
    NodeInput.tag = [[dict valueForKey:@"tag"] integerValue];
    NodeInput.prevTask = [dict valueForKey:@"task"];
    NodeInput.prevWorker = [dict valueForKey:@"worker"];
    NodeInput.prevPrevious = [dict valueForKey:@"previous"];
    NodeInput.delegate = self;
    [self presentViewController:naviToNodeInput animated:YES completion:nil];
    
}

- (void)deleteWorkNode:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    for (UIView *subview in self.myScrollView.subviews) {
        if ([subview isKindOfClass:[MCWorkNode class]]) {
            MCWorkNode *finder = (MCWorkNode *)subview;
            if(finder.tag == [[dict valueForKey:@"tag"] integerValue]){
                [finder removeFromSuperview];
                break;
            }
        }
    }
    NSMutableArray *newWorkNodes = [NSMutableArray new];
    [newWorkNodes addObjectsFromArray:self.workNodes];
    for (PFObject *theWorkNode in newWorkNodes) {
        if ([theWorkNode[@"seq"] isEqualToNumber:[dict valueForKey:@"tag"]]) {
            [newWorkNodes removeObject:theWorkNode];
            [self.previousList removeObject:theWorkNode[@"task"]];
            break;
        }
    }
    self.workNodes = newWorkNodes;
    
    [self drawAllLines];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:[@"A" stringByAppendingString:[self.project[@"projectPasscode"] stringValue]]];
        [query whereKey:@"seq" equalTo:[dict valueForKey:@"tag"]];
        PFObject *deleted = [query getFirstObject];
        [deleted deleteInBackground];
    });
    
}

-(BOOL)checkMyJob{
    BOOL flag = NO;
    for (UIView *subview in self.myScrollView.subviews) {
        if ([subview isKindOfClass:[MCWorkNode class]] ) {
            MCWorkNode *finder = (MCWorkNode *)subview;
            if ([finder.worker isEqualToString:self.project[@"job"]]&&[self checkWorkNodePreviousStatus:finder]) {
                flag = YES;
                break;
            }
        }
    }

    return flag;
}
-(BOOL)checkWorkNodePreviousStatus:(MCWorkNode *)theWorkNode{
    BOOL flag = YES;
    for (NSString *previous in theWorkNode.previousNodes) {
        for (UIView *subview in self.myScrollView.subviews) {
            if ([subview isKindOfClass:[MCWorkNode class]] ) {
                MCWorkNode *finder = (MCWorkNode *)subview;
                if (finder.status == false) {
                    flag = false;
                    break;
                }
            }
        }
        if (flag == false) {
            break;
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
