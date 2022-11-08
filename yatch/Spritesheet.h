//
//  Spritesheet.h
//  yatch
//
//  Created by Rory B. Bellows on 19/09/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Spritesheet : NSObject
-(id)initWithTexture:(SKTexture*)texture Width:(NSInteger)width;
-(id)initWithTextureNamed:(NSString*)name Width:(NSInteger)width;
-(SKTexture*)getClip:(NSInteger)n;
@end
