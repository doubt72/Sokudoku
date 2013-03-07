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

- (BOOL) hasTag:(NSString *)tag;

- (void) newEvent:(NSArray *)chars:(float)totalTime;

- (void) save;

- (NSString *) import:(NSString *)fileName;
- (void) load:(NSString *)name;

@end
