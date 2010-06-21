// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * DKERC DataSource (SDS) API's.
 * 
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   Jun 21, 2010
 */

#ifndef __DKERC_DATA_SOURCE_H__
#define __DKERC_DATA_SOURCE_H__

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct
{
    int __unused__;
} DataSource;

typedef struct
{
    unsigned int count;
    int __unused__;
} RecordSet;

#ifdef __cplusplus
}
#endif

#endif /* __DKERC_DATA_SOURCE_H__ */


