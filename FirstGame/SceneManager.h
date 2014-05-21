//
//  SceneManager.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "TitleScene.h"
#import "GameScene.h"
#import "ResultScene.h"

@interface SceneManager : NSObject

+(TitleScene *)titleScene:(CGSize)size;
+(GameScene *)gameScene:(CGSize)size;
+(ResultScene *)resultScene:(CGSize)size;

+(void)sceneCange:(SKView *)view New:(SKScene *)newScene Duration:(NSTimeInterval)sec;

@end
