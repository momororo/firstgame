//
//  GameScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor greenColor];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"ゲーム画面";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        //地面の設定
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor]
                                                            size:CGSizeMake(self.frame.size.width, 25)];
        ground.name = kGround;
        ground.position = CGPointMake(CGRectGetMidX(self.frame),ground.size.height/2);
        
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ground.size.width, ground.size.height)];
        ground.physicsBody.affectedByGravity = NO;
        ground.physicsBody.categoryBitMask = groundCategory;
        ground.physicsBody.collisionBitMask = 0;
        
      
        
        [self addChild:ground];
        
        //プレイキャラの設定
        SKSpriteNode *player = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor]
                                                            size:CGSizeMake(20, 40)];
        player.name = kPlayer;
        player.position = CGPointMake(CGRectGetMidX(self.frame)/2, 100 );
        [self addChild:player];
        player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
        player.physicsBody.allowsRotation = NO;
        player.physicsBody.categoryBitMask = playerCategory;
        player.physicsBody.collisionBitMask = groundCategory;
        player.physicsBody.contactTestBitMask = groundCategory;
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    SKNode *sprite = [self childNodeWithName:kPlayer];
    sprite.physicsBody.velocity = CGVectorMake(0, 500);
    
    
    SKNode *sprite2 = [self childNodeWithName:kGround];
    [sprite2 runAction:[SKAction repeatActionForever:
                        [SKAction sequence:@[[SKAction moveToX:-100 duration:1.0],
                                            [SKAction moveToX:600 duration:0.0]
                                            ]
                        ]
                       ]
     ];

}

@end
