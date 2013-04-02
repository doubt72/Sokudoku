//
//  Settings.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
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

#import "Settings.h"

@implementation Settings

- (void)setSettingsFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appSupport =
        [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                             NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dir =
        [NSString stringWithFormat:@"%@/Sokudoku", appSupport];
    [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES
                                attributes:nil error:nil];
    settingsFile = [dir stringByAppendingPathComponent:@"settings.plist"];
}

- (void)saveSettings {
    [activeSettings writeToFile:settingsFile atomically:YES];
}

- (void)addPackage:(NSString *)packageName {
    NSMutableArray *packages = [activeSettings objectForKey:@"availablePackages"];
    [packages addObject:packageName];
    [activeSettings setValue:packages forKey:@"availablePackages"];

    packages = [activeSettings objectForKey:@"allPackages"];
    [packages addObject:packageName];
    [activeSettings setValue:packages forKey:@"allPackages"];

    [self saveSettings];
}

- (void)forgetPackage:(NSString *)packageName {
    NSMutableArray *packages = [activeSettings objectForKey:@"availablePackages"];
    [packages removeObjectIdenticalTo:packageName];
    [activeSettings setValue:packages forKey:@"availablePackages"];

    [self saveSettings];
}

- (void)rememberPackage:(NSString *)packageName {
    NSMutableArray *packages = [activeSettings objectForKey:@"availablePackages"];
    [packages addObject:packageName];
    [activeSettings setValue:packages forKey:@"availablePackages"];
    
    [self saveSettings];
}

- (void)deletePackage:(NSString *)packageName {
    NSMutableArray *packages = [activeSettings objectForKey:@"availablePackages"];
    [packages removeObjectIdenticalTo:packageName];
    [activeSettings setValue:packages forKey:@"availablePackages"];

    packages = [activeSettings objectForKey:@"allPackages"];
    [packages removeObjectIdenticalTo:packageName];
    [activeSettings setValue:packages forKey:@"allPackages"];

    [self saveSettings];
}

- (void)setCurrentPackageName:(NSString *)name {
    [activeSettings setValue:name forKey:@"packageName"];
    [self saveSettings];
}

- (NSString *)currentPackageName {
    return [activeSettings valueForKey:@"packageName"];
}

- (NSArray *)availablePackages {
    return [NSArray arrayWithArray:[activeSettings valueForKey:@"availablePackages"]];
}

- (NSArray *)allPackages {
    return [NSArray arrayWithArray:[activeSettings valueForKey:@"allPackages"]];
}

- (id)init {
    if (self = [super init]) {
        [self setSettingsFile];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:settingsFile]) {
            activeSettings = [NSMutableDictionary dictionaryWithContentsOfFile:settingsFile];
        } else {
            activeSettings = [NSMutableDictionary dictionaryWithCapacity:7];
            [activeSettings setValue:nil forKey:@"packageName"];
            [activeSettings setValue:[NSMutableArray arrayWithCapacity:1] forKey:@"availablePackages"];
            [activeSettings setValue:[NSMutableArray arrayWithCapacity:1] forKey:@"allPackages"];
        }
    }
    return self;
}

@end
