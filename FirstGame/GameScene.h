//
//  GameScene.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"

#define     kPlayer     @"Player"
#define     kGround     @"Ground"
#define     kWall       @"Wall"



@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (weak,nonatomic)id delegate;
@end
