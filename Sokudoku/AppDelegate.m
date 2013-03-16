//
//  AppDelegate.m
//  Sokudoku
//
//  Created by Douglas Triggs on 2/26/13.
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

#import "AppDelegate.h"
#import "MainWindow.h"
#import "StartupWindow.h"

@implementation AppDelegate

@synthesize mainWindow, startupWindow;

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)startupFinished {
    [startupWindow close];
    
    mainWindow = [[MainWindow alloc] initWithWindowNibName:@"MainWindow"];
    [mainWindow showWindow:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    startupWindow = [[StartupWindow alloc] initWithWindowNibName:@"StartupWindow"];
    [startupWindow showWindow:self];
    
    [startupWindow setParent:self];
}

@end
