//
//  Settings.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject {
@private
    NSString *settingsFile;
    NSMutableDictionary *activeSettings;
}

- (void) setCurrentPackageName:(NSString *)name;
- (void) setAvailablePackages:(NSArray *)packageNames;
- (void) setDataSetIndex:(int)index;
- (void) setMinLength:(int)length;
- (void) setMaxLength:(int)length;
- (void) setSessionLength:(int)length;
- (void) enableAdaptiveDrill;
- (void) disableAdaptiveDrill;

- (NSString *) currentPackageName;
- (NSArray *) availablePackages;
- (int) dataSetIndex;
- (int) minLength;
- (int) maxLength;
- (int) sessionLength;
- (BOOL) adaptiveDrillEnabled;

@end
