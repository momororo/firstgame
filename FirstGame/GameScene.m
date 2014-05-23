//
//  GameScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "GameScene.h"
#import "GameView.h"

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor greenColor];
        
        startLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        startLabel.text = @"GAME START";
        startLabel.fontSize = 30;
        startLabel.name = @"kStartLabel";
        startLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:startLabel];
        
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
    
    //ゲームスタートが押されたらボタンを消去する
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    //スタートラベルがある時だけ入るように変更
    if([self childNodeWithName:@"kStartLabel"]){
        if ([startLabel containsPoint:location]) {
            SKNode *sprite2 = [self childNodeWithName:kGround];
            [sprite2 runAction:[SKAction repeatActionForever:
                                [SKAction sequence:@[[SKAction moveToX:-100 duration:1.0],
                                                 [SKAction moveToX:600 duration:0.0]
                                                 ]
                             ]
                            ]
             ];
            [startLabel removeFromParent];
            return;
        }
        return;
    }
    
    
    SKNode *sprite = [self childNodeWithName:kPlayer];
    sprite.physicsBody.velocity = CGVectorMake(0, 500);
    
    
    
                                            
                        
            

}

-(void)didSimulatePhysics{
    
	//プレイヤーが画面外に落ちた時にゲームオーバーとする
	[self enumerateChildNodesWithName:kPlayer usingBlock:^(SKNode *node, BOOL *stop) {
		CGPoint pt = [self convertPoint:node.position toNode:self];
        CGFloat	h = self.size.height;
        //画面外か判定
		if(pt.y < -(h) || pt.y > h){
			//ゲームオーバー
            
            SKLabelNode *endLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            
            endLabel.text = @"GAME OVER";
            endLabel.fontSize = 30;
            endLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame));
            
            //ラベル追加
            [self addChild:endLabel];
            
            //キャラクターの削除
            [node removeFromParent];
            
            
            //地面のスクロールをストップ
            SKNode *sprite = [self childNodeWithName:kGround];
            //アクションを削除
            [sprite removeAllActions];
            
            //結果画面へ飛ぶ
            if ([_delegate respondsToSelector:@selector(sceneEscape:)]) {
                [_delegate sceneEscape:self];
            }
            
            
        }
    }];
        

    
}

@end
