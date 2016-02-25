//
//  PhotoEditViewController.m
//  fitplus
//
//  Created by 天池邵 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PhotoEditViewController.h"
#import <TuSDK/TuSDK.h>
#import <TuSDK/TuSDKPFStickerFactory.h>
#import <Masonry.h>
#import "UIImage+PhotoAddition.h"
#import "CommonsDefines.h"
#import "ChooseLabelViewController.h"
#import "RBNoticeHelper.h"
#import "DragButton.h"
#import "PhotoTagModel.h"

@interface PhotoEditViewController () <TuSDKCPGroupFilterBarDelegate, TuSDKPFStickerBarViewDelegate, TuSDKPFStickerItemViewDelegate, ChooseLabelDelegate>
@property (strong, nonatomic) TuSDKPFEditImageView *editImageView;
@property (strong, nonatomic) TuSDKCPGroupFilterBar *fileterBar;
@property (strong, nonatomic) TuSDKPFStickerBarView *stickerBarView;
@property (strong, nonatomic) TuSDKPFStickerView *stickerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (assign, nonatomic) NSInteger labelNumber;
@property (strong, nonatomic) DragButton *labelButton1;
@property (strong, nonatomic) DragButton *labelButton2;
@property (strong, nonatomic) DragButton *labelButton3;
@property (strong, nonatomic) DragButton *labelButton4;
@property (strong, nonatomic) DragButton *labelButton5;
@property (assign, nonatomic) NSInteger labelId1;
@property (assign, nonatomic) NSInteger labelId2;
@property (assign, nonatomic) NSInteger labelId3;
@property (assign, nonatomic) NSInteger labelId4;
@property (assign, nonatomic) NSInteger labelId5;
@property (strong, nonatomic) NSMutableArray *labelArray;


@end

@implementation PhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _editImageView = [[TuSDKPFEditImageView alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            CGRectGetWidth(self.view.frame),
                                                                            CGRectGetHeight(self.view.frame) - 101 - 44)];;
    [self.view addSubview:_editImageView];
    [_bottomView addSubview:self.fileterBar];
    [_bottomView addSubview:self.stickerBarView];
    [self.stickerBarView loadCatategories:nil];
    
    _editImageView.imageView.image = _inputImage;
    [_editImageView changeRegionRatio:[TuSDKRatioType ratio:lsqRatio_1_1]];
    _editImageView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_editImageView needUpdateLayout];
    [self showFilter:nil];
    _labelNumber = 0;
}

- (void)dealloc {
    [[TuSDKPFStickerLocalPackage package] removeDelegate:_stickerBarView];
    [[TuSDKFilterLocalPackage package] removeDelegate:(id<TuSDKFilterLocalPackageDelegate>)_fileterBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (TuSDKCPGroupFilterBar *)fileterBar {
    if (!_fileterBar) {
        _fileterBar = [[TuSDKCPGroupFilterBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 101)];
        _fileterBar.delegate = self;
    }
    
    return _fileterBar;
}

- (TuSDKPFStickerBarView *)stickerBarView {
    if (!_stickerBarView) {
        _stickerBarView = [TuSDKPFStickerBarView initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 101)];
        _stickerBarView.delegate = self;
    }
    
    return _stickerBarView;
}

- (IBAction)doneEdit:(id)sender {
    if (_stickerView) {
        NSArray *results = [[_stickerView resultsWithRegionRect:_stickerView.bounds] copy];
        UIImage *merged = [TuSDKPFStickerFactory megerStickers:results image:_editImageView.imageView.image];
        [_stickerView removeFromSuperview];
        _stickerView = nil;
        [_editImageView setImage:merged];
        _editImageView.imageView.userInteractionEnabled = NO;
    }
    
    UIImage *cutImage = [_editImageView.imageView.image imageCorpWithPrecentRect:_editImageView.countImageCutRect];
    
    [self setupLabelArray];
    !_handler ?: _handler(cutImage, _labelArray, self);
}
- (void)setupLabelArray {
    _labelArray = [[NSMutableArray alloc] init];
    float topHeight = (CGRectGetHeight(_editImageView.frame) - SCREEN_WIDTH) / 2;
    switch (_labelNumber) {
        case 1:{
            NSInteger x = _labelButton1.frame.origin.x;
            NSInteger y = _labelButton1.frame.origin.y;
            PhotoTagModel *model1 = [PhotoTagModel new];
            model1.tagId = _labelId1;
            model1.tagName = _labelButton1.titleLabel.text;
            model1.x = [NSNumber numberWithFloat:x / SCREEN_WIDTH];
            model1.y = [NSNumber numberWithFloat:(y - topHeight) / SCREEN_WIDTH];
            [_labelArray addObject:model1];
        }
            break;
        case 2:{
            NSInteger x = _labelButton1.frame.origin.x;
            NSInteger y = _labelButton1.frame.origin.y;
            NSInteger x2 = _labelButton2.frame.origin.x;
            NSInteger y2 = _labelButton2.frame.origin.y;
            PhotoTagModel *model1 = [PhotoTagModel new];
            model1.tagId = _labelId1;
            model1.tagName = _labelButton1.titleLabel.text;
            model1.x = [NSNumber numberWithFloat:x / SCREEN_WIDTH];
            model1.y = [NSNumber numberWithFloat:(y - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model2 = [PhotoTagModel new];
            model2.tagId = _labelId2;
            model2.tagName = _labelButton2.titleLabel.text;
            model2.x = [NSNumber numberWithFloat:x2 / SCREEN_WIDTH];
            model2.y = [NSNumber numberWithFloat:(y2 - topHeight) / SCREEN_WIDTH];
            [_labelArray addObject:model1];
            [_labelArray addObject:model2];
        }
            break;
        case 3:{
            NSInteger x = _labelButton1.frame.origin.x;
            NSInteger y = _labelButton1.frame.origin.y;
            NSInteger x2 = _labelButton2.frame.origin.x;
            NSInteger y2 = _labelButton2.frame.origin.y;
            NSInteger x3 = _labelButton3.frame.origin.x;
            NSInteger y3 = _labelButton3.frame.origin.y;
            
            PhotoTagModel *model1 = [PhotoTagModel new];
            model1.tagId = _labelId1;
            model1.tagName = _labelButton1.titleLabel.text;
            model1.x = [NSNumber numberWithFloat:x / SCREEN_WIDTH];
            model1.y = [NSNumber numberWithFloat:(y - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model2 = [PhotoTagModel new];
            model2.tagId = _labelId2;
            model2.tagName = _labelButton2.titleLabel.text;
            model2.x = [NSNumber numberWithFloat:x2 / SCREEN_WIDTH];
            model2.y = [NSNumber numberWithFloat:(y2 - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model3 = [PhotoTagModel new];
            model3.tagId = _labelId3;
            model3.tagName = _labelButton3.titleLabel.text;
            model3.x = [NSNumber numberWithFloat:x3 / SCREEN_WIDTH];
            model3.y = [NSNumber numberWithFloat:(y3 - topHeight) / SCREEN_WIDTH];
            [_labelArray addObject:model1];
            [_labelArray addObject:model2];
            [_labelArray addObject:model3];
            
            
        }
            break;
        case 4:{
            NSInteger x = CGRectGetMinX(_labelButton1.frame);
            NSInteger y = CGRectGetMinY(_labelButton1.frame);
            NSInteger x2 = CGRectGetMinX(_labelButton2.frame);
            NSInteger y2 = CGRectGetMinY(_labelButton2.frame);
            NSInteger x3 = CGRectGetMinX(_labelButton3.frame);
            NSInteger y3 = CGRectGetMinY(_labelButton3.frame);
            NSInteger x4 = CGRectGetMinX(_labelButton4.frame);
            NSInteger y4 = CGRectGetMinY(_labelButton4.frame);
            PhotoTagModel *model1 = [PhotoTagModel new];
            model1.tagId = _labelId1;
            model1.tagName = _labelButton1.titleLabel.text;
            model1.x = [NSNumber numberWithFloat:x / SCREEN_WIDTH];
            model1.y = [NSNumber numberWithFloat:(y - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model2 = [PhotoTagModel new];
            model2.tagId = _labelId2;
            model2.tagName = _labelButton2.titleLabel.text;
            model2.x = [NSNumber numberWithFloat:x2 / SCREEN_WIDTH];
            model2.y = [NSNumber numberWithFloat:(y2 - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model3 = [PhotoTagModel new];
            model3.tagId = _labelId3;
            model3.tagName = _labelButton2.titleLabel.text;
            model3.x = [NSNumber numberWithFloat:x3 / SCREEN_WIDTH];
            model3.y = [NSNumber numberWithFloat:(y3 - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model4 = [PhotoTagModel new];
            model4.tagId = _labelId4;
            model4.tagName = _labelButton4.titleLabel.text;
            model4.x = [NSNumber numberWithFloat:x4 / SCREEN_WIDTH];
            model4.y = [NSNumber numberWithFloat:(y4 - topHeight) / SCREEN_WIDTH];
            [_labelArray addObject:model1];
            [_labelArray addObject:model2];
            [_labelArray addObject:model3];
            [_labelArray addObject:model4];
        }
            break;
        case 5:{
            NSInteger x = CGRectGetMinX(_labelButton1.frame);
            NSInteger y = CGRectGetMinY(_labelButton1.frame);
            NSInteger x2 = CGRectGetMinX(_labelButton2.frame);
            NSInteger y2 = CGRectGetMinY(_labelButton2.frame);
            NSInteger x3 = CGRectGetMinX(_labelButton3.frame);
            NSInteger y3 = CGRectGetMinY(_labelButton3.frame);
            NSInteger x4 = CGRectGetMinX(_labelButton4.frame);
            NSInteger y4 = CGRectGetMinY(_labelButton4.frame);
            NSInteger x5 = CGRectGetMinX(_labelButton5.frame);
            NSInteger y5 = CGRectGetMinY(_labelButton5.frame);
            PhotoTagModel *model1 = [PhotoTagModel new];
            model1.tagId = _labelId1;
            model1.tagName = _labelButton1.titleLabel.text;
            model1.x = [NSNumber numberWithFloat:x / SCREEN_WIDTH];
            model1.y = [NSNumber numberWithFloat:(y - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model2 = [PhotoTagModel new];
            model2.tagId = _labelId2;
            model2.tagName = _labelButton2.titleLabel.text;
            model2.x = [NSNumber numberWithFloat:x2 / SCREEN_WIDTH];
            model2.y = [NSNumber numberWithFloat:(y2 - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model3 = [PhotoTagModel new];
            model3.tagId = _labelId3;
            model3.tagName = _labelButton2.titleLabel.text;
            model3.x = [NSNumber numberWithFloat:x3 / SCREEN_WIDTH];
            model3.y = [NSNumber numberWithFloat:(y3 - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model4 = [PhotoTagModel new];
            model4.tagId = _labelId4;
            model4.tagName = _labelButton4.titleLabel.text;
            model4.x = [NSNumber numberWithFloat:x4 / SCREEN_WIDTH];
            model4.y = [NSNumber numberWithFloat:(y4 - topHeight) / SCREEN_WIDTH];
            PhotoTagModel *model5 = [PhotoTagModel new];
            model5.tagId = _labelId5;
            model5.tagName = _labelButton5.titleLabel.text;
            model5.x = [NSNumber numberWithFloat:x5 / SCREEN_WIDTH];
            model5.y = [NSNumber numberWithFloat:(y5 - topHeight) / SCREEN_WIDTH];
            [_labelArray addObject:model1];
            [_labelArray addObject:model2];
            [_labelArray addObject:model3];
            [_labelArray addObject:model4];
            [_labelArray addObject:model5];
        }
            break;
            
        default:
            break;
}
}

- (void)onClosedStickerItemView:(TuSDKPFStickerItemView *)view {
    //Do nothing
}

- (void)onSelectedStickerItemView:(TuSDKPFStickerItemView *)view {
    //Do nothing
}

- (void)stickerBarView:(TuSDKPFStickerBarView *)view emptyWithCategory:(TuSDKPFStickerCategory *)cate {
    //Do nothing
}

- (BOOL)onTuSDKCPGroupFilterBar:(TuSDKCPGroupFilterBar *)bar selectedCell:(TuSDKCPGroupFilterItemCell *)cell mode:(TuSDKCPGroupFilterItem *)mode {
    if (mode.option) {
        TuSDKFilterWrap *wrap = [TuSDKFilterWrap initWithOpt:mode.option];
        UIImage *image = [wrap processWithImage:_editImageView.imageView.image];
        _editImageView.imageView.image = image;
    }
    return YES;
}

- (void)stickerBarView:(TuSDKPFStickerBarView *)view selectSticker:(TuSDKPFSticker *)data {
    [_stickerView removeFromSuperview];
    _stickerView = [[TuSDKPFStickerView alloc] initWithFrame:_editImageView.imageView.bounds];
    [_stickerView appenSticker:data];
    _editImageView.imageView.userInteractionEnabled = YES;
    [_editImageView.imageView addSubview:_stickerView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChooseLabelView"]) {
        ChooseLabelViewController *labelViewController = segue.destinationViewController;
        labelViewController.delegate = self;
    }
}
#pragma mark - ChooseLabelDelegate
- (void)chooseLabel:(NSString *)labelName id:(NSInteger)labelId {
    if (_labelNumber >= 5) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"标签不能超过5个哦~"];
        return;
    }
    CGSize labelStringSize = [labelName sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil]];
    CGSize twoWordsSize = [@"标签" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil]];
    UIImage *tagImageRight = [UIImage imageNamed:@"tag_right"];
    UIImage *tagImageLeft = [UIImage imageNamed:@"tag_left"];
    UIEdgeInsets insets_right = UIEdgeInsetsMake(0, 52, 0, 10);
    UIEdgeInsets insets_left = UIEdgeInsetsMake(0, 10, 0, 52);
    float topHeight = (CGRectGetHeight(_editImageView.frame) - SCREEN_WIDTH) / 2;
    tagImageRight = [tagImageRight resizableImageWithCapInsets:insets_right resizingMode:UIImageResizingModeStretch];
    tagImageLeft = [tagImageLeft resizableImageWithCapInsets:insets_left resizingMode:UIImageResizingModeStretch];
    _labelNumber += 1;
    switch (_labelNumber) {
        case 1:{
            _labelButton1 = [[DragButton alloc] initWithFrame:CGRectMake(10, 10 + topHeight, labelStringSize.width + 70 - twoWordsSize.width, 28)];
            //labelButton.backgroundColor = [UIColor blueColor];
            [_labelButton1 setBackgroundImage:tagImageLeft forState:UIControlStateNormal];
            [_labelButton1 setTitle:labelName forState:UIControlStateNormal];
            [_labelButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _labelButton1.titleLabel.font = [UIFont systemFontOfSize:14];
            _labelButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _labelButton1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            _labelButton1.dragEnable = YES;
            [_editImageView addSubview:_labelButton1];
            _labelId1 = labelId;
        }
            break;
        case 2:{
            _labelButton2 = [[DragButton alloc] initWithFrame:CGRectMake(10, SCREEN_WIDTH + topHeight - 38, labelStringSize.width + 70 - twoWordsSize.width, 28)];
            [_labelButton2 setBackgroundImage:tagImageLeft forState:UIControlStateNormal];
            [_labelButton2 setTitle:labelName forState:UIControlStateNormal];
            [_labelButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _labelButton2.titleLabel.font = [UIFont systemFontOfSize:14];
            _labelButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _labelButton2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            _labelButton2.dragEnable = YES;
            [_editImageView addSubview:_labelButton2];
            _labelId2 = labelId;
        }
            break;
        case 3:{
            _labelButton3 = [[DragButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - labelStringSize.width - 100 + twoWordsSize.width, 10 + topHeight, labelStringSize.width + 70 - twoWordsSize.width, 28)];
            [_labelButton3 setBackgroundImage:tagImageRight forState:UIControlStateNormal];
            [_labelButton3 setTitle:labelName forState:UIControlStateNormal];
            [_labelButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _labelButton3.titleLabel.font = [UIFont systemFontOfSize:14];
            _labelButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            _labelButton3.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            _labelButton3.dragEnable = YES;
            [_editImageView addSubview:_labelButton3];
            _labelId3 = labelId;
        }
            break;
        case 4:{
            _labelButton4 = [[DragButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - labelStringSize.width - 100 + twoWordsSize.width, SCREEN_WIDTH + topHeight - 38, labelStringSize.width + 70 - twoWordsSize.width, 28)];
            [_labelButton4 setBackgroundImage:tagImageRight forState:UIControlStateNormal];
            [_labelButton4 setTitle:labelName forState:UIControlStateNormal];
            [_labelButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _labelButton4.titleLabel.font = [UIFont systemFontOfSize:14];
            _labelButton4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            _labelButton4.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            _labelButton4.dragEnable = YES;
            [_editImageView addSubview:_labelButton4];
            _labelId4 = labelId;
        }
            break;
        case 5:{
            _labelButton5 = [[DragButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - labelStringSize.width/2, CGRectGetHeight(_editImageView.frame) / 2 - 14, labelStringSize.width + 70 - twoWordsSize.width, 28)];
            [_labelButton5 setBackgroundImage:tagImageRight forState:UIControlStateNormal];
            [_labelButton5 setTitle:labelName forState:UIControlStateNormal];
            [_labelButton5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _labelButton5.titleLabel.font = [UIFont systemFontOfSize:14];
            _labelButton5.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            _labelButton5.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            _labelButton5.dragEnable = YES;
            [_editImageView addSubview:_labelButton5];
            _labelId5 = labelId;
        }
            break;
            
        default:
            break;
    }

    
}

- (IBAction)showFilter:(id)sender {
    _fileterBar.hidden = NO;
    _stickerBarView.hidden = YES;
    [_fileterBar loadFilters];
}

- (IBAction)showSticker:(id)sender {
    _fileterBar.hidden = YES;
    _stickerBarView.hidden = NO;
}

@end
