//
//  ClockInViewController.m
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInDetailViewController.h"
#import "ClockInDetailModel.h"
#import "ClockInDetailCell.h"
#import "ClockInCommentCell.h"
#import <MJRefresh/MJRefresh.h>
#import "ClockInCommentModel.h"
#import "LimitResultModel.h"
#import "Util.h"
#import "RBNoticeHelper.h"
#import "RBBlockActionSheet.h"
#import "DeleteClockInDataModel.h"
#import "RecommendationModel.h"
#import "AddAttentionModel.h"
#import "AppDelegate.h"
#import "InformationViewController.h"
#import "RBBlockAlertView.h"
#import <ShareSDK/ShareSDK.h>
@interface ClockInDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ClockInDetailDelegate>

@property (strong, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property (assign, nonatomic) NSInteger limit;
@property (copy, nonatomic) NSMutableDictionary *model;
@property (copy, nonatomic) NSMutableArray *commentsArray;
@property (assign, nonatomic) NSInteger commentType;
//@property (copy, nonatomic) NSString *commentId;
@property (copy, nonatomic) ClockInCommentModel *selectedCommentModel;


@end

@implementation ClockInDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"详情";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clockin_detail_options"] style:UIBarButtonItemStyleBordered target:self action:@selector(optionsClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _commentTextView.layer.masksToBounds = YES;
    _commentTextView.layer.cornerRadius = 2;
    _commentTextView.delegate = self;
    
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initRefresh];
    
    [self fetchClockInDetail];
    _limit = 0;
    [self fetchClockInComments];
    _commentType = 1;
    
    if (_isCommentIn) {
        [_commentTextView becomeFirstResponder];
    }
    
}
- (void)initRefresh {
    [_detailTableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self fetchClockInDetail];
        [self fetchClockInComments];
    }]];
    [_detailTableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchClockInComments];
    }]];
}
- (void)fetchClockInDetail {
    [ClockInDetailModel fetchClockInDetail:_clockinId handler:^(id object, NSString *msg) {
        if (!msg) {
            _model = [object mutableCopy];
            [_detailTableView reloadData];
        }
    }];
}
- (void)fetchClockInComments {
    [ClockInCommentModel fetchClockInComments:_clockinId limit:_limit handler:^(id object, NSString *msg) {
        [_detailTableView.header endRefreshing];
        [_detailTableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *limitModel = [LimitResultModel new];
            limitModel = object;
            if (_limit == 0) {
                _commentsArray = [limitModel.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_commentsArray mutableCopy];
                [tempArray addObjectsFromArray:limitModel.result];
                _commentsArray = tempArray;
            }
            [_detailTableView reloadData];
            BOOL haveMore = limitModel.haveMore;
            if (haveMore) {
                _limit = limitModel.limit;
                _detailTableView.hidden = NO;
            } else {
                [_detailTableView.footer noticeNoMoreData];
                _detailTableView.footer.hidden = YES;
            }
        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self sendButtonClick:nil];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    _tipLabel.hidden = YES;
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *info = [note userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _bottomViewConstraint.constant = keyboardSize.height;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)keyboardWillHide:(NSNotification *)note {
    _bottomViewConstraint.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentsArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    if (indexPath.row == 0) {
        cellHeight = [[ClockInDetailCell new] cellHeightWithModel:_model];
    } else {
        ClockInCommentModel *commentModel = [_commentsArray objectAtIndex:indexPath.row - 1];
        cellHeight = [[ClockInCommentCell new] heightForCell:commentModel];
    }
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"";
    if (indexPath.row == 0) {
        CellIdentifier = @"DetailCell";
        ClockInDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//        if (cell == nil) {
//            cell = [[ClockInDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCell];
//        }
        cell.delegate = self;
        [cell setupCellViewWithModel:_model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        CellIdentifier = @"CommentCell";
        ClockInCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ClockInCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        ClockInCommentModel *commentModel = [_commentsArray objectAtIndex:indexPath.row - 1];
        [cell setupCellContent:commentModel];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        _selectedCommentModel = [_commentsArray objectAtIndex:indexPath.row - 1];
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
        if ([_selectedCommentModel.firstUserId isEqual:userid]) {
            [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [[[RBBlockAlertView alloc] initWithTitle:nil message:@"确定要删除吗?" block:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [self clockInCommentDelete];
                        }
                    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
                    
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil] showInView:self.view];
        } else {
            [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 2) {
                    _commentType = 2;
                    _commentTextView.text = nil;
                    _tipLabel.text = [NSString stringWithFormat:@"回复%@", _selectedCommentModel.firstUserNickname];
                    _tipLabel.hidden = NO;
                    [_commentTextView becomeFirstResponder];
                } else if (buttonIndex == 0) {
                    [[[RBBlockAlertView alloc] initWithTitle:nil message:@"确定要举报吗?" block:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [self clockInCommentReport];
                        }
                    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报不良信息" otherButtonTitles:@"回复", nil] showInView:self.view];
            
        }
    }
}
- (void)clockInCommentDelete {
    [ClockInCommentModel clockInCommentDelete:_selectedCommentModel.commentid type:_selectedCommentModel.commenttype handler:^(id object, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"删除失败"];
        } else {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"删除成功"];
            [self fetchClockInComments];
        }
    }];
}
- (void)clockInCommentReport {
    NSString *typeString;
    if (_selectedCommentModel.commenttype == 1) {
        typeString = @"trendscomment";
    } else {
        typeString = @"trendscpartak";
    }
    [RecommendationModel clockinReport:_selectedCommentModel.commentid type:typeString handler:^(id object, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"举报失败"];
        } else {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"举报成功"];
        }
    }];
}

#pragma mark - ClockInDetailDelegate
- (void)clickComment {
    _commentType = 1;
    _commentTextView.text = nil;
    _tipLabel.text = @"输入评论";
    _tipLabel.hidden = NO;
    [_commentTextView becomeFirstResponder];
}
- (void)clickShare:(UIImage *)image {
    if (!image) {
        image = [UIImage imageNamed:@"share_default"];
    }
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@trendId=%@&f=ios", NewBaseApiURL, CommonShareUrl, _model[@"id"]];
    id<ISSContent> publishContent = [ShareSDK content:_model[@"trendcontent"]
                                       defaultContent:@"一起健身吧"
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:@"健身坊，让健身更简单~"
                                                  url:shareUrl
                                          description:_model[@"trendcontent"]
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    NSArray *shareList = [ShareSDK getShareListWithType: /*ShareTypeSinaWeibo, ShareTypeQQSpace, ShareTypeQQ,*/ ShareTypeWeixiSession, ShareTypeWeixiTimeline,nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess) {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                } else if (state == SSResponseStateFail) {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
   
}
- (void)clickAttention {
    [self fetchClockInDetail];
}
- (void)clickHeadPortrait {
    InformationViewController *informationViewController = [[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
    informationViewController.friendid = _model[@"userid"];
    [self.navigationController pushViewController:informationViewController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendButtonClick:(id)sender {
    if ([Util isEmpty:_commentTextView.text]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"先说点什么吧"];
    } else {
        if (_commentType == 1) {
            [ClockInCommentModel clockInComment:_clockinId content:_commentTextView.text handler:^(id object, NSString *msg) {
                if (msg) {
                    [RBNoticeHelper showNoticeAtViewController:self msg:@"评论失败"];
                    [self setupTextView];
                } else {
                    [RBNoticeHelper showNoticeAtViewController:self msg:@"评论成功"];
                    _limit = 0;
                    [self setupTextView];
                    [self fetchClockInDetail];
                    [self fetchClockInComments];
                }
            }];
        } else {
            [ClockInCommentModel clockInReply:_clockinId commentid:_selectedCommentModel.commentid content:_commentTextView.text handler:^(id object, NSString *msg) {
                if (msg) {
                    [RBNoticeHelper showNoticeAtViewController:self msg:@"回复失败"];
                    [self setupTextView];
                } else {
                    [RBNoticeHelper showNoticeAtViewController:self msg:@"回复成功"];
                    [self setupTextView];
                    [self fetchClockInDetail];
                    [self fetchClockInComments];
                }
            }];
        }
    }
}
- (void)setupTextView {
    _commentType = 1;
    [_commentTextView resignFirstResponder];
    _commentTextView.text = nil;
    _tipLabel.text = @"输入评论";
    _tipLabel.hidden = NO;
}

- (void)optionsClick {
    if ([_model[@"flag"] integerValue] == 5) {
        [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[[RBBlockAlertView alloc] initWithTitle:nil message:@"确定要删除吗?" block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self deleteClockIn];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            }
            
        } cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil] showInView:self.view];
    } else if ([_model[@"flag"] integerValue] == 2 || [_model[@"flag"] integerValue] == 4) {
        [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[[RBBlockAlertView alloc] initWithTitle:nil message:@"确定要举报吗?" block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self reportClockIn];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            } else if (buttonIndex == 2) {
                [self cancelAttention:_model[@"userid"]];
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报不良信息" otherButtonTitles:@"取消关注", nil] showInView:self.view];
    } else {
        [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[[RBBlockAlertView alloc] initWithTitle:nil message:@"确定要举报吗?" block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self reportClockIn];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            }
            
        } cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报不良信息" otherButtonTitles:nil, nil] showInView:self.view];
    }
}
- (void)deleteClockIn {
    [DeleteClockInDataModel deleteClockInWithTrendid:_clockinId handler:^(id object, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"删除失败"];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)reportClockIn {
    [RecommendationModel clockinReport:_clockinId type:@"trends" handler:^(id object, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"举报失败"];
        } else {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"举报成功"];
        }
    }];
}
- (void)addAttention:(NSString *)friendId {
    [AddAttentionModel addAttentionWithfrendid:friendId handler:^(id object, NSString *msg) {
        if (!msg) {
            [self fetchClockInDetail];
        }
    }];
}
- (void)cancelAttention:(NSString *)friendId {
    [AddAttentionModel cancelAttentionWithFriendId:friendId handler:^(id object, NSString *msg) {
        if (!msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"取消关注成功"];
            [self fetchClockInDetail];
        }
    }];
}

@end
