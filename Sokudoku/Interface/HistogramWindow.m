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
@synthesize scrollView, returnButton, dataSets;
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
}

@end
