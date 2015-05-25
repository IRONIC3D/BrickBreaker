//
//  Brick.m
//  BrickBreaker
//
//  Created by Iyad Horani on 23/05/2015.
//  Copyright (c) 2015 IRONIC3D. All rights reserved.
//

#import "Brick.h"

@implementation Brick {
    SKAction *_brickSmashSound;
}

-(instancetype)initWithType:(BrickType)type {
    switch (type) {
        case Green:
            self = [super initWithImageNamed:@"BrickGreen"];
            break;
        case Blue:
            self = [super initWithImageNamed:@"BrickBlue"];
            break;
        case Grey:
            self = [super initWithImageNamed:@"BrickGrey"];
            break;
        default:
            self = nil;
            break;
    }
    
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = kBrickCategory;
        self.physicsBody.dynamic = NO;
        self.type = type;
        self.indestructible = (type == Grey);
        
        _brickSmashSound = [SKAction playSoundFileNamed:@"BrickSmash.caf" waitForCompletion:NO];
    }
    
    return self;
}

-(void)hit {
    switch (self.type) {
        case Green:
            // By using an action, the removal of the brick will be delayed till the next frame
            // This way we can see the brick where the ball bounces of it, and removed on the next frame
            [self createExplosion];
            [self runAction:_brickSmashSound];
            [self runAction:[SKAction removeFromParent]];
            break;
            
        case Blue:
            self.texture = [SKTexture textureWithImageNamed:@"BrickGreen"];
            self.type = Green;
            break;
            
        default:
            // If Brick is Grey, then it is indestructible
            break;
    }
}

-(void)createExplosion {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BrickExplosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.position = self.position;
    [self.parent addChild:explosion];
    
    // Clean up after ourselves
    SKAction *removeExplosion = [SKAction sequence:@[[SKAction waitForDuration:explosion.particleLifetime + explosion.particleLifetimeRange],
                                                     [SKAction removeFromParent]]];
    [explosion runAction:removeExplosion];
}

@end
