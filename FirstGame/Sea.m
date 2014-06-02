//
//  Sea.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Sea.h"

@implementation Sea

+(SKSpriteNode *)getSea{
    
    return sea;
    
}
+(void)setSeaFrame:(CGRect)frame{
     sea = [SKSpriteNode spriteNodeWithImageNamed:@"umi.png"];
     sea.position = CGPointMake(CGRectGetMidX(frame),sea.frame.size.height/2);

}

@end
