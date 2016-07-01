//
//  JimaoShare.m
//  jimao
//
//  Created by Dongle Su on 15/5/20.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "JimaoShare.h"
#import "WebService.h"
#import "SharePopupView.h"
//#import "SocialShare.h"
#import "UserProfile.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface JimaoShare() <MFMessageComposeViewControllerDelegate>

@end

@implementation JimaoShare{
    NSArray  *shareTypeArray_;
    int shareObjId_;
    int shareSourceId_;
    NSString *title_;
    //UIImage *image_;
    NSString *imageUrl_;
    NSString *shareName_;
    NSString *shareUrl_;
    NSString *shareContent_;
    
    
    ShareContentType *messageType;
    UIViewController *baseController_;
    void (^shareSuccess_)();
}

+ (JimaoShare *)sharedInstance{
    static JimaoShare *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JimaoShare alloc] init];
    });
    return instance;
}

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

//- (void)shareWithSourceId:(int)sourceId objId:(int)objId objName:(NSString *)objName title:(NSString *)title image:(UIImage*)image{
//    shareObjId_ = objId;
//    shareName_ = objName;
//    shareSourceId_ = sourceId;
//    title_ = title;
//    image_ = image;
//    imageUrl_=nil;
//    [self showPopup];
//    //    [Tip tipProgress:nil OnView:self.view];
//    //    [[WebService sharedInstance] asyncShareSocailTypeListWithSourceCode:sourceId ObjId:objId success:^(NSArray *typeArray, int score) {
//    //        shareTypeArray_ = typeArray;
//    //        dispatch_async(dispatch_get_main_queue(), ^{
//    //            [Tip tipHideOnView:self.view];
//    //            NSMutableArray *nameAry = [NSMutableArray array];
//    //            for (ShareEarnBeanType *type in typeArray) {
//    //                [nameAry addObject:type.shareTypeName];
//    //            }
//    //
//    //            NSString *title;
//    //            if (score > 0) {
//    //                title = [NSString stringWithFormat:@"分享可得%d豆", score];
//    //            }
//    //            else{
//    //                title = @"分享";
//    //            }
//    //
//    //            [SharePopupView popupInView:self.view title:title socialList:nameAry socailButtonClicked:^(int index) {
//    //                [self shareWithSocialTypeIndex:index];
//    //            }];
//    //        });
//    //    } failure:^(NSError *error) {
//    //        [Tip tipError:error.localizedDescription OnView:self.view];
//    //    }];
//    //
//}

//- (void)shareWithSourceId:(int)sourceId objId:(int)objId objName:(NSString *)objName title:(NSString *)title imageUrl:(NSString*)imageUrl{
//}

- (void)shareWithBaseViewController:(UIViewController *)ctrl
                           sourceId:(int)sourceId
                              objId:(int)objId
                            objName:(NSString *)objName
                              title:(NSString *)title
                           imageUrl:(NSString*)imageUrl
                            content:(NSString *)content
                                url:(NSString *)url
                       shareSuccess:(void (^)())shareSuccess
{
    baseController_ = ctrl;
    shareUrl_ = url;
    shareContent_ = content;
    shareObjId_ = objId;
    shareName_ = objName;
    shareSourceId_ = sourceId;
    title_ = title;
    imageUrl_ = imageUrl;
    //image_=nil;
    shareSuccess_ = shareSuccess;
    [self showPopup];
    
    //    [self shareWithSourceId:sourceId objId:objId objName:objName title:title imageUrl:imageUrl];
}

- (void)showPopup{

    //fwr
    /*
    [Tip tipProgress:nil OnView:baseController_.view];
    [[WebService sharedInstance] ShareTypeListWithSourceCode:shareSourceId_ ObjId:shareObjId_ Success:^(ShareTypeListResponse *resp) {
        dispatch_async(dispatch_get_main_queue(), ^{
            shareTypeArray_ = resp.shareTypeList;
//            NSInteger score = pageNo;
//            NSInteger maxScore = totalPages;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [Tip tipImmediateHideOnView:baseController_.view];
                NSMutableArray *nameAry = [NSMutableArray array];
                for (ShareContentType *type in shareTypeArray_) {
                    [nameAry addObject:type.shareTypeName];
                }
                
                NSString *title;
//                if (score > 0) {
//                    title = [NSString stringWithFormat:@"分享可得%d猫粮", score];
//                }
//                else{
//                    title = @"分享";
//                }
                title = @"分享给小伙伴";
                
                [SharePopupView popupInView:[[[UIApplication sharedApplication] delegate] window] title:title copyText:resp.theCopyContent socialList:nameAry socailButtonClicked:^(SharePopupView *popupView, int index) {
//                    ShareContentType *type = [shareTypeArray_ objectAtIndex:index];
//                    if([type.shareTypeName isEqualToString:@"好友动态"]){
//                        [Tip tipProgress:nil OnView:self.view];
//                        [[WebService sharedInstance] asyncShareTagListOfSourceId:shareSourceId_ success:^(ShareTagResultSet *resultSet) {
//                            [Tip tipHideOnView:self.view];
//                            shareTagResultSet_ = resultSet;
//                            NSMutableArray *tagNameArray = [NSMutableArray array];
//                            for (ShareTag *tag in resultSet.tagList) {
//                                NSLog(@"%@", tag.tagName);
//                                [tagNameArray addObject:tag.tagName];
//                            }
//
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                ShareTagPopupView *tagView = [[ShareTagPopupView alloc] initWithFrame:self.view.bounds];
//                                [tagView setupWithTitle:@"点击选择分享你的标签吧" tagList:tagNameArray bluredBackImage:popupView.bluredBackground];
//                                [popupView disappearToLeftWithComplete:nil];
//                                [tagView appearFromRightInView:self.view animated:YES];
//                                //tagView.frame = CGRectMake(self.view.right, tagView.top, tagView.width, tagView.height);
//                                tagView.delegate = self;
//                                //                            [self.view addSubview:tagView];
//                                //                            [UIView animateWithDuration:0.4 animations:^{
//                                //                                popupView.frame = CGRectMake(-popupView.width, 0, popupView.width, popupView.height);
//                                //                                tagView.frame = CGRectMake(0, tagView.top, tagView.width, tagView.height);
//                                //                            } completion:^(BOOL finished) {
//                                //                                [popupView disappearWithComplete:^{
//                                //
//                                //                                }];
//                                //                            }];
//                            });
//
//                        } failure:^(NSError *error) {
//                            [Tip tipError:error.localizedDescription OnView:self.view];
//                        }];
//                     }
//                    else
                    {
                        [popupView disappearWithComplete:^{
                            [self shareWithSocialTypeIndex:index];
                        }];
                    }
                    
                }];
            });
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Tip tipError:error.localizedDescription OnView:baseController_.view];
        });
    }];
}

- (void)shareWithSocialTypeIndex:(int)index{
    if (index < [shareTypeArray_ count]) {
        ShareContentType *type = [shareTypeArray_ objectAtIndex:index];
        if([type.shareTypeName isEqualToString:@"短信"])
        {
            [self ShareWithMessage:[self evaluateContent:type]];
            messageType = type;
            return;
        }
        
        NSString *url = [shareUrl_ length]?shareUrl_:type.url;
        NSString *imageUrl = nil;
        if ([imageUrl_ length] > 0) {
            imageUrl = imageUrl_;
        }
        else if ([type.iconPath length] > 0){
            imageUrl = type.iconPath;
        }
        
//        [SocialShare shareContent:[shareContent_ length]?shareContent_:[self evaluateContent:type]
//                            title:[title_ length]?title_:type.title
//                              url:url
//                         imageUrl:imageUrl
//                       socialName:type.shareTypeName
//                           sucess:^{
//                               [Tip tipProgress:TipSharePro OnView:baseController_.view];
//                               
//                               [[WebService sharedInstance] ShareRecordSaveWithObjId:shareObjId_ objName:shareName_ SourceCode:shareSourceId_ shareTypeId:type.shareTypeId account:@"" type:0 Success:^(id jsonObj, NSInteger pageNo, NSInteger totalPages, NSInteger totalCount) {
//                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                       [Tip tipSuccess:[NSString stringWithFormat:@"%@", jsonObj] OnView:baseController_.view];
//                                       if (shareSuccess_) {
//                                           shareSuccess_();
//                                       }
//                                   });
//                               } failure:^(NSError *error) {
//                                   [Tip tipError:error.localizedDescription OnView:baseController_.view];
//                               }];
//                           } failure:^(NSString *errorDesc) {
//                               [Tip tipError:errorDesc OnView:baseController_.view];
//                           }];
        
//        if ([imageUrl_ length] > 0) {
//            [SocialShare shareContent:[shareContent_ length]?shareContent_:[self evaluateContent:type]
//                                title:[type.title length]?type.title:title_
//                                  url:url
//                             imageUrl:imageUrl_ socialName:type.shareTypeName
//                               sucess:^{
//                [Tip tipProgress:TipSharePro OnView:self.view];
//
//                [[WebService sharedInstance] ShareRecordSaveWithObjId:shareObjId_ objName:shareName_ SourceCode:shareSourceId_ shareTypeId:type.shareTypeId account:@"" type:0 Success:^(id jsonObj, NSInteger pageNo, NSInteger totalPages, NSInteger totalCount) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [Tip tipSuccess:[NSString stringWithFormat:@"%@", jsonObj] OnView:self.view];
//                        [self onShareSuccess];
//                    });
//                } failure:^(NSError *error) {
//                    [Tip tipError:error.localizedDescription OnView:self.view];
//                }];
//            } failure:^(NSString *errorDesc) {
//                [Tip tipError:errorDesc OnView:self.view];
//            }];
//        }
//        else if ([type.iconPath length] > 0) {
//            [SocialShare shareContent:[shareContent_ length]?shareContent_:[self evaluateContent:type]
//                                title:[type.title length]?type.title:title_
//                                  url:url
//                             imageUrl:type.iconPath
//                           socialName:type.shareTypeName
//                               sucess:^{
//                                   [Tip tipProgress:TipSharePro OnView:self.view];
//                                   [[WebService sharedInstance] ShareRecordSaveWithObjId:shareObjId_ objName:shareName_ SourceCode:shareSourceId_ shareTypeId:type.shareTypeId account:@"" type:0 Success:^(id jsonObj, NSInteger pageNo, NSInteger totalPages, NSInteger totalCount) {
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                           [Tip tipSuccess:[NSString stringWithFormat:@"%@", jsonObj] OnView:self.view];
//                                           [self onShareSuccess];
//                                       });
//                                   } failure:^(NSError *error) {
//                                       [Tip tipError:error.localizedDescription OnView:self.view];
//                                   }];
//
//                               } failure:^(NSString *errorDesc) {
//                                   [Tip tipError:errorDesc OnView:self.view];
//                               }];
//        }
//        else{
//            [SocialShare shareContent:[shareContent_ length]?shareContent_:[self evaluateContent:type]
//                                title:[type.title length]?type.title:title_
//                                  url:url
//                                image:image_ socialName:type.shareTypeName
//                               sucess:^{
//                [Tip tipProgress:TipSharePro OnView:self.view];
//
//                [[WebService sharedInstance] ShareRecordSaveWithObjId:shareObjId_ objName:shareName_ SourceCode:shareSourceId_ shareTypeId:type.shareTypeId account:@"" type:0 Success:^(id jsonObj, NSInteger pageNo, NSInteger totalPages, NSInteger totalCount) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [Tip tipSuccess:[NSString stringWithFormat:@"%@", jsonObj] OnView:self.view];
//                        [self onShareSuccess];
//                    });
//                } failure:^(NSError *error) {
//                    [Tip tipError:error.localizedDescription OnView:self.view];
//                }];
//            } failure:^(NSString *errorDesc) {
//                [Tip tipError:errorDesc OnView:self.view];
//            }];
//        }
    }
     
     */
}

- (NSString *)evaluateContent:(ShareContentType *)shareType{
    NSString *ret = shareType.content;
    ret = [ret stringByReplacingOccurrencesOfString:@"%!system_app!%" withString:APP_NAME];
    NSString *url = shareType.url;
    //    if ([self isKindOfClass:[AppDetailViewController class]]) {
    //        url = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", shareType.url];
    //    }
    ret = [ret stringByReplacingOccurrencesOfString:@"%!link_url!%" withString:[NSString stringWithFormat:@" %@ ",url]];
    if (shareName_) {
        ret = [ret stringByReplacingOccurrencesOfString:@"%!obj_name!%" withString:shareName_];
    }
    if ([UserProfile sharedInstance].userInfo.inviteCode) {
        ret = [ret stringByReplacingOccurrencesOfString:@"%!invite_code!%" withString:[UserProfile sharedInstance].userInfo.inviteCode];
    }
    return ret;
}

-(void)ShareWithMessage:(NSString *)contentStr
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController * smsViewController = [[MFMessageComposeViewController alloc] init];
        smsViewController.messageComposeDelegate = self;
        smsViewController.view.bounds = CGRectMake(0, 0, baseController_.view.width, APP_SCREEN_CONTENT_HEIGHT);
        //smsViewController.view.bounds = smsViewController.view.frame;
        
        smsViewController.body       = contentStr;
        //        smsViewController.recipients = @[phoneLB.text];
        [[[[smsViewController viewControllers] lastObject] navigationItem] setTitle:@"邀请短信"];
        [baseController_.navigationController presentViewController:smsViewController animated:YES completion:^{
            
        }];
    }
    else
    {
        [Tip tipMsg:@"该设备不支持短信功能" OnView:baseController_.view];
    }
    
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [baseController_ dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            [Tip tipMsg:@"信息发送失败" OnView:baseController_.view];
            break;
            
        case MessageComposeResultSent:
        {
            //do something
            //            [Tip tipMsg:@"信息发送成功" OnView:self.view];
            
            //fwr
//            [[WebService sharedInstance] ShareRecordSaveWithObjId:shareObjId_ objName:shareName_ SourceCode:shareSourceId_ shareTypeId:messageType.shareTypeId account:@"" type:0 Success:^(id jsonObj, NSInteger pageNo, NSInteger totalPages, NSInteger totalCount) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [Tip tipSuccess:[NSString stringWithFormat:@"%@", jsonObj] OnView:baseController_.view];
//                    if (shareSuccess_) {
//                        shareSuccess_();
//                    }
//                });
//            } failure:^(NSError *error) {
//                [Tip tipError:error.localizedDescription OnView:baseController_.view];
//            }];
            messageType = nil;
        }
            break;
        default:
            break;
    }
    
}

@end
