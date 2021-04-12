//
//  OpenCVSample.m
//  RefractiveIndex
//
//  Created by 吉野泰生 on 3/6/21.
//

#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>

#import "OpenCVSample.h"

@implementation Data1

-(UIImage *)img//getter
{
    return _img;//メンバー変数を返す処理
}
-(void)setImg:(UIImage *)img//setter
{
    _img = img;//メンバー変数に引数を代入する処理
}
-(CGFloat)rad1//getter
{
    return _rad1;
}
-(void)setRad1:(CGFloat)rad1//setter
{
    _rad1 = rad1;
}

-(CGFloat)rad2//getter
{
    return _rad2;
}
-(void)setRad2:(CGFloat)rad2//setter
{
    _rad2 = rad2;
}
@end


@implementation Sample
+(UIImage *)ConvertImage:(UIImage *)image myD1:(Data1 *)d1{
    // convert uiimage to mat
    cv::Mat mat;//元画像用変数
    UIImageToMat(image, mat);//UIImage型からMat型に変換
    cv::Mat gray;//グレースケール画像用変数
    cv::cvtColor(mat, gray, CV_RGB2GRAY);//グレースケール化処理
    cv::medianBlur(gray, gray, 5);//平滑化処理
    std::vector<cv::Vec3f> circles;//円情報を格納する配列
    
    int circle1center_x = 0;
    int circle1center_y = 0;
    int circle2center_x = 0;
    int circle2center_y = 0;
    int circle1rad =0;
    int circle2rad =0;
    
    double LargeCircleIntensityIn[8];
    double LargeCircleIntensityOut[8];
    double smallCircleIntensityIn[8];
    double smallCircleIntensityOut[8];


    //ハフ変換の処理
    int n = 0;
    //一回め
    if (n==0){
        cv::HoughCircles(gray, circles, CV_HOUGH_GRADIENT,(n+1),4000,110,20,363,440);//円の取得処理+円を描く処理
        if(0<circles.size()){
            cv::Vec3f c = circles[0];//円のデータを一時的に格納
            cv::Point center = cv::Point(c[0], c[1]);//円の中心座標を取得
            
            cv::circle(mat, center, 1, cv::Scalar(0,100,100,255),3);
            //中心座標を描画（OpenCV3.Xは、BRGAなので、Scalarの引数が4つ必要）
            
            double radius = c[2];//半径を取得
            cv::circle(mat, center, radius, cv::Scalar(255,0,0,255),3,CV_AA);//円を描く（ピンク色）
            circle1rad = radius;//半径データを保存
            
            circle1center_x = c[0];
            circle1center_y = c[1];
            
            //X
            int I = 0;
            for(I= 0; I< 8; I++){
            
                double pi = 3.1415;
                double degree = (0.25)*I*pi;
                double margin = 15.0;

                double LargeCircleXin = circle1center_x + radius*cos(degree) - margin*cos(degree);
                double LargeCircleYin = circle1center_y + radius *sin(degree) - margin*sin(degree);
                double LargeCircleXout = circle1center_x + radius*cos(degree) + margin*cos(degree);
                double LargeCircleYout = circle1center_y + radius*sin(degree) + margin*sin(degree);
                
                //RGBAだから4/3する　(Y,X)の順
                cv::Vec3b Xin = mat.at<cv::Vec3b>(LargeCircleYin,LargeCircleXin*1.333);
                double luminanceXin = ( 0.2989 * Xin[2] + 0.5866 * Xin[1] + 0.1144 * Xin[0] );
                cv::Vec3b Xout = mat.at<cv::Vec3b>(LargeCircleYout,LargeCircleXout*1.333);
                double luminanceXout = ( 0.2989 * Xout[2] + 0.5866 * Xout[1] + 0.1144 * Xout[0] );
                
                LargeCircleIntensityIn[I]= luminanceXin;
                LargeCircleIntensityOut[I] = luminanceXout;
                
                
                //点を描画
                cv::Point pointIn = cv::Point(LargeCircleXin, LargeCircleYin);
                cv::circle(mat, pointIn, 1, cv::Scalar(0,255,0,0),10);
                cv::Point pointOut = cv::Point(LargeCircleXout, LargeCircleYout);
                cv::circle(mat, pointOut, 1, cv::Scalar(255,0,0,0),10);
            }
            
            n += 1;
        }
    }

    //二回め
    if (n==1){
        cv::HoughCircles(gray, circles, CV_HOUGH_GRADIENT,(n+1),4000,60,20,273,287);
        //円の取得処理+円を描く処理
        if(0<circles.size()){
            
            cv::Vec3f c = circles[0];//円のデータを一時的に格納
            cv::Point center = cv::Point(c[0], c[1]);//円の中心座標を取得
            cv::circle(mat, center, 1,cv::Scalar(0,100,100,255),3);
            //中心座標を描画（OpenCV3.Xは、BRGAなので、Scalarの引数が4つ必要）
            double radius = c[2];//半径を取得
            cv::circle(mat, center, radius, cv::Scalar(255,0,255,255),3,CV_AA);//円を描く（ピンク色）
            circle2rad = radius;//半径データを保存
            
            circle2center_x = c[0];
            circle2center_y = c[1];
   
            //X
            int I = 0;
            for(I= 0; I< 8; I++){
            
                double pi = 3.1415;
                double degree = (0.25)*I*pi;
                double margin =  15.0;
   

                double SmallCircleXin = circle2center_x + radius*cos(degree) + margin*cos(degree);
                double SmallCircleYin = circle2center_y + radius *sin(degree) + margin*sin(degree);
                double SmallCircleXout = circle2center_x + radius*cos(degree) - margin*cos(degree);
                double SmallCircleYout = circle2center_y + radius*sin(degree) - margin*sin(degree);

                //RGBAだから4/3する
                cv::Vec3b Xin =  mat.at<cv::Vec3b>(SmallCircleYin,SmallCircleXin*1.333);
                double luminanceXin = ( 0.2989 * Xin[2] + 0.5866 * Xin[1] + 0.1144 * Xin[0] );
                cv::Vec3b Xout = mat.at<cv::Vec3b>(SmallCircleYout,SmallCircleXout*1.333);
                double luminanceXout = ( 0.2989 * Xout[2] + 0.5866 * Xout[1] + 0.1144 * Xout[0] );
                
                smallCircleIntensityIn[I]= luminanceXin;
                smallCircleIntensityOut[I] = luminanceXout;
                
                //点を描画
                cv::Point pointIn = cv::Point(SmallCircleXin, SmallCircleYin);
                cv::circle(mat, pointIn, 1, cv::Scalar(0,255,0,0),10);
                cv::Point pointOut = cv::Point(SmallCircleXout, SmallCircleYout);
                cv::circle(mat, pointOut, 1, cv::Scalar(255,0,0,0),10);
            }
            n += 1;
        }
    }
    

    int CenterDistance = (circle1center_x - circle2center_x)*(circle1center_x - circle2center_x) + (circle1center_y - circle2center_y)*(circle1center_y - circle2center_y);
    
    //とにかくでかい数字
    double differenceOfIntensityLargeMin = 100000.0;
    double differenceOfIntensitySmallMin = 100000.0;

    int DI = 0;
    for (DI = 0; DI <8; DI++){
        //printf("======================================");
        int IntensityLarge =  abs(LargeCircleIntensityIn[DI] - LargeCircleIntensityOut[DI]);
        if (IntensityLarge < differenceOfIntensityLargeMin){
            differenceOfIntensityLargeMin = IntensityLarge;
        }
        
        int IntensitySmall =  abs(smallCircleIntensityIn[DI] - smallCircleIntensityOut[DI]);
        if (IntensitySmall < differenceOfIntensitySmallMin){
            differenceOfIntensitySmallMin = IntensitySmall;
        }
    }
    
   // printf("%f\n",differenceOfIntensityLargeMin);
   // printf("%f\n",differenceOfIntensitySmallMin);
    
    

    if (CenterDistance < 20  & differenceOfIntensityLargeMin > 25){
        d1.rad1 = circle1rad;
    }
    
    if (CenterDistance < 20  & differenceOfIntensitySmallMin > 25){
        d1.rad2 = circle2rad;
    }
    
    //表示するためにUIImage型に戻す
    UIImage *binImg = MatToUIImage(mat);
    d1.img = binImg;//画像を保存（後で、表示画像を呼び出せる）
    return binImg;//画像を返す

}
@end
