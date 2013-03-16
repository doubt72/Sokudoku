//
//  HistogramWindow.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/10/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "HistogramWindow.h"
#import "MainWindow.h"
#import "HistogramView.h"
#import "Package.h"

@implementation HistogramWindow
@synthesize scrollView, returnButton, dataSets, subset;
@synthesize histogramView;
@synthesize parent;
@synthesize package;

- (IBAction)doReturn:(id)sender {
    [parent endShowHistogram];
}

- (IBAction)selectTag:(id)sender {
    [histogramView setTag:[package tagForDescription:[dataSets titleOfSelectedItem]]];
    [histogramView setNeedsDisplay:YES];
}

- (IBAction)selectSubset:(id)sender {
    // Select slowest or fastest characters on top
    if ([subset indexOfSelectedItem] == 0) {
        top = YES;
    } else {
        top = NO;
    }
    [histogramView setTop:top];
    [histogramView setNeedsDisplay:YES];
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
    [histogramView setPackage:package];
    
    top = YES;
    
    [histogramView setPackage:package];
    [histogramView setTop:top];
    
    [subset removeAllItems];
    [subset addItemWithTitle:@"Slowest 100 characters"];
    [subset addItemWithTitle:@"Fastest 100 characters"];
    [subset selectItemAtIndex:0];
}

@end
