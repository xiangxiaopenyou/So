//
//  DrysalteryCommentViewController.m
//  fitplus
//
//  Created by xlp on 15/8/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DrysalteryCommentViewController.h"
#import "DrysalteryCommentCell.h"
#import "DrysalteryCommentModel.h"
#import "RBNoticeHelper.h"
#import "Util.h"
#import <MBProgressHUD.h>
#import "LimitResultModel.h"
#import <MJRefresh.h>
#import "RBBlockActionSheet.h"
#import "RBBlockAlertView.h"
#import "RBColorTool.h"
#import "RecommendationModel.h"
@interface DrysalteryCommentViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *bottmView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
@property (assign, nonatomic) NSInteger commentType;
@property (assign, nonatomic) NSInteger limit;
@property (strong, nonatomic) NSMutableArray *commentArray;
@property (copy, nonatomic) DrysalteryCommentModel *selectedModel;
@end

@implementation DrysalteryCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _commentTextView.layer.masksToBounds = YES;
    _commentTextView.layer.cornerRadius = 2.0;
    _commentType = 1;
    _limit = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self fetchCommentList];
    
    [self initRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)initRefresh {
    [_commentTableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limit = 0;
        [self fetchCommentList];
    }]];
    [_commentTableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchCommentList];
    }]];
}
- (void)fetchCommentList{
    [DrysalteryCommentModel fetchDrysalteryCommentListWith:_articleId limit:_limit handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_commentTableView.header endRefreshing];
        [_commentTableView.footer endRefreshing];
        if (!msg) {
            LimitResultModel *tempModel = [LimitResultModel new];
            tempModel = object;
            if (_limit == 0) {
                _commentArray = [tempModel.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_commentArray mutableCopy];
                [tempArray addObjectsFromArray:tempModel.result];
                _commentArray = tempArray;
            }
            [_commentTableView reloadData];
            BOOL haveMore = tempModel.haveMore;
            if (haveMore) {
                _limit = tempModel.limit;
                _commentTableView.footer.hidden = NO;
            } else {
                [_commentTableView.footer noticeNoMoreData];
                _commentTableView.footer.hidden = YES;
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
        //[textView resignFirstResponder];
        [self sendClick:nil];
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
    [self setupTextView];
}

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DryCommentCell";
    DrysalteryCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DrysalteryCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupCommentContent:_commentArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrysalteryCommentModel *tempModel = _commentArray[indexPath.row];
    return [[DrysalteryCommentCell new] heightForCellWith:tempModel];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedModel = _commentArray[indexPath.row];
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    if ([_selectedModel.userid isEqual:userid]) {
        [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[[RBBlockAlertView alloc] initWithTitle:nil message:@"确定要删除吗?" block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self deleteComment];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil] showInView:self.view];
    } else {
        [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 2) {
                _commentType = 2;
                _commentTextView.text = nil;
                _tipLabel.text = [NSString stringWithFormat:@"回复%@", _selectedModel.userNickName];
                _tipLabel.hidden = NO;
                [_commentTextView becomeFirstResponder];
            } else if (buttonIndex == 0) {
                [[[RBBlockAlertView alloc] initWithTitle:nil message:@"确定要举报吗?" block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self reportComment];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报不良信息" otherButtonTitles:@"回复", nil] showInView:self.view];
    }
}
- (void)deleteComment {
    [DrysalteryCommentModel drysalteryCommentDeleteWith:_selectedModel.recordId type:[_selectedModel.type integerValue] handler:^(id object, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"删除失败"];
        } else {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"删除成功"];
            [self fetchCommentList];
        }
    }];
}
- (void)reportComment {
    NSString *typeString;
    if ([_selectedModel.type integerValue] == 1) {
        typeString = @"articlecomment";
    } else {
        typeString = @"articlecpartak";
    }
    [RecommendationModel clockinReport:_selectedModel.recordId type:typeString handler:^(id object, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"举报失败"];
        } else {
            [RBNoticeHelper  showNoticeAtViewController:self msg:@"举报成功"];
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sendClick:(id)sender {
    if ([Util isEmpty:_commentTextView.text]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"先说点什么吧"];
    } else {
        if (_commentType == 1) {
            [DrysalteryCommentModel drysalteryCommentWith:_articleId content:_commentTextView.text handler:^(id object, NSString *msg) {
                if (msg) {
                    [RBNoticeHelper showNoticeAtViewController:self msg:@"评论失败"];
                } else {
                    [RBNoticeHelper showNoticeAtViewController:self msg:@"评论成功"];
                    _limit = 0;
                    [self fetchCommentList];
                }
            }];
        } else {
            [DrysalteryCommentModel drysalteryReplyWith:_articleId content:_commentTextView.text commentid:_selectedModel.recordId handler:^(id object, NSString *msg) {
                if (msg) {
                    [RBNoticeHelper showNoticeAtViewController:self msg:@"回复失败"];
                } else {
                    [RBNoticeHelper showNoticeAtViewController:self msg:@"回复成功"];
                    _limit = 0;
                    [self fetchCommentList];
                }
            }];
        }
        [self setupTextView];
    }
}
- (void)setupTextView {
    _commentType = 1;
    [_commentTextView resignFirstResponder];
    _commentTextView.text = nil;
    _tipLabel.text = @"输入评论...";
    _tipLabel.hidden = NO;
}

@end
