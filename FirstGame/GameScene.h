//
//  GameScene.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "Ground.h"
#import "Wall.h"
#import "Sensor.h"
#import "Sea.h"
#import "Fish.h"
#import "Island.h"
#import "Cloud.h"
#import "Emergency.h"
#import <GameKit/GameKit.h>


#define     kPlayer     @"Player"
#define     kGround     @"Ground"
#define     kWall       @"Wall"
#define     kFish       @"Fish"


@interface GameScene : SKScene <SKPhysicsContactDelegate,GKGameCenterControllerDelegate>

@property (weak,nonatomic)id delegate;
@end
