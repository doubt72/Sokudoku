//
//  MainWindow.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/8/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "MainWindow.h"
#import "Settings.h"
#import "Package.h"

@implementation MainWindow

@synthesize dataSet;
@synthesize minLength, maxLength, sessionLength;
@synthesize weightHistory;
@synthesize minLengthStatus, maxLengthStatus, sessionLengthStatus;
@synthesize currentPackageName;
@synthesize beginSession;
@synthesize packageList;
@synthesize importPackage, forgetPackage, rememberPackage, deletePackage;
@synthesize showHistory, showHistogram, resetPackage, forgetHistory;

- (void)configureDataSetButton {
    [dataSet removeAllItems];
    NSArray *tagNames = [currentPackage allTagDescriptions];
    [dataSet addItemsWithTitles:tagNames];
    [dataSet selectItemAtIndex:[settings dataSetIndex]];
}

- (BOOL)checkForgottenPackages {
    if ([[settings allPackages] count] ==
        [[settings availablePackages] count]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)configurePackageList {
    [packageList removeAllItems];
    NSArray *available = [settings availablePackages];
    [packageList addItemsWithTitles:available];
    [packageList selectItemWithTitle:[settings currentPackageName]];
    
    if ([[settings availablePackages] count] == 1) {
        [forgetPackage setEnabled:NO];
        [deletePackage setEnabled:NO];
    } else {
        [forgetPackage setEnabled:YES];
        [deletePackage setEnabled:YES];
    }
    if ([self checkForgottenPackages]) {
        [rememberPackage setEnabled:YES];
    } else {
        [rememberPackage setEnabled:NO];
    }
}

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

- (IBAction)updateDataSet:(id)sender {
    NSInteger set = [dataSet indexOfSelectedItem];
    [settings setDataSetIndex:(int)set];
}

- (IBAction)updatePackage:(id)sender {
    NSString *name = [packageList titleOfSelectedItem];
    [currentPackage save];
    [currentPackage load:name];
    
    [settings setCurrentPackageName:name];
    [settings setDataSetIndex:0];
    [currentPackageName setStringValue:name];
    [self configureDataSetButton];
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
                [package save];
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
    [currentPackage save];
    [settings removePackage:[settings currentPackageName]];
    
    [settings setCurrentPackageName:[[settings availablePackages] objectAtIndex:0]];
    [currentPackage load:[settings currentPackageName]];
    [settings setDataSetIndex:0];
    [self configureDataSetButton];
    [self configurePackageList];
}

- (IBAction)rememberPackage:(id)sender {
    // TODO: REMEMBER
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
        [currentPackage load:[settings currentPackageName]];
        [settings setDataSetIndex:0];
        [self configureDataSetButton];
        [self configurePackageList];
    }
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
        while ([settings currentPackageName] == nil) {
            [self displayAlertForFirstPackage];
            
            [currentPackageName setStringValue:@"no package loaded"];
            [self importFile:self];
        }
    } else {
        [currentPackageName setStringValue:name];
        currentPackage = [[Package alloc] init];
        [currentPackage load:name];
        
        [self configureDataSetButton];
        [self configurePackageList];
    }
    
    [dataSet setEnabled:YES];
    [weightHistory setEnabled:YES];
    [beginSession setEnabled:YES];
    [packageList setEnabled:YES];
    [importPackage setEnabled:YES];
    [minLength setEnabled:YES];
    [maxLength setEnabled:YES];
    [sessionLength setEnabled:YES];
    
    [showHistory setEnabled:YES];
    [showHistogram setEnabled:YES];
    [resetPackage setEnabled:YES];
    [forgetHistory setEnabled:YES];
    
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
