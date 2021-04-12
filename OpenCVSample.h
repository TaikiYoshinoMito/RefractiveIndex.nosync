//
//  OpenCVSample.h
//  RefractiveIndex
//
//  Created by 吉野泰生 on 3/6/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Data1 : NSObject
{   //メンバー変数
    UIImage *_img;//画像ファイル
    CGFloat _rad1;//int型の変数（半径保存用１）
    CGFloat _rad2;//int型の変数（半径保存用１）
}
//各メンバー変数のプロパティ
//画像ファイル_imgのプロパティ
-(UIImage *)img;//データを呼び出す記述（getter）
-(void)setImg:(UIImage *)img;//データを格納する記述（setter）
//整数型_rad1のプロパティ
-(CGFloat)rad1;//getter
-(void)setRad1:(CGFloat)rad1;//setter
//整数型_rad2のプロパティ
-(CGFloat)rad2;//getter
-(void)setRad2:(CGFloat)rad2;//setter
@end

@interface Sample : NSObject

+(UIImage *)ConvertImage:(UIImage *)image myD1:(Data1 *) d1;
@end
