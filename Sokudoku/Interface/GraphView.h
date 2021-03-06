//
//  GraphView.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/14/13.
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

#import <Cocoa/Cocoa.h>
@class Package;

typedef enum
{
    AVG_SPEED = 0,
    STUDY_TIME = 1,
    CHARACTER_COUNT = 2,
    CORRECT_RATE = 3,
    STUDY_TIME_WITH_SPEED = 4,
    CORRECT_RATE_WITH_COUNT = 5
} graphTypes;

@interface GraphView : NSView {
@private
    Package *package;

    NSString *tag;
    int timeFrame;
    graphTypes graphType;
}

@property Package *package;
@property NSString *tag;
@property int timeFrame;
@property graphTypes graphType;

@end
