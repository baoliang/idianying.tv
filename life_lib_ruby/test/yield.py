#!/usr/bin/python
#encoding=utf-8

urls = ['http://www.baidu.com/', 'http://www.qiyi.com/', 'http://www.idianying.tv/']

import gevent
from gevent import monkey
import threading

monkey.patch_all()

import urllib2


def print_head(url):
    print ('开始抓取网址 %s' % url)
    print "为了证明我没有用多线程。当然python一次运行只有一个进程。所以我不可能多进程热行。"
    print "打印一下当前线程数量"
    print threading.activeCount()

    print "如果异步异步到这里的时侯不会等待接直把当前的函数返回继续执行其它协程"
    data = urllib2.urlopen(url).read()
    sleep(10000)
    print "完成"
    print "\n"
    print "\n"
    print "\n"
    print ('%s: %s 字节: %r' % (url, len(data), data[:50]))
    print "\n"
    print "\n"
    print "\n"

print "同步方式请求"
for url in urls:
	print_head(url)

print "异步方式请求"
print "生成协程队列"
jobs = [gevent.spawn(print_head, url) for url in urls]

print "执行"
gevent.joinall(jobs)

print "over"
print """
大家可以看到。整个程序只有一个进程一个线程。当有网络请求时侯也不会阻塞。
"""