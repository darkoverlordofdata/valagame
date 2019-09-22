#!/usr/bin/env bash
#
# Set up dev environment
#
#   modules must be installed with bower link
#
doran install

rm -rf /home/darkoverlordofdata/Documents/GitHub/valagame/.lib/artemis
doran install --link artemis

rm -rf /home/darkoverlordofdata/Documents/GitHub/valagame/.lib/jasmine
doran install --link jasmine

rm -rf /home/darkoverlordofdata/Documents/GitHub/valagame/.lib/system
doran install --link system

rm -rf /home/darkoverlordofdata/Documents/GitHub/valagame/.lib/xna.framework
doran install --link xna.framework

rm -rf /home/darkoverlordofdata/Documents/GitHub/valagame/.lib/zerog
doran install --link zerog
