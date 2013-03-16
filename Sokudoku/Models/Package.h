//
//  Package.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

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

- (void) save;

- (NSString *) import:(NSString *)fileName;
- (void) load:(NSString *)packageName;

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
