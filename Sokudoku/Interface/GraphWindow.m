//
//  GraphWindow.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/10/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you
// may not use this file except in compliance with the License. You may
// obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.

#import "GraphWindow.h"
#import "GraphView.h"
#import "MainWindow.h"
#import "Package.h"

@implementation GraphWindow

@synthesize returnButton;
@synthesize dataSet, graphType, timeFrame;
@synthesize graphView, parent, package;

- (IBAction)doReturn:(id)sender {
    [parent endShowGraph];
}

- (IBAction)changeDataSet:(id)sender {
    [graphView setTag:[package tagForDescription:[dataSet titleOfSelectedItem]]];
    [graphView setNeedsDisplay:YES];
}

- (IBAction)changeGraphType:(id)sender {
    [graphView setGraphType:(int)[graphType indexOfSelectedItem]];
    [parent setGraphType:(int)[graphType indexOfSelectedItem]];
    [graphView setNeedsDisplay:YES];
}

- (IBAction)changeTimeFrame:(id)sender {
    // Day ranges (1 week, 1 month, 3 months, 6 months, 1 year, 2 years)
    int array[] = {7, 30, 90, 180, 365, 730};

    [graphView setTimeFrame:array[[timeFrame indexOfSelectedItem]]];
    [parent setGraphTime:(int)[timeFrame indexOfSelectedItem]];
    [graphView setNeedsDisplay:YES];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [graphType removeAllItems];
    [graphType addItemWithTitle:@"Average Answer Speed"];
    [graphType addItemWithTitle:@"Study Time Per Day"];
    [graphType addItemWithTitle:@"Characters Per Day"];
    [graphType addItemWithTitle:@"Average Speed + Study Time"];
    
    [timeFrame removeAllItems];
    [timeFrame addItemWithTitle:@"One Week"];
    [timeFrame addItemWithTitle:@"One Month"];
    [timeFrame addItemWithTitle:@"Three Months"];
    [timeFrame addItemWithTitle:@"Six Months"];
    [timeFrame addItemWithTitle:@"One Year"];
    [timeFrame addItemWithTitle:@"Two Years"];
    [graphView setPackage:package];
}

@end
