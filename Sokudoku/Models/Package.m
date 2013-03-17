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

- (void)addTag:(NSString *)tag :(NSString *)description {
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

- (void)save {
    NSMutableDictionary *packageDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [packageDict setValue:[NSArray arrayWithArray:tags] forKey:@"tags"];
    [packageDict setValue:[NSArray arrayWithArray:tagDescriptions] forKey:@"tagDescriptions"];
    NSString *packageFile = [self packageFile:@"package.plist"];
    [packageDict writeToFile:packageFile atomically:YES];
    
    NSMutableArray *characterArray = [NSMutableArray arrayWithCapacity:[characters count]];
    for (int i = 0; i < [characters count]; i++) {
        [characterArray addObject:[[characters objectAtIndex:i] toDictionary]];
    }
    NSString *characterFile = [self packageFile:@"characters.plist"];
    [characterArray writeToFile:characterFile atomically:YES];

    NSString *historyFile = [self packageFile:@"history.plist"];
    [history save:historyFile];
}

- (void)load:(NSString *)packageName {
    name = packageName;
    NSDictionary *packageDict = [NSDictionary dictionaryWithContentsOfFile:[self packageFile:@"package.plist"]];
    tags = [NSMutableArray arrayWithArray:[packageDict objectForKey:@"tags"]];
    tagDescriptions = [NSMutableArray arrayWithArray:[packageDict objectForKey:@"tagDescriptions"]];
    
    NSArray *characterArray = [NSArray arrayWithContentsOfFile:[self packageFile:@"characters.plist"]];
    [characters removeAllObjects];
    for (int i = 0; i < [characterArray count]; i++) {
        Character *character = [[Character alloc] init];
        [character fromDictionary:[characterArray objectAtIndex:i]];
        [self addCharacter:character];
    }
    [history load:[self packageFile:@"history.plist"]];
}

// Used for selecting characters by average speed when generating questions
- (NSString *)objectForIndex:(float)index:(NSArray *)list {
    float left = index;
    for (int i = 0; i < [list count]; i++) {
        left -= [[[list objectAtIndex:i] objectAtIndex:1] floatValue];
        if (left < 0) {
            NSLog(@"left after i: %d, %f", i, left);
            return [[list objectAtIndex:i] objectAtIndex:0];
        }
    }
    return nil;
}

// Generate new "question" for drill within the specific length for the given tag
// wieght = whether or not to prioritize slower characters
- (NSArray *)generate:(int)min:(int)max:(BOOL)weight:(NSString *)tag {
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
        NSLog(@"tot, index: %f, %f", totalWeight, index);
        [rc addObject:[self objectForIndex:index:charSet]];
    }
    return [NSArray arrayWithArray:rc];
}

// Generates events for each character and stores them in the package history
- (void)event:(NSMutableArray *)forCharacters :(float)time {
    for (int i = 0; i < [forCharacters count]; i++) {
        Character *current = [forCharacters objectAtIndex:i];
        Event *event = [current newEvent:[forCharacters count] :time];
        [history addEvent:event];
    }
}

- (BOOL)test:(NSArray *)question :(NSString *)answer :(float)time {
    // Get characters to match question
    NSMutableArray *qChars = [[NSMutableArray alloc] initWithCapacity:[question count]];
    for (int i = 0; i < [question count]; i++) {
        for (int j = 0; j < [characters count]; j++) {
            if ([[[characters objectAtIndex:j] literal] isEqualToString:[question objectAtIndex:i]]) {
                [qChars addObject:[characters objectAtIndex:j]];
            }
        }
    }

    // Generate all pronunciations to test against
    NSArray *allPron = [[NSArray alloc] initWithObjects:@"", nil];
    for (int i = 0; i < [qChars count]; i++) {
        allPron = [[qChars objectAtIndex:i] appendAllPronunciations:allPron];
    }

    // Any match results in a positive result
    for (int i = 0; i < [allPron count]; i++) {
        if ([[allPron objectAtIndex:i] isEqualToString:answer]) {
            [self event:qChars:time];
            return YES;
        }
    }

    // Incorect answers get a ten-second penalty
    [self event:qChars:time + 10.0 * [qChars count]];
    return NO;
}

// Character stats for character window
- (NSArray *)statsForTag:(NSString *)tag:(BOOL)top {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[characters count]];
    for (int i = 0; i < [characters count]; i++) {
        Character *character = [characters objectAtIndex:i];
        if ([character hasTag:tag]) {
            float time = [character averageSpeed];
            if ([character tested] == NO) {
                time = 0;
            }
            [array addObject:[NSArray arrayWithObjects:[character literal],
                              [NSNumber numberWithFloat:time], nil]];
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
    if ([fullArray count] > 100) {
        NSRange range = NSMakeRange(0, 100);
        return [fullArray subarrayWithRange:range];
    } else {
        return fullArray;
    }
}

- (NSArray *) allEvents:(NSString *)tag {
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
    }
    return self;
}

@end
