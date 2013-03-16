//
//  Settings.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Foundation/Foundation.h>

// Class for storing all the program settings
@interface Settings : NSObject {
@private
    NSString *settingsFile;
    NSMutableDictionary *activeSettings;
}

- (void) addPackage:(NSString *)packageName;
- (void) forgetPackage:(NSString *)packageName;
- (void) deletePackage:(NSString *)packageName;
- (void) rememberPackage:(NSString *)packageName;

- (void) setCurrentPackageName:(NSString *)name;
- (void) setDataSetIndex:(int)index;
- (void) setMinLength:(int)length;
- (void) setMaxLength:(int)length;
- (void) setSessionLength:(int)length;
- (void) enableAdaptiveDrill;
- (void) disableAdaptiveDrill;

- (NSString *) currentPackageName;
- (NSArray *) availablePackages;
- (NSArray *) allPackages;
- (int) dataSetIndex;
- (int) minLength;
- (int) maxLength;
- (int) sessionLength;
- (BOOL) adaptiveDrillEnabled;

@end
