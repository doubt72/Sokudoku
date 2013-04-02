//
//  Package.h
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

#import <Foundation/Foundation.h>
@class History;
@class Character;

@interface Package : NSObject {
@private
    NSString *name;
    
    NSMutableDictionary *packageSettings;
    
    History *history;
    NSMutableArray *characters;
    NSMutableArray *tags;
    NSMutableArray *tagDescriptions;
}

@property(copy) NSString *name;

- (void) addCharacter:(Character *)character;

// Tags
- (void) addTag:(NSString *)tag withDescription:(NSString *)description;
- (NSArray *) allTagDescriptions;
- (NSString *) tagForDescription:(NSString *)description;
- (BOOL) hasTag:(NSString *)tag;

// Settings
- (void) setDataSetIndex:(int)index;
- (void) setMinLength:(int)length;
- (void) setMaxLength:(int)length;
- (void) setSessionLength:(int)length;
- (void) enableAdaptiveDrill;
- (void) disableAdaptiveDrill;

- (void) setCharacterOrder:(BOOL)order;
- (void) setGraphType:(int)type;
- (void) setGraphTime:(int)time;

- (int) dataSetIndex;
- (int) minLength;
- (int) maxLength;
- (int) sessionLength;
- (BOOL) adaptiveDrillEnabled;

- (BOOL) characterOrder;
- (int) graphType;
- (int) graphTime;

- (void) saveSettings;

// File access
- (NSString *) import:(NSString *)fileName;
- (void) load:(NSString *)packageName;
- (void) save;

// Generate new "question" for drill within the specific length for the given tag
// wieght = whether or not to prioritize slower characters
- (NSArray *) generateWithMin:(int)min withMax:(int)max withWeight:(BOOL)weight forTag:(NSString *)tag;

// Test answer against question and record event as appropriate
- (BOOL) test:(NSArray *)question against:(NSString *)answer withTime:(float)time;

// Get all pronunciations (in a comma delimited string) for a set of literals
- (NSString *) allPronunciations:(NSArray *)literals;

// Array of character information for displaying average speeds in the character window
- (NSArray *) statsForTag:(NSString *)tag fromTop:(BOOL)top;

// Array of events filtered by tag for history graph
- (NSArray *) eventsForTag:(NSString *)tag;

- (float) dailyAverage:(int)period;
- (float) speedAverage:(int)period;
- (float) dailyAverage:(int)period forTag:(NSString *)tag;
- (float) speedAverage:(int)period forTag:(NSString *)tag;

- (void) clearHistory;
- (void) reset;

@end
