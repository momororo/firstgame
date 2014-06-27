//
//  Sensor.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Sensor.h"


@implementation Sensor

+(SKSpriteNode *)getSensor{
    return sensor;
}

+(void)setSensoFrame:(CGRect)frame{
    //透明のオブジェクトを生成(センサー)
    sensor = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(30,frame.size.height)];
    
    sensor.name = @"kSensor";
    sensor.position = CGPointMake(CGRectGetMidX(frame) * 1.5, CGRectGetMidY(frame));
    sensor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sensor.size.width,sensor.size.height )];
    
    sensor.physicsBody.affectedByGravity = NO;
    
    sensor.physicsBody.categoryBitMask = sensorCategory;
    sensor.physicsBody.collisionBitMask = 0;
    sensor.physicsBody.contactTestBitMask = groundCategory;
}


@end
