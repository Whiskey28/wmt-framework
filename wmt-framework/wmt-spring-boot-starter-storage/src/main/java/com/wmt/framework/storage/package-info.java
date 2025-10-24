/**
 * WMT存储组件
 * 
 * <p>提供统一的文件存储管理功能，支持多种存储方式：</p>
 * <ul>
 *   <li>本地存储：基于文件系统的本地存储</li>
 *   <li>MinIO存储：基于MinIO的对象存储</li>
 *   <li>云存储：支持阿里云OSS、腾讯云COS、AWS S3等</li>
 * </ul>
 * 
 * <p>主要功能：</p>
 * <ul>
 *   <li>文件上传：支持单文件和批量文件上传</li>
 *   <li>文件下载：支持文件流下载和URL访问</li>
 *   <li>文件管理：文件删除、信息查询、批量操作</li>
 *   <li>存储切换：支持运行时动态切换存储方式</li>
 * </ul>
 * 
 * @author WMT Framework
 * @since 1.0.0
 */
package com.wmt.framework.storage.core;
