//
//  MCNodeInputViewController.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCNodeInputViewController.h"

@interface MCNodeInputViewController ()

@end

@implementation MCNodeInputViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.worker = self.workerList[self.workerList.count/2];
    int defaultRow = self.workerList.count/2;
    
    if(self.tag != -1){
        self.taskInput.text = self.prevTask;
        [self.previousList removeObject:self.prevTask];
        self.worker = self.prevWorker;
        for (int i = 0; i < self.workerList.count; i++){
            if([self.workerList[i] isEqualToString:self.prevWorker]){
                defaultRow = i;
                break;
            }
        }
        
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.previousList forKey:@"previousList"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadPreviousList" object:self userInfo:dict];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPreviousList:) name:@"getPreviousList" object:nil];
    
    [self.pickerView selectRow:defaultRow inComponent:0 animated:YES];
    self.previousSelectionList = [NSMutableArray new];
}

- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)doneButtonClick:(id)sender {
    //NSMutableArray *foo = [NSMutableArray new];
    //[foo addObject:self.previousInput.text];
    [self.delegate addNodeTask:self.taskInput.text Worker:self.worker Previous:self.previousSelectionList Tag:self.tag];
    //NSLog(@"%@", self.previousSelectionList);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.workerList count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.workerList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.worker = [self.workerList objectAtIndex:row];
}

- (void)getPreviousList:(NSNotification *)notification{
    NSDictionary *selectPrevious = [notification userInfo];
    
    NSLog(@"%@", [selectPrevious valueForKey:@"previousSelectionList"]);
    
    self.previousSelectionList = [NSMutableArray new];
    [self.previousSelectionList addObjectsFromArray:[selectPrevious valueForKey:@"previousSelectionList"]];
    
    NSLog(@"%@", self.previousSelectionList);
}


@end
