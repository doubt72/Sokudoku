//
//  HistogramWindow.h
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

#import <Cocoa/Cocoa.h>
@class MainWindow;
@class HistogramView;
@class Package;

@interface HistogramWindow : NSWindowController {
@package
    NSScrollView *scrollView;
    NSButton *returnButton;
    NSPopUpButton *dataSets;
    NSPopUpButton *subset;
    
    MainWindow *parent;
    HistogramView *histogramView;
    
    Package *package;
    
    BOOL top;
}

@property IBOutlet NSScrollView *scrollView;
@property IBOutlet NSButton *returnButton;
@property IBOutlet NSPopUpButton *dataSets;
@property IBOutlet NSPopUpButton *subset;
@property IBOutlet HistogramView *histogramView;

@property MainWindow *parent;
@property Package *package;

- (IBAction)doReturn:(id)sender;
- (IBAction)selectTag:(id)sender;
- (IBAction)selectSubset:(id)sender;

@end
