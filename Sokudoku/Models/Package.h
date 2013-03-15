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

- (void) newEvent:(NSArray *)chars:(float)totalTime;

- (void) save;

- (NSString *) import:(NSString *)fileName;
- (void) load:(NSString *)packageName;

- (NSArray *) generate:(int)min:(int)max:(BOOL)weight:(NSString *)tag;
- (BOOL) test:(NSArray *)question:(NSString *)answer:(float)time;

- (NSArray *) statsForTag:(NSString *)tag:(BOOL)top;

- (NSArray *) allEvents:(NSString *)tag;

- (void) clearHistory;
- (void) reset;

@end
