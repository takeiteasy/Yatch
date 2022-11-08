//
//  Scorecard.m
//  yatch
//
//  Created by Rory B. Bellows on 31/10/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import "Scorecard.h"

@implementation Scorecard
-(id)init {
    if (self == [super init]) {
        scores = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn
                                       valueOptions:NSMapTableStrongMemory];
        for (int i = 0; i < nScoreNames; ++i)
            [scores setObject:[NSNumber numberWithInt:-1] forKey:scoreNames[i]];
        
        bonusAchieved = NO;
        scoreTotal = 0;
    }
    return self;
    
}
-(int)getScore:(NSString*)name {
    return [[scores objectForKey:name] intValue];
}
@end
