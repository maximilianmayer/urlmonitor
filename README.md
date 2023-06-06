# urlmonitor
A simple monitor for tracking changes on single webpages

## usage

use cli.rb to run urlmonitor. Syntax is as easy as possible.  

There are some options available: `init`, `check`, `list`and `delete`.

### examples
check a url which hasn't been checked before.
```shell script
$ urlmon check --url https://www.google.com
Website to check: https://www.google.com
last checked: 2020-04-22 12:06:49 +0200
http status: 200
check status: new
```

list all monitored urls
```shell script
$ urlmon  list
```



## planned features
- manage pages (add, remove)
- run as webservice
- run scheduled page checks
- alerting via telegram
- some (nice) web-ui
