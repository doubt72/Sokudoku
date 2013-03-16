//
//  Event.h
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

@interface Event : NSObject {
@private
    NSString *character;
    NSDate *timeStamp;
    
    float weight;
    float weightedTime;
}

@property(copy) NSString *character;
@property(copy) NSDate *timeStamp;
@property float weight, weightedTime;

// For loading and saving records
- (NSMutableDictionary *) toDictionary;
- (void) fromDictionary:(NSMutableDictionary *)dict;

@end
