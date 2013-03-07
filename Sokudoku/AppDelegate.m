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

- (void)displayAlertForFirstPackage {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Continue"];
    [alert setMessageText:@"Please Select a Package"];
    [alert setInformativeText:@"You must import a package before you can begin using Sokudoku; please select a package to begin.  If you do not currently have any packages to import, you can visit the following link to find one:"];
    NSTextView *accessory = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 320, 15)];
    NSURL *url = [NSURL URLWithString:@"https://github.com/doubt72/Sokudoku/"];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"https://github.com/doubt72/Sokudoku/"];
    NSRange range = NSMakeRange(0, [text length]);
    [text beginEditing];
    [text addAttribute:NSLinkAttributeName value:[url absoluteString] range:range];
    [text addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    [text endEditing];
    [accessory insertText:text];
    [accessory setEditable:NO];
    [accessory setDrawsBackground:NO];
    [accessory setAutomaticLinkDetectionEnabled:YES];
    [alert setAccessoryView:accessory];
    
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert runModal];
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
            NSString *name = [package name];
            if ([[settings availablePackages] containsObject:name]) {
                [self displayAlertForImport:fileName:@"package with the same name already exists"];
            } else {
                [package save];
                [settings setCurrentPackageName:name];
                [settings addPackage:name];
                [settings setDataSetIndex:0];
                currentPackage = package;
                
                [currentPackageName setStringValue:name];
                [self configureDataSetButton];
            }
        }
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    settings = [[Settings alloc] init];
    
    NSString *name = [settings currentPackageName];
    if (name == nil) {
        while ([settings currentPackageName] == nil) {
            [self displayAlertForFirstPackage];
            
            [currentPackageName setStringValue:@"no package loaded"];
            [self importFile:self];
        }
    } else {
        [currentPackageName setStringValue:name];
        currentPackage = [[Package alloc] init];
        [currentPackage load:name];
    }

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
