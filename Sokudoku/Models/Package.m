//
//  Package.m
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

#import "Package.h"
#import "History.h"
#import "Character.h"
#import "Event.h"

@implementation Package

@synthesize name;

- (void)addCharacter:(Character *)character {
    [characters addObject:character];
}

- (void)addTag:(NSString *)tag withDescription:(NSString *)description {
    [tags addObject:tag];
    [tagDescriptions addObject:description];
}

- (NSArray *)allTagDescriptions {
    return [NSArray arrayWithArray:tagDescriptions];
}

- (NSString *)tagForDescription:(NSString *)description {
    unsigned long index = [tagDescriptions indexOfObject:description];
    return [tags objectAtIndex:index];
}

- (BOOL)hasTag:(NSString *)tag {
    return [tags containsObject:tag];
}

- (void)setDataSetIndex:(int)index {
    [packageSettings setValue:[NSNumber numberWithInt:index] forKey:@"dataSetIndex"];
    [self saveSettings];
}

- (void)setMinLength:(int)length {
    [packageSettings setValue:[NSNumber numberWithInt:length] forKey:@"minLength"];
    [self saveSettings];
}

- (void)setMaxLength:(int)length {
    [packageSettings setValue:[NSNumber numberWithInt:length] forKey:@"maxLength"];
    [self saveSettings];
}

- (void)setSessionLength:(int)length {
    [packageSettings setValue:[NSNumber numberWithInt:length] forKey:@"sessionLength"];
    [self saveSettings];
}

- (void)enableAdaptiveDrill {
    [packageSettings setValue:[NSNumber numberWithBool:YES] forKey:@"adaptiveDrill"];
    [self saveSettings];
}

- (void)disableAdaptiveDrill {
    [packageSettings setValue:[NSNumber numberWithBool:NO] forKey:@"adaptiveDrill"];
    [self saveSettings];
}

- (void)setCharacterOrder:(BOOL)order {
    [packageSettings setValue:[NSNumber numberWithBool:order] forKey:@"characterOrder"];
    [self saveSettings];
}

- (void)setGraphType:(int)type {
    [packageSettings setValue:[NSNumber numberWithInt:type] forKey:@"graphType"];
    [self saveSettings];
}

- (void)setGraphTime:(int)time {
    [packageSettings setValue:[NSNumber numberWithInt:time] forKey:@"graphTime"];
    [self saveSettings];
}

- (int)dataSetIndex {
    return [[packageSettings valueForKey:@"dataSetIndex"] intValue];
}

- (int)minLength {
    return [[packageSettings valueForKey:@"minLength"] intValue];
}

- (int)maxLength {
    return [[packageSettings valueForKey:@"maxLength"] intValue];
}

- (int)sessionLength {
    return [[packageSettings valueForKey:@"sessionLength"] intValue];
}

- (BOOL)adaptiveDrillEnabled {
    return [[packageSettings valueForKey:@"adaptiveDrill"] boolValue];
}

- (BOOL)characterOrder {
    return [[packageSettings valueForKey:@"characterOrder"] boolValue];
}

- (int)graphType {
    return [[packageSettings valueForKey:@"graphType"] intValue];
}

- (int)graphTime {
    return [[packageSettings valueForKey:@"graphTime"] intValue];
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
        [self addTag:[importTags objectAtIndex:i] withDescription:[importTagDescriptions objectAtIndex:i]];
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

// Path/filenames for package components (as supplied)
- (NSString *)packageFile:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appSupport =
    [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                         NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dir =
    [NSString stringWithFormat:@"%@/Sokudoku/%@", appSupport, name];
    [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES
                            attributes:nil error:nil];
    return [dir stringByAppendingPathComponent:fileName];
}

- (void)load:(NSString *)packageName {
    name = packageName;
    NSDictionary *packageDict = [NSDictionary dictionaryWithContentsOfFile:[self packageFile:@"package.plist"]];
    tags = [NSMutableArray arrayWithArray:[packageDict objectForKey:@"tags"]];
    tagDescriptions = [NSMutableArray arrayWithArray:[packageDict objectForKey:@"tagDescriptions"]];
    packageSettings = [packageDict objectForKey:@"settings"];
    
    NSArray *characterArray = [NSArray arrayWithContentsOfFile:[self packageFile:@"characters.plist"]];
    [characters removeAllObjects];
    for (int i = 0; i < [characterArray count]; i++) {
        Character *character = [[Character alloc] init];
        [character fromDictionary:[characterArray objectAtIndex:i]];
        [self addCharacter:character];
    }
    [history load:[self packageFile:@"history.plist"]];
}

- (void)saveSettings {
    NSMutableDictionary *packageDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [packageDict setValue:[NSArray arrayWithArray:tags] forKey:@"tags"];
    [packageDict setValue:[NSArray arrayWithArray:tagDescriptions]
                   forKey:@"tagDescriptions"];
    [packageDict setValue:[NSDictionary dictionaryWithDictionary:packageSettings]
                   forKey:@"settings"];
    NSString *packageFile = [self packageFile:@"package.plist"];
    [packageDict writeToFile:packageFile atomically:YES];
}

- (void)save {
    [self saveSettings];

    NSMutableArray *characterArray = [NSMutableArray arrayWithCapacity:[characters count]];
    for (int i = 0; i < [characters count]; i++) {
        [characterArray addObject:[[characters objectAtIndex:i] toDictionary]];
    }
    NSString *characterFile = [self packageFile:@"characters.plist"];
    [characterArray writeToFile:characterFile atomically:YES];

    NSString *historyFile = [self packageFile:@"history.plist"];
    [history save:historyFile];
}

// Used for selecting characters by average speed when generating questions
- (NSString *)objectForIndex:(float)index fromList:(NSArray *)list {
    float left = index;
    for (int i = 0; i < [list count]; i++) {
        left -= [[[list objectAtIndex:i] objectAtIndex:1] floatValue];
        if (left < 0) {
            return [[list objectAtIndex:i] objectAtIndex:0];
        }
    }
    return nil;
}

// Generate new "question" for drill within the specific length for the given tag
// wieght = whether or not to prioritize slower characters
- (NSArray *)generateWithMin:(int)min withMax:(int)max withWeight:(BOOL)weight forTag:(NSString *)tag {
    float totalWeight = 0;
    NSMutableArray *charSet = [NSMutableArray arrayWithCapacity:[characters count]];
    for (int i = 0; i < [characters count]; i++) {
        NSString *literal = [[characters objectAtIndex:i] literal];
        float speed = 1;
        if (weight) {
            speed = powf([[characters objectAtIndex:i] averageSpeed], 2);
        }
        if ([[characters objectAtIndex:i] hasTag:tag]) {
            totalWeight += speed;
            NSArray *temp = [NSArray arrayWithObjects:literal,
                             [NSNumber numberWithFloat:speed], nil];
            [charSet addObject:temp];
        }
    }
    int length = min;
    if (max > min) {
        length += arc4random() % (max - min + 1);
    }
    NSMutableArray *rc = [[NSMutableArray alloc] initWithCapacity:length];
    for (int i = 0; i < length; i++) {
        float index = (float)(arc4random() % (uint)(totalWeight * 1000)) / 1000;
        [rc addObject:[self objectForIndex:index fromList:charSet]];
    }
    return [NSArray arrayWithArray:rc];
}

// Generates events for each character and stores them in the package history
- (void)event:(NSArray *)forCharacters :(float)time :(BOOL)correct {
    for (int i = 0; i < [forCharacters count]; i++) {
        Character *current = [forCharacters objectAtIndex:i];
        Event *event = [current newEventForLength:(int)[forCharacters count] withTime:time wasCorrect:correct];
        [history addEvent:event];
    }
}

// Return an array of characters for the given literals
- (NSArray *)charactersForLiterals:(NSArray *)literals {
    NSMutableArray *qChars = [[NSMutableArray alloc] initWithCapacity:[literals count]];
    for (int i = 0; i < [literals count]; i++) {
        for (int j = 0; j < [characters count]; j++) {
            if ([[[characters objectAtIndex:j] literal] isEqualToString:[literals objectAtIndex:i]]) {
                [qChars addObject:[characters objectAtIndex:j]];
            }
        }
    }
    return [NSArray arrayWithArray:qChars];
}

// Return all the possible pronunciations for the given characters
- (NSArray *)getPronunciations:(NSArray *)qChars withLiteral:(BOOL)includeLiteral {
    NSArray *allPron = [[NSArray alloc] initWithObjects:@"", nil];
    for (int i = 0; i < [qChars count]; i++) {
        allPron = [[qChars objectAtIndex:i] appendAllPronunciations:allPron withLiterals:includeLiteral];
    }
    return allPron;
}

- (NSString *)allPronunciations:(NSArray *)literals {
    NSArray *qChars = [self charactersForLiterals:literals];

    NSArray *allPron = [self getPronunciations:qChars withLiteral:NO];
    NSString *rc = [allPron componentsJoinedByString:@", "];
    
    return rc;
}

- (BOOL)test:(NSArray *)question against:(NSString *)answer withTime:(float)time {
    // Get characters to match question
    NSArray *qChars = [self charactersForLiterals:question];

    // Generate all pronunciations to test against
    NSArray *allPron = [self getPronunciations:qChars withLiteral:YES];

    // Any match results in a positive result
    for (int i = 0; i < [allPron count]; i++) {
        if ([[allPron objectAtIndex:i] isEqualToString:answer]) {
            [self event:qChars:time:YES];
            return YES;
        }
    }

    // Incorect answers get a ten-second penalty
    [self event:qChars:time:NO];
    return NO;
}

// Character stats for character window
- (NSArray *)statsForTag:(NSString *)tag fromTop:(BOOL)top {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[characters count]];
    for (int i = 0; i < [characters count]; i++) {
        Character *character = [characters objectAtIndex:i];
        if ([character hasTag:tag]) {
            float time = [character averageSpeed];
            if ([character tested] == NO) {
                time = 0;
            }
            float percentage = 1.0;
            if ([character correctAnswers] + [character incorrectAnswers] > 0) {
                percentage = (float)[character correctAnswers] / (float)([character correctAnswers] + [character incorrectAnswers]);
            }
            [array addObject:[NSArray arrayWithObjects:[character literal],
                              [NSNumber numberWithFloat:time],
                              [NSNumber numberWithFloat:percentage], nil]];
        }
    }
    NSArray *fullArray;

    // Sort by slowest or fastest
    if (top) {
        fullArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj2 objectAtIndex:1] compare:[obj1 objectAtIndex:1]];
        } ];
    } else {
        fullArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectAtIndex:1] compare:[obj2 objectAtIndex:1]];
        } ];
    }

    // Limit to 100 characters (too many more overwhelms the window view)
    if ([fullArray count] > 150) {
        NSRange range = NSMakeRange(0, 150);
        return [fullArray subarrayWithRange:range];
    } else {
        return fullArray;
    }
}

- (NSArray *)eventsForTag:(NSString *)tag {
    // Build dictionary with characters keyed by literal value
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithCapacity:[characters count]];
    for (int i = 0; i < [characters count]; i++) {
        [dict setObject:[characters objectAtIndex:i] forKey:[[characters objectAtIndex:i] literal]];
    }

    // Generate list of events filtered by characters with tags
    NSMutableArray *tagEvents = [NSMutableArray arrayWithCapacity:[characters count]];
    NSArray *allEvents = [history allEvents];
    for (int i = 0; i < [allEvents count]; i++) {
        Event *event = [allEvents objectAtIndex:i];
        Character *character = [dict objectForKey:[event character]];
        if ([character hasTag:tag]) {
            [tagEvents addObject:event];
        }
    }
    return [NSArray arrayWithArray:tagEvents];
}

- (float)dailyAverage:(int)period {
    float time = 0;
    NSArray *allEvents = [history allEvents];

    for (int i = 0; i < [allEvents count]; i++) {
        Event *event = [allEvents objectAtIndex:i];
        float offset = [[event timeStamp] timeIntervalSinceNow];
        if (-offset < 24 * 60 * 60 * period) {
            time += [event partialTime];
        }
    }
    return time / (float)period / 60;
}

- (float)speedAverage:(int)period {
    float time = 0;
    float events = 0;
    NSArray *allEvents = [history allEvents];
    
    for (int i = 0; i < [allEvents count]; i++) {
        Event *event = [allEvents objectAtIndex:i];
        float offset = [[event timeStamp] timeIntervalSinceNow];
        if (-offset < 24 * 60 * 60 * period) {
            time += [event weightedTime];
            events += [event weight];
        }
    }
    if (events > 0) {
        return time / events;
    } else {
        return 0;
    }
}

- (float)dailyAverage:(int)period forTag:(NSString *)tag {
    float time = 0;
    NSArray *allEvents = [self eventsForTag:tag];
    
    for (int i = 0; i < [allEvents count]; i++) {
        Event *event = [allEvents objectAtIndex:i];
        float offset = [[event timeStamp] timeIntervalSinceNow];
        if (-offset < 24 * 60 * 60 * period) {
            time += [event partialTime];
        }
    }
    return time / (float)period / 60;
}

- (float)speedAverage:(int)period forTag:(NSString *)tag {
    float time = 0;
    float events = 0;
    NSArray *allEvents = [self eventsForTag:tag];
    
    for (int i = 0; i < [allEvents count]; i++) {
        Event *event = [allEvents objectAtIndex:i];
        float offset = [[event timeStamp] timeIntervalSinceNow];
        if (-offset < 24 * 60 * 60 * period) {
            time += [event weightedTime];
            events += [event weight];
        }
    }
    if (events > 0) {
        return time / events;
    } else {
        return 0;
    }
}

- (void)clearHistory {
    [history clear];
}

- (void)reset {
    [history clear];
    for (int i = 0; i < [characters count]; i++) {
        [[characters objectAtIndex:i] reset];
    }
}

- (id)init {
    if (self = [super init]) {
        name = nil;

        history = [[History alloc] init];
        
        characters = [NSMutableArray arrayWithCapacity:10];
        tags = [NSMutableArray arrayWithCapacity:1];
        tagDescriptions = [NSMutableArray arrayWithCapacity:1];
        packageSettings = [NSMutableDictionary dictionaryWithCapacity:5];
        
        [packageSettings setValue:[NSNumber numberWithInt:0] forKey:@"dataSetIndex"];
        [packageSettings setValue:[NSNumber numberWithInt:2] forKey:@"minLength"];
        [packageSettings setValue:[NSNumber numberWithInt:5] forKey:@"maxLength"];
        [packageSettings setValue:[NSNumber numberWithInt:5] forKey:@"sessionLength"];
        [packageSettings setValue:[NSNumber numberWithBool:NO] forKey:@"adaptiveDrill"];
        [packageSettings setValue:[NSNumber numberWithBool:NO] forKey:@"characterOrder"];
        [packageSettings setValue:[NSNumber numberWithInt:0] forKey:@"graphType"];
        [packageSettings setValue:[NSNumber numberWithInt:0] forKey:@"graphTime"];
    }
    return self;
}

@end
