//
//  MainWindow.m
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

#import "MainWindow.h"
#import "Settings.h"
#import "Package.h"
#import "DrillWindow.h"
#import "RecallPackageWindow.h"
#import "HistogramWindow.h"
#import "GraphWindow.h"

@implementation MainWindow

@synthesize dataSet;
@synthesize minLength, maxLength, sessionLength;
@synthesize weightHistory;
@synthesize minLengthStatus, maxLengthStatus, sessionLengthStatus;
@synthesize currentPackageName;
@synthesize beginSession;
@synthesize packageList;
@synthesize importPackageButton, forgetPackageButton;
@synthesize rememberPackageButton, deletePackageButton;
@synthesize showHistoryButton, showHistogramButton;
@synthesize resetPackageButton, forgetHistoryButton;

@synthesize displayMonthPackage, displayMonthSet, displayWeekPackage;
@synthesize displayWeekSet, displayYearPackage, displayYearSet;

@synthesize characterOrder, graphTime, graphType;

- (void)updateStats {
    float speed = [currentPackage speedAverage:7];
    float daily = [currentPackage dailyAverage:7];
    NSString *body = [NSString stringWithFormat:@"%.2fs (%.1fm/day)", speed, daily];
    [displayWeekPackage setStringValue:body];
    
    speed = [currentPackage speedAverage:30];
    daily = [currentPackage dailyAverage:30];
    body = [NSString stringWithFormat:@"%.2fs (%.1fm/day)", speed, daily];
    [displayMonthPackage setStringValue:body];
    
    speed = [currentPackage speedAverage:365];
    daily = [currentPackage dailyAverage:365];
    body = [NSString stringWithFormat:@"%.2fs (%.1fm/day)", speed, daily];
    [displayYearPackage setStringValue:body];
    
    speed = [currentPackage speedAverageForTag:7 :[currentPackage tagForDescription:[dataSet titleOfSelectedItem]]];
    daily = [currentPackage dailyAverageForTag:7 :[currentPackage tagForDescription:[dataSet titleOfSelectedItem]]];
    body = [NSString stringWithFormat:@"%.2fs (%.1fm/day)", speed, daily];
    [displayWeekSet setStringValue:body];
    
    speed = [currentPackage speedAverageForTag:30 :[currentPackage tagForDescription:[dataSet titleOfSelectedItem]]];
    daily = [currentPackage dailyAverageForTag:30 :[currentPackage tagForDescription:[dataSet titleOfSelectedItem]]];
    body = [NSString stringWithFormat:@"%.2fs (%.1fm/day)", speed, daily];
    [displayMonthSet setStringValue:body];
    
    speed = [currentPackage speedAverageForTag:365 :[currentPackage tagForDescription:[dataSet titleOfSelectedItem]]];
    daily = [currentPackage dailyAverageForTag:365 :[currentPackage tagForDescription:[dataSet titleOfSelectedItem]]];
    body = [NSString stringWithFormat:@"%.2fs (%.1fm/day)", speed, daily];
    [displayYearSet setStringValue:body];
}

// For saving and loading settings for a particular package independent of the
// global settings
- (void)settingsFromSaveDict:(NSDictionary *)dict {
    characterOrder = [[dict objectForKey:@"characterOrder"] boolValue];
    graphTime = [[dict objectForKey:@"graphTime"] intValue];
    graphType = [[dict objectForKey:@"graphType"] intValue];
    currentDataIndex = [[dict objectForKey:@"dataSet"] intValue];
    [minLength setIntValue:[[dict objectForKey:@"minLength"] intValue]];
    [maxLength setIntValue:[[dict objectForKey:@"maxLength"] intValue]];
    [sessionLength setIntValue:[[dict objectForKey:@"sessionLength"] intValue]];
    [minLengthStatus setIntValue:[[dict objectForKey:@"minLength"] intValue]];
    [maxLengthStatus setIntValue:[[dict objectForKey:@"maxLength"] intValue]];
    [sessionLengthStatus setIntValue:[[dict objectForKey:@"sessionLength"] intValue]];
    [weightHistory setState:[[dict objectForKey:@"weightHistory"] intValue]];
}

- (NSDictionary *)saveDictFromSettings {
    NSMutableDictionary *rc = [NSMutableDictionary dictionaryWithCapacity:5];
    [rc setObject:[NSNumber numberWithBool:characterOrder] forKey:@"characterOrder"];
    [rc setObject:[NSNumber numberWithInt:graphTime] forKey:@"graphTime"];
    [rc setObject:[NSNumber numberWithInt:graphType] forKey:@"graphType"];
    [rc setObject:[NSNumber numberWithInt:(int)[dataSet indexOfSelectedItem]]
           forKey:@"dataSet"];
    [rc setObject:[NSNumber numberWithInt:[minLength intValue]] forKey:@"minLength"];
    [rc setObject:[NSNumber numberWithInt:[maxLength intValue]] forKey:@"maxLength"];
    [rc setObject:[NSNumber numberWithInt:[sessionLength intValue]]
           forKey:@"sessionLength"];
    [rc setObject:[NSNumber numberWithInt:(int)[weightHistory state]]
           forKey:@"weightHistory"];
    return [NSDictionary dictionaryWithDictionary:rc];
}

// Set dataSetButton with options from package
- (void)configureDataSetButton {
    [dataSet removeAllItems];
    NSArray *tagNames = [currentPackage allTagDescriptions];
    [dataSet addItemsWithTitles:tagNames];
    [dataSet selectItemAtIndex:currentDataIndex];
    [self updateStats];
}

// Check whether or not to enable forgotten package button
- (BOOL)checkForgottenPackages {
    if ([[settings allPackages] count] ==
        [[settings availablePackages] count]) {
        return NO;
    } else {
        return YES;
    }
}

// Set package list with list of available packages and enable or disable controls
// as appropriate
- (void)configurePackageList {
    [packageList removeAllItems];
    NSArray *available = [settings availablePackages];
    [packageList addItemsWithTitles:available];
    [packageList selectItemWithTitle:[settings currentPackageName]];
    
    if ([[settings availablePackages] count] == 1) {
        [forgetPackageButton setEnabled:NO];
        [deletePackageButton setEnabled:NO];
    } else {
        [forgetPackageButton setEnabled:YES];
        [deletePackageButton setEnabled:YES];
    }
    if ([self checkForgottenPackages]) {
        [rememberPackageButton setEnabled:YES];
    } else {
        [rememberPackageButton setEnabled:NO];
    }
}

// If minLength is longer, reset it
- (IBAction)updateMaxLength:(id)sender {
    int max = [maxLength intValue];
    int min = [minLength intValue];
    if (max < min) {
        [minLength setIntegerValue:max];
        [minLengthStatus setStringValue:[NSString stringWithFormat:@"%d", max]];
        [settings setMinLength:max];
    }
    [maxLengthStatus setStringValue:[NSString stringWithFormat:@"%d", max]];
    [settings setMaxLength:max];
}

// If maxLength is shorter, reset it
- (IBAction)updateMinLength:(id)sender {
    int max = [maxLength intValue];
    int min = [minLength intValue];
    if (max < min) {
        [maxLength setIntegerValue:min];
        [maxLengthStatus setStringValue:[NSString stringWithFormat:@"%d", min]];
        [settings setMaxLength:min];
    }
    [minLengthStatus setStringValue:[NSString stringWithFormat:@"%d", min]];
    [settings setMinLength:min];
}

- (IBAction)updateSessionLength:(id)sender {
    int length = [sessionLength intValue];
    [sessionLengthStatus setStringValue:[NSString stringWithFormat:@"%d", length]];
    [settings setSessionLength:length];
}

- (IBAction)updateWeightHistory:(id)sender {
    NSInteger state = [weightHistory state];
    if (state == NSOnState) {
        [settings enableAdaptiveDrill];
    } else {
        [settings disableAdaptiveDrill];
    }
}

- (IBAction)updateDataSet:(id)sender {
    NSInteger set = [dataSet indexOfSelectedItem];
    [settings setDataSetIndex:(int)set];
    [self updateStats];
}

// When package is changed, options need to be reset as well
- (IBAction)updatePackage:(id)sender {
    NSString *name = [packageList titleOfSelectedItem];
    [currentPackage save:[self saveDictFromSettings]];
    [self settingsFromSaveDict:[currentPackage load:name]];
    
    [settings setCurrentPackageName:name];
    [currentPackageName setStringValue:name];
    [self configureDataSetButton];
    [self updateStats];
}

- (void)displayAlertForImport:(NSString *)fileName:(NSString *)why {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Continue"];
    [alert setMessageText:@"Failed to Import File"];
    [alert setInformativeText:[NSString stringWithFormat:@"There was an error importing the selected file (%@): %@", fileName, why]];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert runModal];
}

- (IBAction)importFile:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setTitle:@"Import Package"];
    [panel setPrompt:@"Import"];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"spkg"]];
    
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        NSURL *url = [[panel URLs] objectAtIndex:0];
        NSString *fileName = [url path];
        Package *package = [[Package alloc] init];
        NSString *rc = [package import:fileName];
        if (rc != nil) {
            [self displayAlertForImport:fileName:rc];
        } else {
            NSString *name = [package name];
            if ([[settings availablePackages] containsObject:name]) {
                [self displayAlertForImport:fileName:@"package with the same name already exists"];
            } else if ([[settings allPackages] containsObject:name]) {
                [self displayAlertForImport:fileName:@"forgotten package with the same name already exists, please recall that package instead"];
            } else {
                [package save:[self saveDictFromSettings]];
                [settings setCurrentPackageName:name];
                [settings addPackage:name];
                [settings setDataSetIndex:0];
                currentPackage = package;
                
                [currentPackageName setStringValue:name];
                [self configureDataSetButton];
                [self configurePackageList];
            }
        }
    }
}

- (IBAction)forgetPackage:(id)sender {
    [currentPackage save:[self saveDictFromSettings]];
    [settings forgetPackage:[settings currentPackageName]];
    
    [settings setCurrentPackageName:[[settings availablePackages] objectAtIndex:0]];
    [self settingsFromSaveDict:[currentPackage load:[settings currentPackageName]]];
    [settings setDataSetIndex:0];
    [self configureDataSetButton];
    [self configurePackageList];
}

// Mainly for when subwindows are created or closed
- (void)setEnabled:(BOOL)value {
    [[[self window] standardWindowButton:NSWindowCloseButton] setEnabled:value];

    [dataSet setEnabled:value];
    [weightHistory setEnabled:value];
    [beginSession setEnabled:value];
    [packageList setEnabled:value];
    [importPackageButton setEnabled:value];
    [forgetPackageButton setEnabled:value];
    [rememberPackageButton setEnabled:value];
    [deletePackageButton setEnabled:value];
    [minLength setEnabled:value];
    [maxLength setEnabled:value];
    [sessionLength setEnabled:value];
    [showHistoryButton setEnabled:value];
    [showHistogramButton setEnabled:value];
    [resetPackageButton setEnabled:value];
    [forgetHistoryButton setEnabled:value];
}

- (void)doRecall:(NSString *)packageName {
    [settings rememberPackage:packageName];
    [settings setCurrentPackageName:packageName];
    [self settingsFromSaveDict:[currentPackage load:packageName]];
    [settings setDataSetIndex:0];
    
    [self setEnabled:YES];
    [self configureDataSetButton];
    [self configurePackageList];
    [recallDialog close];
    [self updateStats];
}

- (void)abortRecall {
    [self setEnabled:YES];
    [self configurePackageList];
    [recallDialog close];
}

- (IBAction)rememberPackage:(id)sender {
    [self setEnabled:NO];

    recallDialog = [[RecallPackageWindow alloc] initWithWindowNibName:@"RecallPackageWindow"];
    [recallDialog setParent:self];
    [recallDialog showWindow:[recallDialog window]];
    [[recallDialog forgottenPackages] removeAllItems];
    for (int i = 0; i < [[settings allPackages] count]; i++) {
        NSString *package = [[settings allPackages] objectAtIndex:i];
        if (![[settings availablePackages] containsObject:package]) {
            [[recallDialog forgottenPackages] addItemWithTitle:package];
        }
    }
}

- (IBAction)deletePackage:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Delete"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Delete Package?"];
    [alert setInformativeText:@"Are you sure you want to delete this package?  If this package is deleted, all history and settings for it will be permanently lost."];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(executeDeletePackage:returnCode:contextInfo:) contextInfo:nil];
}

- (void)executeDeletePackage:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *appSupport =
        [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                             NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dir =
        [NSString stringWithFormat:@"%@/Sokudoku/%@", appSupport,
         [settings currentPackageName]];
        [fileManager removeItemAtPath:dir error:nil];
        
        [settings deletePackage:[settings currentPackageName]];
        
        [settings setCurrentPackageName:[[settings availablePackages] objectAtIndex:0]];
        [self settingsFromSaveDict:[currentPackage load:[settings currentPackageName]]];
        [settings setDataSetIndex:0];
        [self configureDataSetButton];
        [self configurePackageList];
    }
}

- (IBAction)showHistogram:(id)sender {
    [self setEnabled:NO];
    
    histogramWindow = [[HistogramWindow alloc] initWithWindowNibName:@"HistogramWindow"];
    [histogramWindow setPackage:currentPackage];
    [histogramWindow setParent:self];
    [histogramWindow showWindow:[histogramWindow window]];
    [[histogramWindow subset] selectItemAtIndex:characterOrder];
    [histogramWindow selectSubset:self];

    [[histogramWindow dataSets] removeAllItems];
    [[histogramWindow dataSets] addItemsWithTitles:[currentPackage allTagDescriptions]];
    [[histogramWindow dataSets] selectItemAtIndex:[settings dataSetIndex]];
    [histogramWindow selectTag:self];
}

- (void)endShowHistogram {
    [self setEnabled:YES];
    [self configurePackageList];
    [histogramWindow close];
}

- (IBAction)showGraph:(id)sender {
    [self setEnabled:NO];
    
    graphWindow = [[GraphWindow alloc] initWithWindowNibName:@"GraphWindow"];
    [graphWindow setPackage:currentPackage];
    [graphWindow setParent:self];
    [graphWindow showWindow:[graphWindow window]];
    [[graphWindow graphType] selectItemAtIndex:graphType];
    [[graphWindow timeFrame] selectItemAtIndex:graphTime];
    [graphWindow changeGraphType:self];
    [graphWindow changeTimeFrame:self];
    
    [[graphWindow dataSet] removeAllItems];
    [[graphWindow dataSet] addItemsWithTitles:[currentPackage allTagDescriptions]];
    [[graphWindow dataSet] selectItemAtIndex:[settings dataSetIndex]];
    [graphWindow changeDataSet:self];
}

- (void)endShowGraph {
    [self setEnabled:YES];
    [self configurePackageList];
    [graphWindow close];
}

- (IBAction)forgetHistory:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Clear"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Clear History?"];
    [alert setInformativeText:@"Are you sure you want to clear the history for this package?  If you continue, all history for this package will be permanently lost."];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(executeForgetHistory:returnCode:contextInfo:) contextInfo:nil];
}

- (void)executeForgetHistory:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        [currentPackage clearHistory];
        [currentPackage save:[self saveDictFromSettings]];
    }
}

- (IBAction)resetPackage:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Reset"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Reset Package?"];
    [alert setInformativeText:@"Are you sure you want to reset this package?  If this package is reset, all history and character weightings will be permanently lost."];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(executeResetPackage:returnCode:contextInfo:) contextInfo:nil];
}

- (void)executeResetPackage:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        [currentPackage reset];
        [currentPackage save:[self saveDictFromSettings]];
    }
}

- (IBAction)startDrill:(id)sender {
    [self setEnabled:NO];

    drillWindow = [[DrillWindow alloc] initWithWindowNibName:@"DrillWindow"];
    [drillWindow setPackage:currentPackage];
    [drillWindow setParent:self];
    [drillWindow setMinLength:[settings minLength]];
    [drillWindow setMaxLength:[settings maxLength]];
    [drillWindow setSessionLength:([settings sessionLength] * 60.0)];
    [drillWindow setTimeLeft:([settings sessionLength] * 60.0)];
    [drillWindow setWeighted:[settings adaptiveDrillEnabled]];
    [drillWindow setTag:[currentPackage tagForDescription:[dataSet titleOfSelectedItem]]];

    [drillWindow showWindow:[drillWindow window]];
    [drillWindow nextQuestion];
}

- (void)endDrill {
    [self setEnabled:YES];
    [self configurePackageList];
    [currentPackage save:[self saveDictFromSettings]];
    [drillWindow close];
    [self updateStats];
}

- (void)displayAlertForFirstPackage {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Continue"];
    [alert setMessageText:@"Please Select a Package"];
    [alert setInformativeText:@"You must import a package before you can begin using Sokudoku; please select a package to begin.  If you do not currently have any packages to import, you can visit the following link to find one:"];
    
    NSTextView *accessory = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 250, 12)];
    NSURL *url = [NSURL URLWithString:@"https://github.com/doubt72/Sokudoku/"];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"https://github.com/doubt72/Sokudoku/"];
    NSRange range = NSMakeRange(0, [text length]);
    [text beginEditing];
    [text addAttribute:NSLinkAttributeName value:[url absoluteString] range:range];
    [text endEditing];
    [accessory insertText:text];
    [accessory setEditable:NO];
    [accessory setDrawsBackground:NO];
    [accessory setAutomaticLinkDetectionEnabled:YES];
    [alert setAccessoryView:accessory];
    
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert runModal];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        ;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    settings = [[Settings alloc] init];
    
    NSString *name = [settings currentPackageName];
    if (name == nil) {
        characterOrder = 0;
        graphTime = 0;
        graphType = 0;
        currentDataIndex = 0;
        while ([settings currentPackageName] == nil) {
            [self displayAlertForFirstPackage];
            
            [currentPackageName setStringValue:@"no package loaded"];
            [self importFile:self];
        }
    } else {
        [currentPackageName setStringValue:name];
        currentPackage = [[Package alloc] init];
        [self settingsFromSaveDict:[currentPackage load:name]];
    }

    [self setEnabled:YES];
    [self configureDataSetButton];
    [self configurePackageList];
    
    [minLength setIntValue:[settings minLength]];
    [maxLength setIntValue:[settings maxLength]];
    [sessionLength setIntValue:[settings sessionLength]];
    [minLengthStatus setIntValue:[settings minLength]];
    [maxLengthStatus setIntValue:[settings maxLength]];
    [sessionLengthStatus setIntValue:[settings sessionLength]];
    if ([settings adaptiveDrillEnabled]) {
        [weightHistory setState:NSOnState];
    } else {
        [weightHistory setState:NSOffState];
    }
}

@end
