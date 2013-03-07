//
//  Package.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "Package.h"
#import "History.h"
#import "Character.h"
#import "Event.h"

@implementation Package

@synthesize name;

- (void)addCharacter:(Character *)character {
    [characters addObject:character];
}

- (void)addTag:(NSString *)tag :(NSString *)description {
    [tags addObject:tag];
    [tagDescriptions addObject:description];
}

- (NSArray *)allTagDescriptions {
    return [NSArray arrayWithArray:tagDescriptions];
}

- (BOOL)hasTag:(NSString *)tag {
    return [tags containsObject:tag];
}

- (void)newEvent:(NSArray *)chars :(float)totalTime {
    unsigned long int length = [chars count];
    for (int i = 0; i < length; i++) {
        Character *character = [chars objectAtIndex:i];
        Event *event = [character newEvent:length:totalTime];
        [history addEvent:event];
    }
}

- (NSString *)import:(NSString *)fileName {
    NSDictionary *import = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if (import == nil) {
        return @"Unable to parse supplied file";
    }
    NSArray *importTags = [import objectForKey:@"tags"];
    NSArray *importTagDescriptions = [import objectForKey:@"tagDescriptions"];
    if ([importTags count] != [importTagDescriptions count]) {
        return @"Tag and Tag Description arrays have different counts";
    }
    for (int i = 0; i < [importTags count]; i++) {
        [self addTag:[importTags objectAtIndex:i]:[importTagDescriptions objectAtIndex:i]];
    }
    NSArray *importCharacters = [import objectForKey:@"characters"];
    for (int i = 0; i < [importCharacters count]; i++) {
        Character *character = [[Character alloc] init];
        NSDictionary *current = [importCharacters objectAtIndex:i];
        NSString *literal = [current objectForKey:@"literal"];
        [character setLiteral:literal];
        NSArray *pronunciations = [current objectForKey:@"pronunciations"];
        for (int j = 0; j < [pronunciations count]; j++) {
            [character addPronunciation:[pronunciations objectAtIndex:j]];
        }
        NSArray *cTags = [current objectForKey:@"tags"];
        for (int j = 0; j < [cTags count]; j++) {
            NSString *cTag = [cTags objectAtIndex:j];
            if ([self hasTag:cTag]) {
                [character addTag:cTag];
            } else {
                return [NSString stringWithFormat:@"unexpected tag %@ for character %@", literal, cTag];
            }
        }
        [self addCharacter:character];
    }
    name = [import objectForKey:@"name"];
    return nil;
}

- (void)save {
    ;
}

- (void)load:(NSString *)name {
    ;
}

- (id)init {
    if (self = [super init]) {
        name = nil;

        history = [[History alloc] init];
        
        characters = [NSMutableArray arrayWithCapacity:10];
        tags = [NSMutableArray arrayWithCapacity:1];
        tagDescriptions = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

@end
