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
    BOOL _gameStart;


//ジャンプ可否フラグ(YESでジャンプ可能)
bool jumpFlag;

}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
                
        /* Setup your scene here */
        
        //メイン画面
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
                                                            size:CGSizeMake(self.frame.size.width*3, 24)];
        ground.name = kGround;
        ground.position = CGPointMake(CGRectGetMidX(self.frame),ground.size.height/2);
        
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ground.size.width, ground.size.height)];
        ground.physicsBody.affectedByGravity = NO;
        ground.physicsBody.restitution = 0;
        ground.physicsBody.categoryBitMask = groundCategory;
        ground.physicsBody.collisionBitMask = 0;
        ground.physicsBody.contactTestBitMask = 0;
    
        
        [self addChild:ground];
        
        //プレイキャラの設定
        SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"mario.png"];
        player.size = CGSizeMake(player.size.width/2, player.size.height/2);
        player.name = kPlayer;
        player.position = CGPointMake(CGRectGetMidX(self.frame)/2, 100 );
        [self addChild:player];
        player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
        player.physicsBody.allowsRotation = NO;
        player.physicsBody.affectedByGravity = YES;
        player.physicsBody.mass = player.physicsBody.mass * 10;
        player.physicsBody.categoryBitMask = playerCategory;
        player.physicsBody.collisionBitMask = groundCategory;
        player.physicsBody.contactTestBitMask = groundCategory;
        
        //いけるかな？
        SKAction *makeGround = [SKAction sequence: @[[SKAction performSelector:@selector(nextGround) onTarget:self],
                                                      [SKAction waitForDuration:2 withRange:0.2]]];
        [self runAction: [SKAction repeatActionForever:makeGround]];
        
        //接触デリゲート
        self.physicsWorld.contactDelegate = self;
        
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
            //スタートボタンがタップされたら、地面が移動する
            _gameStart = YES;
            SKNode *sprite2 = [self childNodeWithName:kGround];
            [sprite2 runAction:[SKAction repeatActionForever:
                                [SKAction sequence:@[[SKAction moveToX:-300 duration:2.0],
                                                     [SKAction removeFromParent]]]]];
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
        sprite.physicsBody.velocity = CGVectorMake(0, 700);
        
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
    
    //ビットマスクの処理がちょっと微妙、、、、(一旦これで妥協、、、)
	//カテゴリビットマスクからオブジェクトを判定
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        ground = contact.bodyA;
        player = contact.bodyB;
    }else{
        ground = contact.bodyB;
        player = contact.bodyA;
    }
    
    //プレイヤーのy座標-プレイヤーの高さ/2→プレイヤーの足元のy座標
    //道路のy座標+道路の高さ/2→道路の表面のy座標
    if((player.node.position.y) - ([player.node calculateAccumulatedFrame].size.height/2) + 2 >= (ground.node.position.y) + ([ground.node calculateAccumulatedFrame].size.height/2) - 2){
           jumpFlag = YES;
       }
    
}


//オブジェクト同士が離れた際の処理
- (void)didEndContact:(SKPhysicsContact *)contact
{

    //地面を格納する変数
    SKPhysicsBody *ground;
    //プレイヤーを格納する変数
    SKPhysicsBody *player;
    
    //ビットマスクの処理がちょっと微妙、、、、(一旦これで妥協、、、)
	//カテゴリビットマスクからオブジェクトを判定
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        ground = contact.bodyA;
        player = contact.bodyB;
    }else{
        ground = contact.bodyB;
        player = contact.bodyA;
    }
    
    //プレイヤーのy座標-プレイヤーの高さ/2→プレイヤーの足元のy座標
    //道路のy座標+道路の高さ/2→道路の表面のy座標
    if((player.node.position.y) - ([player.node calculateAccumulatedFrame].size.height/2) + 2 >= (ground.node.position.y) + ([ground.node calculateAccumulatedFrame].size.height/2) ){
        jumpFlag = YES;
    }
    
}

//1フレーム毎に動作するメソッド
-(void)didSimulatePhysics{
    
	//プレイヤーが画面外に落ちた時にゲームオーバーとする
	[self enumerateChildNodesWithName:kPlayer usingBlock:^(SKNode *node, BOOL *stop) {
		CGPoint pt = [self convertPoint:node.position toNode:self];
        CGFloat	h = self.size.height;
        CGFloat	w = self.size.width;
        //画面外か判定
		if(pt.y < -(h) || pt.x < -(w)){
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

//地面を次々に呼ぶ
-(void)nextGround{
    if (_gameStart == YES) {
        SKSpriteNode *nextGround = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor] size:CGSizeMake(400, 24)];
        nextGround.userData = [@{@"tekito":@(skRand(400,800))}mutableCopy];
        nextGround.position = CGPointMake(CGRectGetMaxX(self.frame)+nextGround.frame.size.width/2, skRand(50,130));
        [self addChild:nextGround];
 
        nextGround.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(nextGround.size.width, nextGround.size.height)];
        nextGround.physicsBody.restitution = skRandBound();
        nextGround.physicsBody.affectedByGravity = NO;

        [nextGround runAction:[SKAction repeatActionForever:
                            [SKAction sequence:@[[SKAction moveToX:-300 duration:2.5],
                                                 [SKAction moveToX:(self.frame.size.width + nextGround.size.width/2) duration:0.0]]]]];

        //接触設定
        //カテゴリー
        nextGround.physicsBody.categoryBitMask = groundCategory;
        //接触できるオブジェクト
        nextGround.physicsBody.collisionBitMask =  0;
        //ヒットテストするオブジェクト
        nextGround.physicsBody.contactTestBitMask = 0;
        
        
        
    }
}

static inline CGFloat skRand(CGFloat low,CGFloat high){
    CGFloat res = skRandf() * ((high - low) + low);
    return  res;
}

static inline CGFloat skRandf(){
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRandBound()
{
    
    CGFloat rand = (CGFloat)arc4random_uniform(101)/100;
    return rand;
}







@end