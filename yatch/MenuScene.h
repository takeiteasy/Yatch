//
//  MenuScene.h
//  yatch
//
//  Created by George Watson on 10/11/2022.
//  Copyright © 2022 Rory B. Bellows. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface MenuScene : SKScene {
    SKLabelNode *title;
    SKLabelNode *playLabel;
    SKShapeNode *playButton;
    SKLabelNode *highscoreLabel;
}
@end
