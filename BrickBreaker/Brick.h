//
//  Brick.h
//  BrickBreaker
//
//  Created by Iyad Horani on 23/05/2015.
//  Copyright (c) 2015 IRONIC3D. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    Green = 1,
    Blue = 2,
    Grey = 3,
} BrickType;

static const uint32_t kBrickCategory = 0x1 << 2;

@interface Brick : SKSpriteNode

@property (nonatomic) BrickType type;
@property (nonatomic) BOOL indestructible;

-(instancetype)initWithType:(BrickType)type;
-(void)hit;

@end
