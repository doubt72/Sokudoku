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
@class RecallPackageWindow;

@interface MainWindow : NSWindowController {
@private
    NSPopUpButton *dataSet;
    NSSlider *minLength, *maxLength, *sessionLength;
    NSButton *weightHistory;
    NSTextField *minLengthStatus, *maxLengthStatus, *sessionLengthStatus;
    NSTextField *currentPackageName;
    NSButton *beginSession;
    NSPopUpButton *packageList;
    NSButton *importPackage, *forgetPackage, *rememberPackage, *deletePackage;
    NSButton *showHistory, *showHistogram, *resetPackage, *forgetHistory;
    
    Settings *settings;
    Package *currentPackage;
    RecallPackageWindow *recallDialog;
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
@property IBOutlet NSButton *importPackage;
@property IBOutlet NSButton *forgetPackage;
@property IBOutlet NSButton *rememberPackage;
@property IBOutlet NSButton *deletePackage;
@property IBOutlet NSButton *showHistory;
@property IBOutlet NSButton *showHistogram;
@property IBOutlet NSButton *resetPackage;
@property IBOutlet NSButton *forgetHistory;

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

-(void)doRecall:(NSString *)packageName;
-(void)abortRecall;

@end
