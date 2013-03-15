//
//  MainWindow.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/8/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Settings;
@class Package;
@class DrillWindow;
@class RecallPackageWindow;
@class HistogramWindow;
@class GraphWindow;

@interface MainWindow : NSWindowController {
@private
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

-(IBAction)updateMaxLength:(id)sender;
-(IBAction)updateMinLength:(id)sender;
-(IBAction)updateSessionLength:(id)sender;
-(IBAction)updateWeightHistory:(id)sender;
-(IBAction)updateDataSet:(id)sender;
-(IBAction)updatePackage:(id)sender;

-(IBAction)importFile:(id)sender;
-(IBAction)forgetPackage:(id)sender;
-(IBAction)rememberPackage:(id)sender;
-(IBAction)deletePackage:(id)sender;

-(IBAction)forgetHistory:(id)sender;
-(IBAction)resetPackage:(id)sender;

-(IBAction)showHistogram:(id)sender;
-(void)endShowHistogram;

-(IBAction)showGraph:(id)sender;
-(void)endShowGraph;

-(void)doRecall:(NSString *)packageName;
-(void)abortRecall;

-(IBAction)startDrill:(id)sender;
-(void)endDrill;

@end
