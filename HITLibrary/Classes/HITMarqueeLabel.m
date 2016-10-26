//
//  HITMarqueeLabel.m
//  AIN
//
//  Created by Lolo on 15/7/9.
//  Copyright © 2015年 Lolo. All rights reserved.
//

#import "HITMarqueeLabel.h"
#import "UIView+FrameHelper.h"

@protocol HITMarqueeLabel <NSObject>
@property(nonatomic, strong) NSString* text;
@property(nonatomic, strong) UIColor*  textColor;
@property(nonatomic, strong) UIFont*   font;
@property(nonatomic, assign) CGFloat   interval;
@property(nonatomic, assign) BOOL      started;
- (void)marquee;
@end


@interface HITMarqueeLabel ()
@property(nonatomic, strong) UIView<HITMarqueeLabel>* label;
@end

@interface HITMarqueeBounceLabel : UIScrollView<HITMarqueeLabel>

@property(nonatomic, strong) NSString* text;
@property(nonatomic, strong) UIColor*  textColor;
@property(nonatomic, strong) UIFont*   font;
@property(nonatomic, assign) CGFloat   interval;

@property(nonatomic, strong) UILabel*  label;
@property(nonatomic, strong) NSTimer*  marqueeTimer;
@property(nonatomic, assign) BOOL      started;
@end


@interface HITMarqueeScrollLabel : UIScrollView<HITMarqueeLabel>

@property(nonatomic, strong) NSString* text;
@property(nonatomic, strong) UIColor*  textColor;
@property(nonatomic, strong) UIFont*   font;
@property(nonatomic, assign) CGFloat   interval;

@property(nonatomic, strong) UILabel*  firstLabel;
@property(nonatomic, strong) UILabel*  secondLabel;

@property(nonatomic, strong) NSTimer*  marqueeTimer;
@property(nonatomic, assign) BOOL      started;
@end


@implementation HITMarqueeLabel

+ (instancetype)marqueeWithType:(HITMarqueeType)type{
    return [[HITMarqueeLabel alloc]initWithType:type];
}

- (instancetype)initWithType:(HITMarqueeType)type{
    self = [super init];
    if (self) {
        [self initLabelWithType:type];
        self.interval = 15.0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {


    }
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];

    //get label with ib type
    [self initLabelWithType:self.type];
    
    //set interval with ib interval
    //if not set
    if (self.interval == 0.0) {
        //set a default value
        self.interval = 15.0f;
    }
    
    self.label.text = self.text;
    self.label.textColor = self.textColor;
    self.label.font = self.font;
    self.label.interval = self.interval;
   
    
}

- (void)initLabelWithType:(HITMarqueeType)type{
    switch (type) {
        case HITMarqueeBounce:
            self.label = [[HITMarqueeBounceLabel alloc]init];
            break;
        case HITMarqueeScroll:
            self.label = [[HITMarqueeScrollLabel alloc]init];
            break;
        default:
            break;
    }
    
    if (self.label) {
        [self addSubview:self.label];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.label.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [self.label.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
        [self.label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [self.label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    }

}

- (void)setText:(NSString *)text{
    _text = text;
    self.label.text = text;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    self.label.font = font;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.label.textColor = textColor;
}

- (void)setInterval:(CGFloat)interval{
    _interval = interval;
    self.label.interval = interval;
}

- (void)marquee{
    [self.label marquee];
}


@end






@implementation HITMarqueeBounceLabel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)dealloc{
    [self.marqueeTimer invalidate];
    self.marqueeTimer = nil;
}

- (void)prepare{
    
    self.started = NO;
   
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.clipsToBounds = YES;
    
    [self prepareSubviews];
    [self prepareConstraints];
    
    
}

- (void)prepareSubviews{
    [self addSubview:self.label];
    //[self addSubview:self.followedLabel];
}

- (void)prepareConstraints{
    
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8].active = YES;
    [self.label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;

}


#pragma mark - Getter& Setter

- (NSTimer*)marqueeTimer{
    if (_marqueeTimer == nil) {
        _marqueeTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                         target:self
                                                       selector:@selector(marqueeing)
                                                       userInfo:nil
                                                        repeats:YES];
    }
    return _marqueeTimer;
}

- (UILabel*)label{
    if (_label == nil) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = self.textColor;
    }
    return _label;
}


- (void)setText:(NSString *)text{
    
    [self.layer removeAllAnimations];
    [self setContentOffset:CGPointZero animated:NO];
    
    _text = text;
    self.label.text = text;

    [self.label sizeToFit];
    
    if (self.started) {
        if (self.label.width < self.width) {
            [self stopAnimation];
        }
        else{
            
            [self setContentSize:CGSizeMake(self.label.width + 2 * 8, self.height)];
            [self startAnimation];
        }

    }
    
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.label.textColor = textColor;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    self.label.font = font;
}


#pragma mark - Marqueel

- (void)marquee{
    
    [self layoutIfNeeded];
    
    if (self.label.width > self.width) {
        [self setContentSize:CGSizeMake(self.label.width, self.height)];
        [self startAnimation];
       
    }
    self.started = YES;

}

- (BOOL)isAnimation{
    return [self.marqueeTimer isValid];
}

- (void)startAnimation{
    
    [self.marqueeTimer setFireDate:[NSDate date]];
}

- (void)stopAnimation{
    [self setContentOffset:CGPointMake(0, 0)];
    [self.marqueeTimer setFireDate:[NSDate distantFuture]];
}

- (void)marqueeing{
    
    CGPoint offset = CGPointMake(self.contentSize.width - self.width + 20, 0);
    CGFloat duration = 2.0 + self.contentSize.width / self.width;

    [UIView animateWithDuration:duration animations:^{
        [self setContentOffset:offset];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            [self setContentOffset:CGPointZero];
        }];
    }];
    
}
@end



@implementation HITMarqueeScrollLabel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)dealloc{
    [self.marqueeTimer invalidate];
    self.marqueeTimer = nil;
}

- (void)prepare{
    
    self.started = NO;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.clipsToBounds = YES;
    
    [self prepareSubviews];
    [self prepareConstraints];
    
}

- (void)prepareSubviews{
    [self addSubview:self.firstLabel];
    [self addSubview:self.secondLabel];
}

- (void)prepareConstraints{
    
    self.firstLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.firstLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8].active = YES;
    [self.firstLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    
    self.secondLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.secondLabel.leadingAnchor constraintEqualToAnchor:self.firstLabel.trailingAnchor constant:50].active = YES;
    
    [self.secondLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}

#pragma mark - Getter& Setter

- (NSTimer*)marqueeTimer{
    if (_marqueeTimer == nil) {
        _marqueeTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                         target:self
                                                       selector:@selector(marqueeing)
                                                       userInfo:nil
                                                        repeats:YES];
    }
    return _marqueeTimer;
}

- (UILabel*)firstLabel{
    if (_firstLabel == nil) {
        _firstLabel = [UILabel new];
        _firstLabel.textAlignment = NSTextAlignmentLeft;
        _firstLabel.textColor = self.textColor;
    }
    return _firstLabel;
}

- (UILabel*)secondLabel{
    if (_secondLabel == nil) {
        _secondLabel = [UILabel new];
        _secondLabel.textAlignment = NSTextAlignmentLeft;
        _secondLabel.textColor = self.textColor;
    }
    return _secondLabel;
}


- (void)setText:(NSString *)text{
    
    [self.layer removeAllAnimations];
    [self setContentOffset:CGPointZero animated:NO];
    
    _text = text;
    self.firstLabel.text = text;
    self.secondLabel.text = text;
    
    [self.firstLabel sizeToFit];
    
    if (self.started) {
        if (self.firstLabel.width < self.width) {
            [self stopAnimation];
            [self.secondLabel setHidden:YES];
        }
        else{
            
            [self.secondLabel setHidden:NO];
            [self setContentSize:CGSizeMake(2 * self.firstLabel.width + 2 * 8 + 50, self.height)];
            [self startAnimation];
        }
        
    }
    
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.firstLabel.textColor = textColor;
    self.secondLabel.textColor = textColor;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    self.firstLabel.font = font;
    self.secondLabel.font = font;
}


#pragma mark - Marqueel

- (void)marquee{
    
    [self layoutIfNeeded];
    
    if (self.firstLabel.width > self.width) {
        [self setContentSize:CGSizeMake(2 * self.firstLabel.width + 2 * 8 + 50, self.height)];
        [self startAnimation];
        
    }
    else{
        [self.secondLabel setHidden:YES];
        [self setContentSize:CGSizeMake(self.firstLabel.width + 2 * 8 , self.height)];
    }
    self.started = YES;
    
}

- (BOOL)isAnimation{
    return [self.marqueeTimer isValid];
}

- (void)startAnimation{
    
    [self.marqueeTimer setFireDate:[NSDate date]];
}

- (void)stopAnimation{
    [self setContentOffset:CGPointMake(0, 0)];
    [self.marqueeTimer setFireDate:[NSDate distantFuture]];
}

- (void)marqueeing{
    
    CGPoint offset = CGPointMake(self.firstLabel.width + 50, 0);
    CGFloat duration = 2.0 + self.contentSize.width / self.width;
    
    [UIView animateWithDuration:duration animations:^{
        [self setContentOffset:offset];
    } completion:^(BOOL finished) {
        [self setContentOffset:CGPointZero];
    }];
    
}
@end





