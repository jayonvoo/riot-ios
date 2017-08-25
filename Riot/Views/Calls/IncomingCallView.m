/*
 Copyright 2017 Vector Creations Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "IncomingCallView.h"

#import <MatrixKit/MXKImageView.h>
#import <MatrixSDK/MXMediaManager.h>

#import "CircleButton.h"

static const CGFloat kAvatarSize = 100.0;
static const CGFloat kButtonSize = 80.0;

@interface IncomingCallView ()

@property (nonatomic) MXKImageView *callerImageView;
@property (nonatomic) UILabel *callerNameLabel;
@property (nonatomic) UILabel *callInfoLabel;

@property (nonatomic) CircleButton *answerButton;
@property (nonatomic) UILabel *answerTitleLabel;

@property (nonatomic) CircleButton *rejectButton;
@property (nonatomic) UILabel *rejectTitleLabel;

@end

@implementation IncomingCallView

+ (CGSize)callerAvatarSize
{
    return CGSizeMake(kAvatarSize, kAvatarSize);
}

- (instancetype)initWithCallerAvatarURL:(NSString *)callerAvatarURL placeholderImage:(UIImage *)placeholderImage callerName:(NSString *)callerName callInfo:(NSString *)callInfo
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
        
        self.callerImageView = [[MXKImageView alloc] init];
        self.callerImageView.backgroundColor = [UIColor whiteColor];
        self.callerImageView.clipsToBounds = YES;
        self.callerImageView.mediaFolder = kMXMediaManagerAvatarThumbnailFolder;
        self.callerImageView.enableInMemoryCache = YES;
        [self.callerImageView setImageURL:callerAvatarURL
                                 withType:nil
                      andImageOrientation:UIImageOrientationUp
                             previewImage:placeholderImage];
        
        self.callerNameLabel = [[UILabel alloc] init];
        self.callerNameLabel.backgroundColor = [UIColor whiteColor];
        self.callerNameLabel.textColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
        self.callerNameLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightMedium];
        self.callerNameLabel.text = callerName;
        
        self.callInfoLabel = [[UILabel alloc] init];
        self.callInfoLabel.backgroundColor = [UIColor whiteColor];
        self.callInfoLabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:1.0];
        self.callInfoLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
        self.callInfoLabel.text = callInfo;
        
        UIColor *answerButtonBorderColor = [UIColor colorWithRed:98.0/255.0 green:206.0/255.0 blue:156.0/255.0 alpha:1.0];
        
        self.answerButton = [[CircleButton alloc] initWithImage:[UIImage imageNamed:@"voice_call_icon"]
                                                    borderColor:answerButtonBorderColor];
        [self.answerButton addTarget:self action:@selector(didTapAnswerButton) forControlEvents:UIControlEventTouchUpInside];
        
        self.answerTitleLabel = [[UILabel alloc] init];
        self.answerTitleLabel.backgroundColor = [UIColor whiteColor];
        self.answerTitleLabel.textColor = answerButtonBorderColor;
        self.answerTitleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
        self.answerTitleLabel.text = NSLocalizedStringFromTable(@"accept", @"Vector", nil);
        
        UIColor *rejectButtonBorderColor = [UIColor colorWithRed:1.0 green:0.0 blue:100.0/255.0 alpha:1.0];
        
        self.rejectButton = [[CircleButton alloc] initWithImage:[UIImage imageNamed:@"call_hangup_icon"]
                                                    borderColor:rejectButtonBorderColor];
        [self.rejectButton addTarget:self action:@selector(didTapRejectButton) forControlEvents:UIControlEventTouchUpInside];
        
        self.rejectTitleLabel = [[UILabel alloc] init];
        self.rejectTitleLabel.backgroundColor = [UIColor whiteColor];
        self.rejectTitleLabel.textColor = rejectButtonBorderColor;
        self.rejectTitleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
        self.rejectTitleLabel.text = NSLocalizedStringFromTable(@"decline", @"Vector", nil);

        [self setupLayout];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.callerImageView.layer.cornerRadius = CGRectGetWidth(self.callerImageView.bounds) / 2.0;
}

- (void)setupLayout
{
    NSArray *views = @[self.callerImageView, self.callerNameLabel, self.callInfoLabel, self.answerButton, self.answerTitleLabel, self.rejectButton, self.rejectTitleLabel];
    for (UIView *view in views)
    {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
    }
    
    [NSLayoutConstraint activateConstraints:@[
                                              [NSLayoutConstraint constraintWithItem:self.callerImageView
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:62.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.callerImageView
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.callerImageView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:kAvatarSize],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.callerImageView
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.callerImageView
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.callerNameLabel
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.callerImageView
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:18.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.callerNameLabel
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.callInfoLabel
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.callerNameLabel
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:7.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.callInfoLabel
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.rejectButton
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:kButtonSize],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.rejectButton
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.rejectButton
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.rejectButton
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:-22.5],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.rejectTitleLabel
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.rejectButton
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:8.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.rejectTitleLabel
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.rejectButton
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.rejectTitleLabel
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:-16.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.answerButton
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:kButtonSize],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.answerButton
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.answerButton
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.answerButton
                                                                           attribute:NSLayoutAttributeLeading
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:22.5],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.answerTitleLabel
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.answerButton
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:8.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.answerTitleLabel
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.answerButton
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              
                                              [NSLayoutConstraint constraintWithItem:self.answerTitleLabel
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:-16.0]
                                              ]];
}

// MARK: - Actions

- (void)didTapAnswerButton
{
    if (self.onAnswer)
    {
        self.onAnswer();
    }
}

- (void)didTapRejectButton
{
    if (self.onReject)
    {
        self.onReject();
    }
}

@end
