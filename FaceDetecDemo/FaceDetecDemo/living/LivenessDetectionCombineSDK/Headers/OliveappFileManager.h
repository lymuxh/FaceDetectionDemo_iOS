//
//  FileManager.h
//  DemoFanPai
//
//  Created by Xiaoyang Lin on 16/4/23.
//  Copyright © 2016年 com.yitutech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OliveappFileManager : NSObject



/**
 获取最新设置的文件夹，用于debug使用

 @return 最新设置的文件夹
 */
+ (NSString *) getCurrentDirectory;


/**
 设置当前要处理的文件夹，用于debug使用
 */
+ (void) setCurrentDirectory: (NSString *) currentDir;

/**
 *  在Document下创建文件夹
 *
 *  @param dirName 文件夹名字
 *
 *  @return 创建完的文件夹路径
 */
+ (NSString *) createDirectory:(NSString *) dirName;

@end
