#!/bin/bash
npm install

webdriver-manager update

webdriver-manager start --detach --seleniumPort=80 && xvfb-run -a --server-args='-screen 0 1920x1080x24' protractor $@