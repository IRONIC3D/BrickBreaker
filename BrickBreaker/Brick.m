//
//  Brick.m
//  BrickBreaker
//
//  Created by Iyad Horani on 23/05/2015.
//  Copyright (c) 2015 IRONIC3D. All rights reserved.
//

#import "Brick.h"

@implementation Brick

-(instancetype)initWithType:(BrickType)type {
    switch (type) {
        case Green:
            self = [super initWithImageNamed:@"BrickGreen"];
            break;
        case Blue:
            self = [super initWithImageNamed:@"BrickBlue"];
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
    }
    
    return self;
}

@end
