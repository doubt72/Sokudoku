//
//  GraphWindow.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/10/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

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
    [graphView setNeedsDisplay:YES];
}

- (IBAction)changeTimeFrame:(id)sender {
    // Day ranges (1 week, 1 month, 3 months, 6 months, 1 year, 2 years)
    int array[] = {7, 30, 90, 180, 365, 730};
    
    [graphView setTimeFrame:array[[timeFrame indexOfSelectedItem]]];
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
    [graphType addItemWithTitle:@"Repetitions Per Day"];
    [graphType addItemWithTitle:@"Average Speed + Study Time"];
    
    [timeFrame removeAllItems];
    [timeFrame addItemWithTitle:@"One Week"];
    [timeFrame addItemWithTitle:@"One Month"];
    [timeFrame addItemWithTitle:@"Three Months"];
    [timeFrame addItemWithTitle:@"Six Months"];
    [timeFrame addItemWithTitle:@"One Year"];
    [timeFrame addItemWithTitle:@"Two Years"];
    [timeFrame selectItemAtIndex:0];
    [graphView setTimeFrame:7];
    [graphView setPackage:package];
}

@end
