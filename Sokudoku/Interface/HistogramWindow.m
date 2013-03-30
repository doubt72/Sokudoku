//
//  HistogramWindow.m
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
    [parent setCharacterOrder:(int)[subset indexOfSelectedItem]];
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
