#!/usr/bin/python
#coding: utf-8
# -*- coding: utf-8 -*-

import re
import codecs
import sys

def transfer():
    try:
        f_in = codecs.open(fname, 'r', 'gb18030')
        f_out = open(fname + '_res', 'w')
        s = f_in.read()
        s = s.encode('utf-8')
        s = reg_space.sub(' ', s)
        s = reg_point.sub('.', s)
        s = reg_newline.sub('\n', s)
        s = reg_note.sub('-', s)
        s = reg_ignore.sub('', s)
        s = reg_ignore2.sub('', s)
        s = reg_eof.sub('', s)
        f_out.write(s)
        return True
    except Exception, e:
        return False
    finally:
        f_out.close()
        f_in.close()

fname = sys.stdin.read().strip()

reg_ignore = re.compile('\xee\x80\x83|\xee\x80\x85|\xe3\x80\x93|\xe3\x80\x96.{2,5}\xe3\x80\x97|!?\xe3\x80\x96FJJ\xe3\x80\x97|\r\n|\r')
reg_ignore2 = re.compile('!?\xe3\x80\x96FJ.\xe3\x80\x97')
reg_newline = re.compile('\xee\x80\x84|\xe3\x80\x96HT.{2,3}\xe3\x80\x97')
reg_space = re.compile('\xe3\x80\x93\xe3\x80\x93|\xe3\x80\x96\xe3\x80\x97')
reg_note = re.compile('\xe2\x96\xb2')
reg_point = re.compile('\xee\x80\x90')
reg_eof = re.compile('\x1a')

transfer()
