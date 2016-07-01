//
//  QRCodeHelper.m
//  jimao
//
//  Created by pan chow on 15/5/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "QRCodeHelper.h"

#import "UIImage+WaterMark.h"
#import "UserProfile.h"
@implementation QRCodeHelper

#pragma mark ======  public  ======

#pragma mark ======  扫描二维码  ======
/*
 首页：QR_Type_HTTP | QR_Type_PAGE | QR_Type_FLOWCARD
 flowCard：QR_Type_FLOWCARD
 wap：QR_Type_PAGE | QR_Type_CUSTOM
 */
+ (void)pushQRCodeViewCtrlBaseOnCtrl:(UIViewController *)ctrl qrType:(QR_Type)qr_type completeBlock:(QRUrlBlock)block
{
    QRCodeViewController *QRCodeCtrl = [[QRCodeViewController alloc] init];
    QRCodeCtrl.qrUrlBlock = block;
    QRCodeCtrl.qr_type = qr_type;
    [ctrl.navigationController pushViewController:QRCodeCtrl animated:YES];
}
+ (void)pushQRCodeViewCtrlBaseOnCtrl:(UIViewController *)ctrl qrType:(QR_Type)qr_type
{
    [QRCodeHelper pushQRCodeViewCtrlBaseOnCtrl:ctrl qrType:qr_type completeBlock:nil];
}
#pragma mark ======  二维码生成  ======
+ (UIImage *)QRCodeImgWithInfo:(NSString *)string logo:(UIImage *)logoImg
{
    CIImage *ciImg = [[self class] createQRForString:string];
    UIImage *qrcode = [[self class] createNonInterpolatedUIImageFormCIImage:ciImg withSize:250.0f];
    UIImage *customQrcode = [[self class] imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    if(logoImg)
    {
        CGFloat sizeLength = logoImg.size.height;//customQrcode.size.height*.1;
        customQrcode = [customQrcode getImgWithWaterMark:logoImg witFrame:CGRectMake((customQrcode.size.width-sizeLength)*.5, (customQrcode.size.height-sizeLength)*.5, sizeLength, sizeLength)];
    }
    return customQrcode;
}
+ (void)pushShowQRCodeViewCtrlBaseOnCtrl:(UIViewController *)ctrl withString:(NSString *)string
{
    ShowQRCodeViewController *showCtrl = [[ShowQRCodeViewController alloc] init];
    showCtrl.codeString = string;
    [ctrl.navigationController pushViewController:showCtrl animated:YES];
}
////--
////我的二维码
//+ (void)pushShowMyQRCodeBaseOnCtrl:(UIViewController *)ctrl{
//    UserInfo *user = [UserProfile sharedInstance].userInfo;
//    NSString *phoneString = [NSString stringWithFormat:@"friend://%@",user.mobile];
//    [QRCodeHelper pushShowQRCodeViewCtrlBaseOnCtrl:ctrl withString:phoneString];
//}
//生成gmall的二维码
+ (UIImage *)QRCodeImgWithGmallPageCode:(NSString *)code openValue:(NSString *)value logo:(UIImage *)logoImg
{
    NSString *_code = [NSString stringWithFormat:@"%@",code];
    NSString *_value = [NSString stringWithFormat:@"%@",value];
    NSString *codeString = [NSString stringWithFormat:@"gmall://{\"pageCode\":%@,\"openValue\":%@}",_code,_value];
    if(logoImg)
    {
        return [QRCodeHelper QRCodeImgWithInfo:codeString logo:logoImg];
    }
    else
    {
        return [QRCodeHelper QRCodeImgWithInfo:codeString logo:[UIImage imageNamed:@"watemask"]];
    }
}
//http
+ (UIImage *)QRCodeImgWithHTTPString:(NSString *)httpString logo:(UIImage *)logoImg
{
    if(logoImg)
    {
        return [QRCodeHelper QRCodeImgWithInfo:httpString logo:logoImg];
    }
    else
    {
        return [QRCodeHelper QRCodeImgWithInfo:httpString logo:[UIImage imageNamed:@"watemask"]];
    }
}
#pragma mark ======  private  ======
#pragma mark - QRCodeGenerator
+ (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}
#pragma mark - InterpolatedUIImage
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

@end
