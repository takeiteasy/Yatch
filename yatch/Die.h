//
//  Die.h
//  yatch
//
//  Created by Rory B. Bellows on 26/09/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Die : SKSpriteNode
@property BOOL selected;
@property int value;

-(id)initWithPosition:(CGPoint)pos andVelocity:(CGVector)vel andSize:(CGSize)size andMass:(float)mass;
-(void)enable;
-(void)disable;
@end
