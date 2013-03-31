//
//  Character.m
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

#import "Character.h"
#import "Event.h"

@implementation Character

@synthesize literal;
@synthesize incorrectAnswers, correctAnswers;

// Because characters are only tested in isolation when the string being tested is
// one character long, we weigh the results so that long strings affect the average
// time less than shorter strings
- (Event *)newEventForLength:(int)length withTime:(float)time wasCorrect:(BOOL)correct {
    float weight = 1.0 / (length * length);
    timesTested += weight;
    totalTime += time / length * weight;

    Event *event = [[Event alloc] init];
    [event setCharacter:[NSString stringWithString:literal]];
    [event setTimeStamp:[NSDate date]];
    [event setWeight:weight];
    [event setPartialTime:time / length];
    [event setCorrect:correct];
    if (correct) {
        correctAnswers++;
        [event setWeightedTime:time / length * weight];
    } else {
        totalTime += 10.0 / length * weight;
        incorrectAnswers++;
        [event setWeightedTime:(time + 10) / length * weight];
    }
    return event;
}

- (float)averageSpeed {
    if (timesTested == 0.0) {
        return 10.0;
    }
    return totalTime / timesTested;
}

- (BOOL)tested {
    if (timesTested > 0.0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)addTag:(NSString *)tag {
    [tags addObject:tag];
}

- (BOOL)hasTag:(NSString *)tag {
    return [tags containsObject:tag];
}

- (void)addPronunciation:(NSString *)pronunciation {
    [pronunciations addObject:pronunciation];
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setValue:literal forKey:@"literal"];
    [dict setValue:[NSArray arrayWithArray:pronunciations] forKey:@"pronunciations"];
    [dict setValue:[NSArray arrayWithArray:tags] forKey:@"tags"];
    [dict setValue:[NSNumber numberWithFloat:timesTested] forKey:@"timesTested"];
    [dict setValue:[NSNumber numberWithFloat:totalTime] forKey:@"totalTimes"];
    [dict setValue:[NSNumber numberWithInt:correctAnswers] forKey:@"correctAnswers"];
    [dict setValue:[NSNumber numberWithInt:incorrectAnswers] forKey:@"incorrectAnswers"];
    return dict;
}

- (void)fromDictionary:(NSMutableDictionary *)dict {
    literal = [dict objectForKey:@"literal"];
    pronunciations = [NSMutableArray arrayWithArray:[dict objectForKey:@"pronunciations"]];
    tags = [NSMutableArray arrayWithArray:[dict objectForKey:@"tags"]];
    timesTested = [[dict objectForKey:@"timesTested"] floatValue];
    totalTime = [[dict objectForKey:@"totalTimes"] floatValue];
    correctAnswers = [[dict objectForKey:@"correctAnswers"] intValue];
    incorrectAnswers = [[dict objectForKey:@"incorrectAnswers"] intValue];
}

// This is used for generating all possible pronunciations (for testing correct answers).
// This takes a list and appends all the possible pronunciation to the end of the
// supplied strings and returns them in a list
- (NSArray *)appendAllPronunciations:(NSArray *)list withLiterals:(BOOL)includeLiteral {
    NSMutableArray *rc = [[NSMutableArray alloc] initWithCapacity:[list count] * [pronunciations count]];
    for (int i = 0; i < [list count]; i++) {
        for (int j = 0; j < [pronunciations count]; j++) {
            [rc addObject:[NSString stringWithFormat:@"%@%@",
                           [list objectAtIndex:i], [pronunciations objectAtIndex:j]]];
        }
        if (includeLiteral) {
            [rc addObject:[NSString stringWithFormat:@"%@%@",
                           [list objectAtIndex:i], literal]];
        }
    }
    return [NSArray arrayWithArray:rc];
}

- (void)reset {
    timesTested = 0;
    totalTime = 0;
}

- (id)init {
    if (self = [super init]) {
        literal = nil;
        
        tags = [NSMutableArray arrayWithCapacity:1];
        pronunciations = [NSMutableArray arrayWithCapacity:1];
        
        timesTested = 0;
        totalTime = 0;
    }
    return self;
}

@end
