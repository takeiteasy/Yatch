//
//  Spritesheet.m
//  yatch
//
//  Created by Rory B. Bellows on 19/09/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import "Spritesheet.h"

@implementation Spritesheet {
    SKTexture *original;
    NSMutableArray *clips;
    NSInteger nClips;
    CGSize size;
}

-(id)initWithTexture:(SKTexture*)texture Width:(NSInteger)width {
    if (self == [super init]) {
        original = texture;
        size = CGSizeMake(width, [original size].height);
        nClips = [original size].width / size.width;
        clips = [[NSMutableArray alloc] init];
        float dx = size.width / [original size].width;
        for (int x = 0; x < nClips; ++x)
            [clips addObject:[SKTexture textureWithRect:CGRectMake(x * dx, 0, dx, 1)
                                              inTexture:original]];
    }
    return self;
}

-(id)initWithTextureNamed:(NSString*)name Width:(NSInteger)width {
    return [self initWithTexture:[SKTexture textureWithImageNamed:name]
                           Width:width];
}

-(SKTexture*)getClip:(NSInteger)n {
    if (n >= nClips) {
        NSLog(@"ERROR: Invalid Spite requested from sprite sheet. Out of bounds.");
        return nil;
    }
    return [clips objectAtIndex:n];
}
@end
