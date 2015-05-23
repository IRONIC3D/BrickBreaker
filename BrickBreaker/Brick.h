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
} BrickType;

static const uint32_t kBrickCategory = 0x1 << 2;

@interface Brick : SKSpriteNode

@property (nonatomic) BrickType type;

-(instancetype)initWithType:(BrickType)type;

@end
