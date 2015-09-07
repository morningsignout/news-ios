//
//  Tile.m
//  ios-app
//
//  Created by Shannon Phu on 9/5/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "Tile.h"
#import "Post.h"

@interface Tile ()

@end

@implementation Tile

- (void)awakeFromNib {
    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:recognizer];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect rectangle = rect;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 230.0/255.0, 230.0/255.0, 230.0/255.0, 1.0);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextFillRect(context, rectangle);
    CGContextStrokeRect(context, rectangle);    //this will draw the border
}

-(void)tapped:(UIPanGestureRecognizer *)recognizer {
    Post *post = self.post;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tileTapped" object:post];
}


@end
