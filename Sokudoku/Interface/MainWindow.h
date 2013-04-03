//
//  MainWindow.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/8/13.
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
@class Settings;
@class Package;
@class DrillWindow;
@class RecallPackageWindow;
@class HistogramWindow;
@class GraphWindow;

@interface MainWindow : NSWindowController {
@private
    // Controls
    NSPopUpButton *dataSet;
    NSSlider *minLength, *maxLength, *sessionLength;
    NSButton *weightHistory;
    NSTextField *minLengthStatus, *maxLengthStatus, *sessionLengthStatus;
    NSTextField *currentPackageName;
    NSButton *beginSession;
    NSPopUpButton *packageList;
    NSButton *importPackageButton, *forgetPackageButton;
    NSButton *rememberPackageButton, *deletePackageButton;
    NSButton *showHistoryButton, *showHistogramButton;
    NSButton *resetPackageButton, *forgetHistoryButton;

    NSTextField *displayWeekPackage, *displayMonthPackage, *displayYearPackage;
    NSTextField *displayWeekSet, *displayMonthSet, *displayYearSet;
    
    // Data and subwindows
    Settings *settings;
    Package *currentPackage;
    RecallPackageWindow *recallDialog;
    DrillWindow *drillWindow;
    HistogramWindow *histogramWindow;
    GraphWindow *graphWindow;
}

@property IBOutlet NSPopUpButton *dataSet;
@property IBOutlet NSSlider *minLength;
@property IBOutlet NSSlider *maxLength;
@property IBOutlet NSSlider *sessionLength;
@property IBOutlet NSButton *weightHistory;
@property IBOutlet NSTextField *minLengthStatus;
@property IBOutlet NSTextField *maxLengthStatus;
@property IBOutlet NSTextField *sessionLengthStatus;
@property IBOutlet NSTextField *currentPackageName;
@property IBOutlet NSButton *beginSession;
@property IBOutlet NSPopUpButton *packageList;
@property IBOutlet NSButton *importPackageButton;
@property IBOutlet NSButton *forgetPackageButton;
@property IBOutlet NSButton *rememberPackageButton;
@property IBOutlet NSButton *deletePackageButton;
@property IBOutlet NSButton *showHistoryButton;
@property IBOutlet NSButton *showHistogramButton;
@property IBOutlet NSButton *resetPackageButton;
@property IBOutlet NSButton *forgetHistoryButton;

@property IBOutlet NSTextField *displayWeekPackage;
@property IBOutlet NSTextField *displayMonthPackage;
@property IBOutlet NSTextField *displayYearPackage;
@property IBOutlet NSTextField *displayWeekSet;
@property IBOutlet NSTextField *displayMonthSet;
@property IBOutlet NSTextField *displayYearSet;

// Need these for saving setting to...  Settings
-(IBAction)updateMaxLength:(id)sender;
-(IBAction)updateMinLength:(id)sender;
-(IBAction)updateSessionLength:(id)sender;
-(IBAction)updateWeightHistory:(id)sender;
-(IBAction)updateDataSet:(id)sender;
-(IBAction)updatePackage:(id)sender;

// Actions for packages
-(IBAction)importFile:(id)sender;
-(IBAction)forgetPackage:(id)sender;
-(IBAction)rememberPackage:(id)sender;
-(IBAction)deletePackage:(id)sender;

-(IBAction)forgetHistory:(id)sender;
-(IBAction)resetPackage:(id)sender;

// Subwindow controls
-(IBAction)showHistogram:(id)sender;
-(void)endShowHistogram;

-(IBAction)showGraph:(id)sender;
-(void)endShowGraph;

-(void)doRecall:(NSString *)packageName;
-(void)abortRecall;

-(IBAction)startDrill:(id)sender;
-(void)endDrill;

// Propogated back to the current package
-(void)setGraphTime:(int)time;
-(void)setGraphType:(int)type;
-(void)setCharacterOrder:(BOOL)order;

@end
