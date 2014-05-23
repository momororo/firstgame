//
//  GameScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "GameScene.h"
#import "GameView.h"

@implementation GameScene{

//ジャンプ可否フラグ(YESでジャンプ可能)
bool jumpFlag;

}

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
    
    //スタートラベルがノードにあるときだけ入る処理
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
            //スタートラベルを除去する
            [startLabel removeFromParent];
            //ジャンプ可能フラグをオンに
            jumpFlag = YES;
            
            return;
        }
        return;
    }
    
    //GameOverラベルがノードにあるときだけ入る処理
    if([self childNodeWithName:@"kGameOver"]){
        
        //
            if ([[self childNodeWithName:@"kRetryLabel"] containsPoint:location]) {
                //ゲームシーン画面に飛ぶ
                if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                    [_delegate sceneEscape:self identifier:@"retry"];
                }
            }
           
           if ([[self childNodeWithName:@"kTopLabel"] containsPoint:location]) {
               //ゲームシーン画面に飛ぶ
               if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                [_delegate sceneEscape:self identifier:@"top"];
               }
           }
        return;
    }

    
    
    if(jumpFlag == YES){
        
        //ジャンプ処理
        SKNode *sprite = [self childNodeWithName:kPlayer];
        sprite.physicsBody.velocity = CGVectorMake(0, 500);
        
        //ジャンプ可能フラグをNOにする
        jumpFlag = NO;
    }

}

//オブジェクト同士が衝突した場合に動く処理
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //地面を格納する変数
    SKPhysicsBody *ground;
    //プレイヤーを格納する変数
    SKPhysicsBody *player;
    
    //ビットマスクの処理がちょっと微妙、、、、
	//カテゴリビットマスクからオブジェクトを判定
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        ground = contact.bodyA;
        player = contact.bodyB;
    }else{
        ground = contact.bodyB;
        player = contact.bodyB;
    }
    

    //ground、playerのy座標を取得する処理を行う
    /*イメージ
     if(プレイヤー位置のy座標-(プレイヤーのコンテンツ領域のy座標/2) > 地面位置のy座標+(地面のコンテンツ領域のy座標/2)){
        ジャンプ可能フラグをオンにする
     }
    */
    
}

//1フレーム毎に動作するメソッド
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
            endLabel.name = @"kGameOver";
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
            
            
            //リトライボタンの追加
            SKLabelNode *retryLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            retryLabel.text = @"RETRY";
            retryLabel.fontSize = 20;
            retryLabel.name = @"kRetryLabel";
            //位置調整がうまくいかず。。。。
            retryLabel.position = CGPointMake(CGRectGetMinX(self.frame),
                                              CGRectGetMinY(self.frame));
            retryLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            [self addChild:retryLabel];
            
             
            
            
            //トップ画面の追加
            SKLabelNode *topLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            
            topLabel.text = @"TOP";
            topLabel.fontSize = 20;
            topLabel.name = @"kTopLabel";
            //位置調整がうまくいかず。。。。
            topLabel.position = CGPointMake(CGRectGetMaxX(self.frame),
                                            CGRectGetMinY(self.frame));
            topLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;

            [self addChild:topLabel];
             
            

            
        }
    }];
        

    
}

@end