//
//  OpenSoftwareModel.h
//  开源中国
//
//  Created by qianfeng01 on 15/5/9.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "LYObject.h"

@interface OpenSoftwareModel : LYObject

kPropertyString(id);
kPropertyString(tag);
kPropertyString(name);
kPropertyString(description);
kPropertyString(url);
 /*
 <software>
     <id>32743</id>
     <name>Tachyon</name>
     <description>Tachyon 是一个高容错的分布式文件系统，...</description>
     <url>http://www.oschina.net/p/tachyon</url>
 </software>
  */

@end
