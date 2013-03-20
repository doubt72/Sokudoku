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
    
    History *history;
    NSMutableArray *characters;
    NSMutableArray *tags;
    NSMutableArray *tagDescriptions;
}

@property(copy) NSString *name;

- (void) addCharacter:(Character *)character;
- (void) addTag:(NSString *)tag:(NSString *)description;
- (NSArray *) allTagDescriptions;

- (NSString *) tagForDescription:(NSString *)description;

- (BOOL) hasTag:(NSString *)tag;

- (void) save:(NSDictionary *)settings;

- (NSString *) import:(NSString *)fileName;
- (NSDictionary *) load:(NSString *)packageName;

// Generate new "question" for drill within the specific length for the given tag
// wieght = whether or not to prioritize slower characters
- (NSArray *) generate:(int)min:(int)max:(BOOL)weight:(NSString *)tag;

// Test answer against question and record event as appropriate
- (BOOL) test:(NSArray *)question:(NSString *)answer:(float)time;

// Array of character information for displaying average speeds in the character window
- (NSArray *) statsForTag:(NSString *)tag:(BOOL)top;

// Array of events filtered by tag for history graph
- (NSArray *) allEvents:(NSString *)tag;

- (void) clearHistory;
- (void) reset;

@end
