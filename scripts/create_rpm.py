#!/usr/bin/env python
import os
import sys
import logging
import subprocess


def create_rpm(app, version='dev'):
    base_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    fpm_cmd = 'cd /data; fpm -s dir -t rpm --prefix /usr/local/bin/ -n %(name)s -v %(version)s %(name)s' % {'name': app, 'version': version}
    cmd = 'docker run --rm -v %s:/data feiyuw/fpm bash -c "%s"' % (base_root, fpm_cmd)
    subprocess.check_output(cmd, shell=True)


if __name__ == '__main__':
    if len(sys.argv[1:]) < 1:
        logging.error('Usage: python create_rpm.py <app> [version]')
        sys.exit(1)
    app = sys.argv[1]
    version = len(sys.argv[1:]) > 1 and sys.argv[2] or 'dev'
    create_rpm(app, version)
