//
//  Die.m
//  yatch
//
//  Created by Rory B. Bellows on 26/09/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import "Die.h"

static float rndFloatRange(float min, float max) {
    return min + ((float)arc4random() / UINT32_MAX) * (max - min);
}

@implementation Die
@synthesize selected;

-(id)initWithPosition:(CGPoint)pos andVelocity:(CGVector)vel andSize:(CGSize)size andMass:(float)mass {
    if (self == [super init]) {
        [self setPosition:pos];
        [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:size]];
        [[self physicsBody] setDynamic:YES];
        [[self physicsBody] setMass:mass];
        [[self physicsBody] setVelocity:vel];
        [[self physicsBody] setAngularVelocity:rndFloatRange(-50.f, 30.f)];
        [[self physicsBody] setAffectedByGravity:YES];
        [[self physicsBody] setAllowsRotation:YES];
        [[self physicsBody] setRestitution:.1f];
        [[self physicsBody] setCategoryBitMask:0x1 << 0];
        [self setSelected:NO];
    }
    return self;
}

-(void)enable {
    [[self physicsBody] setDynamic:YES];
}

-(void)disable {
    [[self physicsBody] setDynamic:NO];
}
@end
