#!/usr/bin/env python
# -*- coding: utf8 -*-
import os
import shutil
# from code_protection import ObjectCodeBuilder


# 建置授權版本或非授權版本
LICENSE_MODE = os.environ.get('LICENSE_MODE', 'src')  # ['dongle', 'cloud', 'date', 'bin', 'src', 'hw-date']
assert LICENSE_MODE in ['dongle', 'cloud', 'date', 'bin', 'src', 'hw-date'], f'{LICENSE_MODE} not supported.'
PROJECT_DIR_BASENAME = 'app'

stage_dir = '{}_stage'.format(PROJECT_DIR_BASENAME)
build_dir = '{}_build'.format(PROJECT_DIR_BASENAME)

if os.path.exists(stage_dir):
    shutil.rmtree(stage_dir)
if os.path.exists(build_dir):
    shutil.rmtree(build_dir)

if LICENSE_MODE == 'src':  # source code mode.
    # 直接複製到 build, 結束
    shutil.copytree(PROJECT_DIR_BASENAME, build_dir)
else:
    raise Exception(f'LICENSE_MODE={LICENSE_MODE} not supported.')