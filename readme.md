# Stone-test
 * Test project with default structure using [WalnutJS](https://github.com/mmendesas/walnutjs).

 [![Codacy Badge](https://api.codacy.com/project/badge/Grade/6f7a6886fa434657b9956ac7adf4279d)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=andresakai/stone-test&amp;utm_campaign=Badge_Grade)

![License](https://img.shields.io/npm/l/walnutjs.svg?style=flat-square)

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/dwyl/esta/issues)


## Setup of this project

Make the clone of the project:

```
$ git clone git@github.com:andresakai/stone-test.git
$ cd /<path>/stone-test/
```

Inside params folder:

```
$ cd /<path>/stone-test/test/params
```

You must rename params.json.dist to params.json, and change to the correct parameters, ie:
```
{
    "name": "stone-test",
    "default":{
        "base_url": "https://sandbox-accounts.openbank.stone.com.br",
        "api_url": "https://sandbox-api.openbank.stone.com.br",
        "username": "YYYYYYYYY",
        "password": "ZZZZZZZZZ"
    }
}
```
** Please, note that username (YYYYYYYYY) and password (ZZZZZZZZZ) must be created before running these tests, otherwise these test will not run. If the account has already transactions or transfers, some tests will fail.

** To successfully run these test, must be a new account, with password created, and a $1000,00 account balance.

## Local

### Pre-Requisites

Before start, you need to install the following programs:

* [java](https://www.java.com/en/download/)
* [node](https://nodejs.org)
* [webdriver-manager](https://www.npmjs.com/package/webdriver-manager)
* [protractor](http://www.protractortest.org/#/)

### Installing

Use this few steps to install JAVA and set JAVA_HOME
```
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer
```

1. Get the JRE path `sudo update-alternatives --config java`
2. Set in the file and update:
    - $ sudo nano /etc/environment
    - `JAVA_HOME="/usr/lib/jvm/java-8-oracle"`
    - $ source /etc/environment


Install the dependencies of the project

```
$ npm install
```

### Running the tests

For execution just run these following commands

```
$ webdriver-manager update
$ webdriver-manager start
```
Inside the project folder:
```
$ protractor protractor.conf.js
```

## Using Docker

### Pre-Requisites

Docker: https://docs.docker.com/

### Usage

In the root folder of this project:
```
$ cd <path>/stone-test/
```

Run this command to run your tests using a docker container:
```
$ docker run --rm -v $(pwd):/bdd andresakai/docker-protractor:latest protractor.conf.js <args>
```
Check wich tag for docker container you can use in your test run: https://cloud.docker.com/repository/docker/andresakai/docker-protractor/tags

For "args" (optional), you can use to override default values in protractor.conf.js:
--cucumberOpts.tags (to change tags that will run tests, without changing protractor.conf.js)

Tags used in this project:
@stone - run all features and scenarios (default)
@account - run account feature tests
@balance - run balance feature tests
@statement - run statement feature tests
@internal_simulation - run simulation transfer feature tests

## Test Run Results

In your terminal, after the test run, there will be a summary:
```
9 scenarios (9 passed)
199 steps (199 passed)
0m38.790s
```

The result is generated in the folder test:
```
$ cat /<path>/stone-test/test/results.json
```

This file describes the test run, where:
 - "description": Scenario name
 - "assertions": boolean value if step was successfull (true) or not (false)
