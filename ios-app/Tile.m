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
    [super awakeFromNib];
    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:recognizer];
}

- (UIImageView *)image {
    if (!_image) {
        CGRect contentBounds = self.frame;
        _image = [[UIImageView alloc] initWithFrame:contentBounds];
        _image.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
    }
    
    return _image;
}

- (UILabel *)title {
    
    if (!_title) {
        CGRect contentBounds = super.frame;
        //_title = [[UILabel alloc] initWithFrame:contentBounds];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, contentBounds.size.height - 75, contentBounds.size.width, 100)];
        _title.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        _title.numberOfLines = 3;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    }
    
    return _title;
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
