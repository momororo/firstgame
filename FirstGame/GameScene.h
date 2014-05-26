//
//  GameScene.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define     kPlayer     @"Player"
#define     kGround     @"Ground"

static const uint32_t groundCategory = 0x1 << 0;
static const uint32_t playerCategory = 0x1 << 1;


@interface GameScene : SKScene <SKPhysicsContactDelegate>
{
    SKLabelNode *startLabel;
}
@property (weak,nonatomic)id delegate;
@end
