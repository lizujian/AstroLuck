//
//  KFDownLoadRequestParameter.h
//  KoalaFramework
//
//  Created by JHorn.Han on 10/29/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFRequestParameter.h"

typedef enum _DownloadStatus {
    DownloadNotStart = 0,
    Downloading,
    DownloadPause,
    DownloadFinish
}DownloadStatus;


@interface KFDownLoadRequestParameter : KFRequestParameter {
    NSString* _downloadDestinationPath;
    DownloadStatus _downloadStatus;
    u_int64_t _totalSize;
    u_int64_t _curSize;
    NSString* _tempDownloadDir;
}


@property(nonatomic,copy)NSString* tempDownloadDir;
@property(nonatomic,copy) NSString* downloadDestinationPath;
@property(nonatomic,assign)DownloadStatus downloadStatus;
@property(nonatomic,assign)u_int64_t totalSize;
@property(nonatomic,assign)u_int64_t curSize;
//-(NSString*)downloadTempPath;
@end
