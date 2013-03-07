//
//  AppDelegate.m
//  Sokudoku
//
//  Created by Douglas Triggs on 2/26/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "AppDelegate.h"
#import "Settings.h"
#import "Package.h"

@implementation AppDelegate

@synthesize dataSet;
@synthesize minLength, maxLength, sessionLength;
@synthesize weightHistory;
@synthesize minLengthStatus, maxLengthStatus, sessionLengthStatus;
@synthesize currentPackageName;
@synthesize beginSession;
@synthesize loadPackage, importPackage, forgetPackage, deletePackage;
@synthesize showHistory, showHistogram, resetPackage, forgetHistory;

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

- (void)displayAlertForImport:(NSString *)fileName:(NSString *)why {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Continue"];
    [alert setMessageText:@"Failed to Import File"];
    [alert setInformativeText:[NSString stringWithFormat:@"There was an error importing the selected file (%@): %@", fileName, why]];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert runModal];
}

- (void)configureDataSetButton {
    [dataSet removeAllItems];
    NSArray *tagNames = [currentPackage allTagDescriptions];
    [dataSet addItemsWithTitles:tagNames];
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
            NSLog(@"no error loading package");
            NSString *name = [package name];
            NSLog(@"name: %@", name);
            NSLog(@"tags: %@", [package allTagDescriptions]);
            if ([[settings availablePackages] containsObject:name]) {
                [self displayAlertForImport:fileName:@"package with the same name already exists"];
            } else {
                [package save];
                [settings setCurrentPackageName:name];
                [settings addPackage:name];
                [settings setDataSetIndex:0];
                currentPackage = package;
                
                [self configureDataSetButton];
            }
        }
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    settings = [[Settings alloc] init];
    while ([settings currentPackageName] == nil) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Continue"];
        [alert setMessageText:@"Please Select a Package"];
        [alert setInformativeText:@"You must import a package before you can begin using Sokudoku; please select a package to begin.  If you do not currently have any packages to import, you can visit https://github.com/doubt72/Sokudoku/tree/master/Packages to find one."];
        // TODO: add an accessory view with an active link
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert runModal];
        
        [currentPackageName setStringValue:@"no package loaded"];
        [self importFile:self];
    }

    NSString *name = [settings currentPackageName];
    [currentPackageName setStringValue:name];
    currentPackage = [[Package alloc] init];
    [currentPackage load:name];

    [self configureDataSetButton];

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
