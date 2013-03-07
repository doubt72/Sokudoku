//
//  Settings.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

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
    [self saveSettings];
}

- (void)removePackage:(NSString *)packageName {
    NSMutableArray *packages = [activeSettings objectForKey:@"availablePackages"];
    [packages removeObjectIdenticalTo:packageName];
    [activeSettings setValue:packages forKey:@"availablePackages"];
    [self saveSettings];
}

- (void)setCurrentPackageName:(NSString *)name {
    [activeSettings setValue:name forKey:@"packageName"];
    [self saveSettings];
}

- (void)setDataSetIndex:(int)index {
    [activeSettings setValue:[NSNumber numberWithInt:index] forKey:@"dataSetIndex"];
    [self saveSettings];
}

- (void)setMinLength:(int)length {
    [activeSettings setValue:[NSNumber numberWithInt:length] forKey:@"minLength"];
    [self saveSettings];
}

- (void)setMaxLength:(int)length {
    [activeSettings setValue:[NSNumber numberWithInt:length] forKey:@"maxLength"];
    [self saveSettings];
}

- (void)setSessionLength:(int)length {
    [activeSettings setValue:[NSNumber numberWithInt:length] forKey:@"sessionLength"];
    [self saveSettings];
}

- (void)enableAdaptiveDrill {
    [activeSettings setValue:[NSNumber numberWithBool:YES] forKey:@"adaptiveDrillEnabled"];
    [self saveSettings];
}

- (void)disableAdaptiveDrill {
    [activeSettings setValue:[NSNumber numberWithBool:NO] forKey:@"adaptiveDrillEnabled"];
    [self saveSettings];
}

- (NSString *)currentPackageName {
    return [activeSettings valueForKey:@"packageName"];
}

- (NSArray *)availablePackages {
    return [NSArray arrayWithArray:[activeSettings valueForKey:@"availablePackages"]];
}

- (int)dataSetIndex {
    return [[activeSettings valueForKey:@"dataSetIndex"] intValue];
}

- (int)minLength {
    return [[activeSettings valueForKey:@"minLength"] intValue];
}

- (int)maxLength {
    return [[activeSettings valueForKey:@"maxLength"] intValue];
}

- (int)sessionLength {
    return [[activeSettings valueForKey:@"sessionLength"] intValue];
}

- (BOOL)adaptiveDrillEnabled {
    return [[activeSettings valueForKey:@"adaptiveDrillEnabled"] boolValue];
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
            [activeSettings setValue:[NSNumber numberWithInt:2] forKey:@"minLength"];
            [activeSettings setValue:[NSNumber numberWithInt:5] forKey:@"maxLength"];
            [activeSettings setValue:[NSNumber numberWithInt:5] forKey:@"sessionLength"];
            [activeSettings setValue:[NSNumber numberWithInt:0] forKey:@"dataSetIndex"];
            [activeSettings setValue:[NSNumber numberWithBool:NO]
                              forKey:@"adaptiveDrillEnabled"];
        }
    }
    return self;
}

@end
