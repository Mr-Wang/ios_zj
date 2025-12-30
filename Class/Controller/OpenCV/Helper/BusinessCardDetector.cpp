//
//  BusinessCardDetector.cpp
//  opencvDemo
//
//  Created by zp on 2017/9/18.
//  Copyright © 2017年 ilogie. All rights reserved.
//

#include "BusinessCardDetector.h"
#include <opencv2/imgproc.hpp>

//const double MASK_STD_DEVS_FROM_MEAN = 3.0;
const double MASK_STD_DEVS_FROM_MEAN = 3.0;
const double MASK_EROSION_KERNEL_RELATIVE_SIZE_IN_IMAGE = 0.005;
const int MASK_NUM_EROSION_ITERATIONS = 8;

const double BLOB_RELATIVE_MIN_SIZE_IN_IMAGE = 0.05;

const cv::Scalar DRAW_RECT_COLOR(255, 0, 0); // Green

float BusinessCardDetector::getCenterX()const
{
    return  x;
}

float BusinessCardDetector::getCenterY()const
{
    return y;
}

void BusinessCardDetector::setCenterX(float x1)
{
    x = x1;
}

void BusinessCardDetector::setCenterY(float y1)
{
    y = y1;
}

void BusinessCardDetector::detect(cv::Mat &image, std::vector<BusinessCard> &businessCard, double resizeFactor, bool draw)
{
    //1.在每次进行图形处理时都先将此数组的内容进行清理;
    businessCard.clear();
    
    //2.将图片进行比例缩放,使用此方法(1)提高视频界面的清晰程度;(2)提高图形处理的性能;
    cv::resize(image, resizedImage, cv::Size(), resizeFactor,resizeFactor, cv::INTER_AREA); //缩放比列
    
    //3.高斯滤波 高斯模糊,使图像中的每一个点都可以进行平滑处理;
    cv::GaussianBlur(resizedImage, resizedImage,cv::Size(1, 1),0);
  
    //4.第一次膨胀
    cv::Mat element = getStructuringElement(MORPH_RECT, cv::Size(3, 3));
    dilate(resizedImage, resizedImage, element);

    //4.图像进行灰度值处理,此方式为步骤5做准备;
    cv::cvtColor(resizedImage, resizedImage, COLOR_RGB2GRAY);
    
    //5.Canny函数进行图片的边缘检测,能够查出来图片中的所有的边缘;
//    cv::Canny(resizedImage, edges, 130, 150);
    cv::Canny(resizedImage, edges, 40, 80);
    
    //6.对图片进行二值化，即使图像只包含黑白两色,能使图像更容易找到轮廓;
    cv::threshold(edges, edges, 0, 255, THRESH_BINARY);
 
    //7.找出图像数据的全部外部轮廓。计算颜色缺失连线 和 第二次膨胀
    createMask(edges);
      
    //8.将所有找出来的轮廓在原图数据上进行绘画出来。
    cv::findContours(mask, contours,cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
     //8.
//    drawContours(image, contours, -1, DRAW_RECT_COLOR,2);
    //9.
   this->temp[4] = {};
    for (std::vector<cv::Point> contour : contours) {
        RotatedRect rotatedRect = cv::minAreaRect(contour);
        if (verifySizes(rotatedRect,resizeFactor) == 1 && rotatedRect.size.width > 0 && rotatedRect.size.height > 0 ) {
            rotatedRect.center.x /= resizeFactor;
            rotatedRect.center.y /= resizeFactor;
            rotatedRect.size.width /= resizeFactor;
            rotatedRect.size.height /= resizeFactor;
        
            BusinessCard b = BusinessCard(cv::Mat(rotatedRect.size.width,rotatedRect.size.height,CV_8UC2));
            this->setCenterX(rotatedRect.center.x);
            this->setCenterY(rotatedRect.center.y);
            Point2f vertices[4];
            rotatedRect.points(vertices);
            
            for (int i = 0; i < 4; i++)
            {
                Point2f p = vertices[i];
                
                this->temp[i] = p;
            }
        
            businessCard.push_back(b);
             break;
        }
    }
}


const cv::Mat &BusinessCardDetector::getMask() const {
    return edges;
}

int BusinessCardDetector::verifySizes(RotatedRect mr,double factor)
{
     
    //    //B5
    //    float k = 25.7;
    //    float g = 17.2;
    //    float dg = 19.2;
    
    //身份证：
    float k = 8.56;
    float g = 5.4;
    //A5
    //    float k = 21;
    //    float g = 14.8;
    //最小面积
    int minW = k * g * pow(40, 2);
    //最大面积
    int maxW = k * g * pow(250, 2);
    //最小宽高比
    float minAspect = k / g - 0.15;
    //最大宽高比
    float maxAspect = k / g + 0.15;
    
    //取出目标面积
    int area = mr.size.height / factor * mr.size.width / factor;
    //取出目标宽高比
    float r = MAX(mr.size.width, mr.size.height)*1.0 / MIN(mr.size.width, mr.size.height) ;
    
    if (r >= minAspect  && r <= maxAspect ) {
        if (area >= minW  && area <= maxW ) {
            printf("面积和比例都正确 \n");
            return 1;
        } else {
            if (area < minW) {
                printf("请离近一点 \n");
                return 2;
            }
            if (area > maxW) {
                printf("请离远远远远远一点 \n");
                return 3;
            }
        }
        printf("比例正确 \n");
        return  0;
    }
    
    //    if ((area > maxW || area < minW ) || (r < minAspect || r > maxAspect))
    //    {
    //        return  false;
    //    }
    return 0;
}void BusinessCardDetector::createMask(const cv::Mat &image) {
    
    // Find the image's mean color. //均值
    // Presumably, this is the background color.
    // Also find the standard deviation.
    cv::Scalar meanColor;
    cv::Scalar stdDevColor;
    cv::meanStdDev(image, meanColor, stdDevColor);
    
    // Create a mask based on a range around the mean color.
    cv::Scalar halfRange = MASK_STD_DEVS_FROM_MEAN * stdDevColor;
    cv::Scalar lowerBound = meanColor - halfRange;
    cv::Scalar upperBound = meanColor + halfRange;
    cv::inRange(image, lowerBound, upperBound, mask);
    
    // Erode the mask to merge neighboring blobs.
    int kernelWidth = (int)(MIN(image.cols, image.rows) * MASK_EROSION_KERNEL_RELATIVE_SIZE_IN_IMAGE);
    if (kernelWidth > 0) {
        cv::Size kernelSize(12, 3);
        cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, kernelSize);
        //        cv::erode(mask, mask, kernel, cv::Point(-1, -1), MASK_NUM_EROSION_ITERATIONS);
        cv::morphologyEx(mask, mask, 0, kernel);
    } else {
        cv::Mat element1 = getStructuringElement(MORPH_RECT, cv::Size(3, 3));
        dilate(edges, mask, element1);
    }
}
